require_relative 'literals'
require 'pry'

module Scheme
  class BuiltIn

    def initialize(name)
      @name = name
    end

    def is_procedure?
      true
    end

    def extract_args(argument_node, env, vals=[])
      if argument_node.is_null?
        vals
      else
        arg = argument_node.first
        vals << arg.evaluate(env) unless arg.is_null?
        extract_args(argument_node.rest, env, vals)
      end
    end

    def apply(arguments, env)
      args = extract_args(arguments, env)

      case @name
      when "b+"
        bplus(*args)
      when "b-"
        bminus(*args)
      when "b*"
        bmult(*args)
      when "b/"
        bdiv(*args)
      when "b="
        bequals(*args)
      end
    end

    def bplus(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::IntegerLit.new(arg1.val + arg2.val)
      else
        throw "Arguments to b+ must be numbers."
      end
    end

    def bminus(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::IntegerLit.new(arg1.val - arg2.val)
      else
        throw "Arguments to b- must be numbers."
      end
    end

    def bmult(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::IntegerLit.new(arg1.val * arg2.val)
      else
        throw "Arguments to b* must be numbers."
      end
    end

    def bdiv(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::IntegerLit.new(arg1.val / arg2.val)
      else
        throw "Arguments to b/ must be numbers."
      end
    end

    def bequals(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::IntegerLit.new(arg1.val == arg2.val)
      else
        throw "Arguments to b= must be numbers."
      end
    end
  end
end
