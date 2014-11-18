require_relative 'literals'
require_relative 'builtins'

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
          puts "Unable to find #{key.name} in current context."
          Scheme::Nil.instance
        else
          @env.lookup(key)
        end
      end
    end

    def define_built_in_procedures
      builtins =  ["b+", "b-", "b*", "b/", "b=", "b>", "b<", "number?", "symbol?",
        "null?", "pair?", "procedure?", "car", "cdr", "set-car!", "set-cdr!", "cons",
        "eq?", "display", "apply", "read", "newline", "write",
        "interaction-environment", "exit"]

      builtins.each do |name|
        define(Scheme::Ident.new(name), BuiltIn.new(name))
      end
    end
  end
end
