require_relative 'environment'

module Scheme
  class Closure
    def initialize(arguments, body, env)
      @env = env
      @body = body
      @arguments = arguments
    end

    def is_procedure?
      true
    end

    def apply(values, env)
      arguments = @arguments
      closure_env = Scheme::Environment.new(@env)

      until values.is_null? || arguments.is_null?
        name  = arguments.first
        value = values.first
        closure_env.define(name, value.evaluate(@env))

        arguments = arguments.rest
        values    = values.rest
      end

      @body.evaluate(closure_env)
    end

    def pprint(n)
      print "<CLOSURE>"
    end
  end
end
