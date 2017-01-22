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

$stdout.write(
  Liquid::Cli.new(ARGV.first || '{}').render($stdin.read)
)
