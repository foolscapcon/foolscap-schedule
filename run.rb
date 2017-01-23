require 'json'
require 'liquid'
require 'pry'


module Liquid
  class Cli
    def initialize(json_context)
      @context = JSON.parse(json_context)
    end

    def render(input)
      Template.parse(input).render(context, :error_mode => :strict)
    end

    private

    attr_reader :context
  end
end

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
