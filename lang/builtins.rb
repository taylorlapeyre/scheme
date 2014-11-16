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

    def count_arguments(args)
      if args.is_null?
        0
      else
        val = args.first.is_null? ? 0 : 1
        val + count_arguments(args.rest)
      end
    end

    def apply(list, env)
      num_args = count_arguments(list)

      void_builtins = ["newline", "read", "interaction-environment", "exit"]

      unary_builtins = ["number?", "symbol?", "null?","pair?", "procedure?",
                        "car", "cdr", "display", "write"]

      binary_builtins = ["b+", "b-", "b*", "b/", "b<", "b>", "set-car!", "set-cdr!",
                         "b=", "cons", "eq?", "apply"]

      if void_builtins.include?(@name)
        throw "Invalid Arguments (#{num_args})" unless num_args == 0
      elsif unary_builtins.include?(@name)
        throw "Invalid Arguments (#{num_args})" unless num_args == 1
      elsif binary_builtins.include?(@name)
        throw "Invalid Arguments (#{num_args})" unless num_args == 2
      else
        throw "Invalid Arguments (#{num_args})"
      end

      arg1 = list.first.evaluate(env)      unless list.first.is_null?
      arg2 = list.rest.first.evaluate(env) unless list.rest.is_null?

      case @name
      when "b+"         then bplus(arg1, arg2)
      when "b-"         then bminus(arg1, arg2)
      when "b*"         then bmult(arg1, arg2)
      when "b/"         then bdiv(arg1, arg2)
      when "b="         then bequals(arg1, arg2)
      when "b>"         then bgreaterthan(arg1, arg2)
      when "b<"         then blessthan(arg1, arg2)
      when "number?"    then number?(arg1)
      when "symbol?"    then symbol?(arg1)
      when "null?"      then null?(arg1)
      when "pair?"      then pair?(arg1)
      when "procedure?" then procedure?(arg1)
      when "car"        then car(arg1)
      when "cdr"        then cdr(arg1)
      when "set-car!"   then set_car!(arg1, arg2)
      when "set-cdr!"   then set_cdr!(arg1, arg2)
      when "cons"       then cons(arg1, arg2)
      when "eq?"        then eq?(arg1, arg2)
      when "display"    then display(arg1)
      when "apply"      then scheme_apply(arg1, arg2)
      when "read"       then read(env)
      when "newline"    then newline
      when "write"      then write(arg1)
      when "interaction-environment" then env
      when "exit" then exit
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
        Scheme::BooleanLit.new(arg1.val == arg2.val)
      else
        throw "Arguments to b= must be numbers."
      end
    end

    def bgreaterthan(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::BooleanLit.new(arg1.val > arg2.val)
      else
        throw "Arguments to b> must be numbers."
      end
    end

    def blessthan(arg1, arg2)
      if arg1.is_integer? && arg2.is_integer?
        Scheme::BooleanLit.new(arg1.val < arg2.val)
      else
        throw "Arguments to b< must be numbers."
      end
    end

    def number?(arg1)
      Scheme::BooleanLit.new(arg1.is_integer?)
    end

    def symbol?(arg1)
      Scheme::BooleanLit.new(arg1.is_symbol?)
    end

    def null?(arg1)
      Scheme::BooleanLit.new(arg1.is_null?)
    end

    def pair?(arg1)
      Scheme::BooleanLit.new(arg1.is_pair?)
    end

    def procedure?(arg1)
      Scheme::BooleanLit.new(arg1.is_procedure?)
    end

    def car(arg1)
      arg1.is_null? ? arg1 : arg1.first
    end

    def cdr(arg1)
      arg1.is_null? ? arg1 : arg1.rest
    end

    def set_car!(arg1, arg2)
      arg1.set_car(arg2)
    end

    def set_cdr!(arg1, arg2)
      arg1.set_car(arg2)
    end

    def cons(arg1, arg2)
      Scheme::Cons.new(arg1, arg2)
    end

    def eq?(arg1, arg2)
      if arg1.is_symbol? && arg2.is_symbol?
        Scheme::BooleanLit.new(arg1.name == arg2.name)
      else
        Scheme::BooleanLit.new(arg1.val == arg2.val)
      end
    end

    def display(arg1)
      arg1
    end

    def scheme_apply(arg1, arg2)
      if arg1.is_procedure?
        arg1.apply(arg2)
      else
        throw "Cannot apply arguments to non-procedure."
      end
    end

    def newline
      puts
      Scheme::Nil.instance
    end

    def read(env)
      parser = Scheme::Parser.new(gets.chomp)
      parser.parse_next_exp.evaluate(env)
    end

    def write(arg1)
      arg1.pprint(0)
    end

    def pprint(n)
      print "<BUILTIN>"
    end
  end
end
