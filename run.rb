require 'json'
require 'liquid'

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
    @variables = variables_from_string(markup)
  end

  def render(context)
    #context.registers[:page]['slottime'] ||= Hash.new(0)
    # context.stack do
    #   slot = context.evaluate(@variables[0]).to_s
    #   time = context.evaluate(@variables[1]).to_s
    #   context.register[:page]['slottime'][slot] = time
    #   time
    # end
    @variables[0].to_s
  end

  def variables_from_string(markup)
    markup.split(',').collect do |var|
      var =~ /\s*(#{Liquid::QuotedFragment})\s*/o
      $1 ? Liquid::Expression.parse($1) : nil
    end.compact
  end  
end
Liquid::Template.register_tag('savetime', SaveTime)

$stdout.write(
  Liquid::Cli.new(ARGV.first || '{}').render($stdin.read)
)
