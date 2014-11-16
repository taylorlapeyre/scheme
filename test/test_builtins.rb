require "minitest/autorun"
require_relative "../parser/parser"
require_relative "../lang/environment"

class TestParser < Minitest::Test
  make_my_diffs_pretty!

  GLOBAL_ENV = Scheme::Environment.new

  def setup
    GLOBAL_ENV.define_built_in_procedures
  end

  def test_bplus
    parser = Scheme::Parser.new("(b+ 1 4)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 5
  end

  def test_bminus
    parser = Scheme::Parser.new("(b- 5 2)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 3
  end

  def test_bmult
    parser = Scheme::Parser.new("(b* 7 2)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 14
  end

  def test_bdiv
    parser = Scheme::Parser.new("(b/ 8 4)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 2
  end

  def test_bequals
    parser = Scheme::Parser.new("(b= 1 1)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new("(b= 1 2)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_bgreaterthan
    parser = Scheme::Parser.new("(b> 3 1)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new("(b> 1 3)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_blessthan
    parser = Scheme::Parser.new("(b< 1 3)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new("(b< 3 1)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_number?
    parser = Scheme::Parser.new("(number? 3)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(number? "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_symbol?
    parser = Scheme::Parser.new("(symbol? 'hello)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(symbol? "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_null?
    parser = Scheme::Parser.new("(null? '())")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(null? "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_pair?
    parser = Scheme::Parser.new("(pair? '(1 2))")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(pair? "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_procedure?
    parser = Scheme::Parser.new("(procedure? b+)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(procedure? "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false
  end

  def test_car
    parser = Scheme::Parser.new("(car '(1 2))")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 1
  end

  def test_cdr
    parser = Scheme::Parser.new("(cdr '(1 2))")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::Cons, result
    assert_equal result.first.val, 2
  end

  def test_eq?
    parser = Scheme::Parser.new("(eq? 1 1)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(eq? 1 "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, false

    parser = Scheme::Parser.new("(eq? 'hello 'hello)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(eq? "hello" "hello")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true
  end

  # def test_apply
  #   parser = Scheme::Parser.new("(apply b+ '(1 2))")
  #   result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
  #   assert_kind_of Scheme::IntegerLit, result
  #   assert_equal result.val, 3
  # end
end
