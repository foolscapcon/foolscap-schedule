require 'json'
require 'liquid'


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
  
module FoolscapScheduleFilters
  def hash(hash, key)
    if hash and key
      hash[key]
    end
  end

  def room_to_column(room)
    if room and @context['schedule']['room'].key?(room)
      @context['schedule']['room'][room]['column']
    else
      "2/-1"
    end
  end

  def column_to_room(column)
    if column
      for _,values in @context['schedule']['room']
        if values['column'] == column
          return values
        end
      end
    end
    ""
  end

  def event_anchor(*args)
    args.join "-"
  end

  # rows are on the 1/2 hour

  def time_to_row(hour_s, day, hour_end_s = nil, hour_subdivisions = 2, start_row = 2)
    hour = hour_s.to_f
    hour_end = (hour_end_s.nil?) ? nil : hour_end_s.to_f

    start_time = @context['schedule']['day-time-ranges'][day]['start-time'].to_f
    event_start_row = start_row +
                      hour_subdivisions*(hour - start_time)
    event_end_row = event_start_row + hour_subdivisions if not hour_end
    event_end_row = start_row +
                    hour_subdivisions*(hour_end - start_time) + hour_subdivisions if hour_end

    # local_variables.each { |sym| puts sym.to_s + " " + eval(sym.to_s).inspect }
    #binding.pry if hour.modulo(1) > 0

#     hour_s "19.5"
# day "Saturday"
# hour_end_s "21.5"
# hour_subdivisions 2
# start_row 2
# hour 19.5
# hour_end 21.5
# start_time 10.0
# event_start_row 21.0
# event_end_row 27.0
    # goes into the begining of specified row
    "#{event_start_row.to_i}/#{event_end_row.to_i}"

  end

  def default_name(*args)
    input = args[0]
    if !input || input.respond_to?(:empty?) && input.empty?
      args.drop(1).join(" ")
    else
      input
    end
  end
end

Liquid::Template.register_filter(FoolscapScheduleFilters)

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

out.write( Liquid::Cli.new(json.read || '{}').render(template.read) )
