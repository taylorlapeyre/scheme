require "minitest/autorun"
require_relative "../parser/parser"
require_relative "../parser/interpreter"

class TestParser < Minitest::Test
  make_my_diffs_pretty!

  GLOBAL_ENV = Scheme::Environment.new

  def setup
    GLOBAL_ENV.define_built_in_procedures
  end

  def test_quote
    parser = Scheme::Parser.new("'(1 2 3)")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::Cons, result
    assert_equal result.first.val, 1
  end

  def test_let
    parser = Scheme::Parser.new("(let ((x 5) (y 2)) (b+ x y))")
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 7
  end

  def test_if
    parser = Scheme::Parser.new('(if #t "hello" "world")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "hello"

    parser = Scheme::Parser.new('(if #f "hello" "world")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "world"

    parser = Scheme::Parser.new('(if (number? 2) "hello" "world")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "hello"
  end

  def test_begin
    parser = Scheme::Parser.new('(begin (number? 1) "it works")')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "it works"
  end

  def test_define
    parser = Scheme::Parser.new('(begin (define x 1) (number? x))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true

    parser = Scheme::Parser.new('(begin (define (square x) (b* x x)) (number? (square x)))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true
  end

  def test_lambda
    parser = Scheme::Parser.new('(begin (define addone (lambda (x) (b+ x 1))) (number? (addone 1)))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::BooleanLit, result
    assert_equal result.val, true
  end

  def test_cond
    parser = Scheme::Parser.new('(cond ((eq? "lol" "lolol") "nope") ((eq? 1 1) "yep"))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "yep"

    parser = Scheme::Parser.new('(cond ((eq? "lol" "lol") "yep") ((eq? 1 1) "nope"))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "yep"

    parser = Scheme::Parser.new('(cond ((eq? 1 2) "nope") (else "yep"))')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::StringLit, result
    assert_equal result.val, "yep"
  end

  def test_set!
    parser = Scheme::Parser.new('(begin (define x 1) (set! x 2) x)')
    result = parser.parse_next_exp.evaluate(GLOBAL_ENV)
    assert_kind_of Scheme::IntegerLit, result
    assert_equal result.val, 2
  end
end
