require 'singleton'
require_relative 'specialforms'

module Scheme
  class Node
    def pprint
      puts "Why am I in Scheme::Node#pprint ?"
    end

    def is_boolean?
      false
    end

    def is_integer?
      false
    end

    def is_string?
      false
    end

    def is_symbol?
      false
    end

    def is_null?
      false
    end

    def is_pair?
      false
    end

    def is_procedure?
      false
    end
  end

  class BooleanLit < Node
    attr_reader :val

    def initialize(b)
      @val = b
    end

    def pprint(n)
      print(' ' * n)
      print(@val ? '#t' : '#f')
    end

    def is_boolean?
      true
    end

    def evaluate(env)
      self
    end
  end

  class StringLit < Node
    attr_reader :val

    def initialize(s)
      @val = s
    end

    def pprint(n)
      print(' ' * n)
      print('"', @val, '"')
    end

    def is_string?
      true
    end

    def evaluate(env)
      self
    end
  end

  class IntegerLit < Node
    attr_reader :val

    def initialize(i)
      @val = i
    end

    def pprint(n)
      print(' ' * n)
      print @val
    end

    def is_integer?
      true
    end

    def evaluate(env)
      self
    end
  end

  class Nil
    include Singleton

    def pprint(n, p=false)
      print(' ' * n)
      print(p ? ')' : '()')
    end

    def is_null?
      true
    end

    def evaluate(env)
      self
    end
  end

  class Ident < Node
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def pprint(n)
      print(' ' * n)
      print @name
    end

    def is_symbol?
      true
    end

    def evaluate(env)
      env.lookup(self)
    end
  end

  class Cons < Node
    attr_reader :first, :rest

    def initialize(first, rest)
      @first, @rest = first, rest
    end

    def parse_list
      if @first.is_symbol?
        name = @first.name
        case name
        when 'quote'
          Scheme::Quote.new
        when 'lambda'
          Scheme::Lambda.new
        when 'begin'
          Scheme::Begin.new
        when 'if'
          Scheme::If.new
        when 'let'
          Scheme::Let.new
        when 'cond'
          Scheme::Cond.new
        when 'define'
          Scheme::Define.new
        when 'set!'
          Scheme::Setbang.new
        else
          Scheme::Regular.new
        end
      else
        Scheme::Regular.new
      end
    end

    def pprint(n, p=false)
      parse_list.pprint(self, n, p)
    end

    def is_pair?
      true
    end

    def evaluate(env)
      parse_list.evaluate(self, env)
    end
  end
end
