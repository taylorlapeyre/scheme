require_relative '../lang/literals'
require_relative '../scanner/scanner'
require 'pry'

module Scheme
  class Parser
    def initialize(input)
      @scanner = Scheme::Scanner.new(input)
    end

    def pretty_print
      root = parse_next_exp
      while root
        root.pprint(0)
        root = parse_next_exp
      end
    end

    def parse_next_exp
      token = @scanner.get_next_token
      parse_exp(token)
    end

    def parse_exp(token)
      return token if token.nil?

      case token.type
      when :LPAREN
        parse_rest
      when :TRUE
        Scheme::BooleanLit.new(true)
      when :FALSE
        Scheme::BooleanLit.new(false)
      when :QUOTE
        Scheme::Cons.new(
          Scheme::Ident.new("quote"),
          Scheme::Cons.new(parse_next_exp, Scheme::Nil.instance)
        )
      when :INTEGER
        Scheme::IntegerLit.new(token.get_integer_val)
      when :STRING
        Scheme::StringLit.new(token.get_string_val)
      when :IDENT
        Scheme::Ident.new(token.get_name)
      else
        puts "Something broke parse_exp"
        nil
      end
    end

    def parse_rest
      token = @scanner.get_next_token
      case token.type
      when :RPAREN
        Scheme::Nil.instance
      when :DOT
        Scheme::Cons.new(parse_next_exp, parse_rest)
      else
        Scheme::Cons.new(parse_exp(token), parse_rest)
      end
    end
  end
end
