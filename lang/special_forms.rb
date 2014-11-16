require_relative '../parser/interpreter'
require_relative 'literals'
require 'pry'

module Scheme
  class Quote
    def evaluate(node, env)
      node.rest.first
    end
  end

  class Lambda
    def evaluate(node, env)
      args = node.rest.first
      body = node.rest.rest.first
      Scheme::Closure.new(args, body, env)
    end
  end

  class Begin
    def evaluate(node, env)
      expressions = node.rest
      val = expressions.first.evaluate(env)
      until expressions.is_null?
        val = expressions.first.evaluate(env)
        expressions = expressions.rest
      end
      val
    end
  end

  class Let
    def evaluate(node, env)
      assignments = node.rest.first
      body = node.rest.rest.first
      let_env = Scheme::Environment.new(env)

      until assignments.is_null?
        assignment = assignments.first
        key = assignment.first
        value = assignment.rest.first
        let_env.define(key, value.evaluate(env))
        assignments = assignments.rest
      end

      body.evaluate(let_env)
    end
  end

  class Cond
    def evaluate(node, env)
      forms = node.rest
      result = Scheme::Nil.instance

      until forms.is_null?
        cond_condition = forms.first.first
        if cond_condition.evaluate(env).val
          result = forms.first.rest.first.evaluate(env)
          break
        else
          forms = forms.rest
        end
      end
      result
    end
  end

  class If
    def evaluate(node, env)
      predicate  = node.rest.first
      if_clause   = node.rest.rest.first
      else_clause = node.rest.rest.rest.first

      if predicate.evaluate(env).val
        if_clause.evaluate(env)
      else
        else_clause.evaluate(env)
      end
    end
  end

  class Regular
    def evaluate(node, env)
      symbol = env.lookup(node.first)
      arguments = node.rest

      if arguments.is_null?
        arguments = Scheme::Cons.new(Scheme::Nil.instance, Scheme::Nil.instance)
      end

      if symbol.is_procedure?
        symbol.apply(arguments, env)
      else
        symbol.evaluate(env)
      end
    end
  end

  class Define
    def evaluate(node, env)
      name  = node.rest.first
      value = node.rest.rest.first

      if name.is_symbol?
        env.define(name, value.evaluate(env))
      else
        args = name.rest
        name = name.first
        body = value

        procedure = Scheme::Closure.new(args, body, env)
        env.define(name, procedure)
      end
      name
    end
  end

  class Setbang
    def evaluate(node, env)
      name  = node.rest.first
      value = node.rest.rest.first
      env.define(name, value)
    end
  end
end
