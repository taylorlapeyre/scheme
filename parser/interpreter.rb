require 'pry'
require_relative '../lang/literals'
require_relative '../lang/special_forms'
require_relative '../lang/builtins'

module Scheme
  class Environment
    def initialize(env=nil)
      @state = {}
      @env = env
    end

    def pprint
      puts @state
    end

    def define(key, val)
      @state.store(key.name, val)
    end

    def lookup(key)
      val = @state[key.name]

      if val
        val
      else
        if @env.nil?
          # we're in the global scope and can't find what it is
          puts "Unable to find #{key} in current context."
          Scheme::Nil.instance
        else
          @env.lookup(key)
        end
      end
    end

    def define_built_in_procedures
      ["b+", "b-", "b*", "b/", "b="].each do |name|
        define(Scheme::Ident.new(name), BuiltIn.new(name))
      end
    end
  end

  class Closure
    def initialize(arguments, body, env)
      @env = env
      @body = body
      @arguments = arguments
    end

    def is_procedure?
      true
    end

    def apply(values)
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
