require 'json'
require 'liquid'
#require 'pry'


module Liquid
  class Cli
    def initialize(json_context)
      @context = JSON.parse(json_context)
    end

    def render(input)
      template = Template.parse(input, :error_mode => :strict)
      template.render!(context, {
                  strict_variables: false,
                  strict_filters: true
                }
                     )
      #File.open("liq.error", 'w') { |file| file.puts(template.errors.to_s) }
      #$stderr.puts template.errors
    end

    private

    attr_reader :context
  end
end

module RoomToColumn 
  def room_to_column(room)
    @context['schedule']['room'][room]['column']
  end
end

Liquid::Template.register_filter(RoomToColumn)

module TimeToRow
  def time_to_row(input, string)
    time = input.to_i
    day = string
    start_time = @context['schedule']['day-time-ranges'][day]['start-time'].to_i
    2 + time - start_time
    #" day " + day.to_s + " time " + time.to_s + " start_time " + start_time.to_s
  end
end

Liquid::Template.register_filter(TimeToRow)


 
module DefaultName
  def default_name(input, first, verb, last)
      if !input || input.respond_to?(:empty?) && input.empty?
        first.to_s + " " + verb.to_s + " " + last.to_s 
      else
        input
      end
  end
end

Liquid::Template.register_filter(DefaultName)

class Save < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    super

    @name, @value = variables_from_string(markup)
  end

  def render(context)
    #binding.pry    
    context.registers[:savevalue] ||= Hash.new(0)
    if @value
      context.stack do
        name = context.evaluate(@name).to_s
        value = context.evaluate(@value).to_s
        context.registers[:savevalue][name] = value
      end
      return
    else
      #binding.pry
      context.stack do
        name = context.evaluate(@name)
        context.registers[:savevalue][name]
      end
    end
  end
    
  def variables_from_string(markup)
    markup.split(',').collect do |var|
      var =~ /\s*(#{Liquid::QuotedFragment})\s*/o
      $1 ? Liquid::Expression.parse($1) : nil
    end.compact
  end  
end
Liquid::Template.register_tag('save', Save)

files = ARGV
json = nil
template = $stdin
out = $stdout
if files.empty?
  $stderr.write("json filename not supplied")
elsif files.size == 1
  json = File.open(files.pop)
elsif files.size == 2
  json = File.open(files.pop)  
  template = File.open(files.pop)
else
  out = File.open(files.pop, 'w')
  json = File.open(files.pop)  
  template = File.open(files.pop)
end
      
out.write(
  Liquid::Cli.new(json.read || '{}').render(template.read)
)
