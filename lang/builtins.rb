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

    def apply(arguments)
      case @name
      when "b+"
        bplus(arguments.first, arguments.rest.first)
      when "b-"
        bminus(arguments.first, arguments.rest.first)
      when "b*"
        bmult(arguments.first, arguments.rest.first)
      when "b/"
        bdiv(arguments.first, arguments.rest.first)
      when "b="
        bequals(arguments.first, arguments.rest.first)
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
