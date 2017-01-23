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

class SaveTime < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    super

    @slot, @time = variables_from_string(markup)
  end

  def render(context)
    #binding.pry    
    context.registers[:slottime] ||= Hash.new(0)
    context.stack do
      slot = context.evaluate(@slot).to_s
      time = context.evaluate(@time).to_s
      context.registers[:slottime][slot] = time
      time
    end
    return
  end

  def variables_from_string(markup)
    markup.split(',').collect do |var|
      var =~ /\s*(#{Liquid::QuotedFragment})\s*/o
      $1 ? Liquid::Expression.parse($1) : nil
    end.compact
  end  
end
Liquid::Template.register_tag('savetime', SaveTime)

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
