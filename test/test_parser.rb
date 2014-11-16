require "minitest/autorun"
require_relative "../parser/parser"

class TestParser < Minitest::Test
  make_my_diffs_pretty!

  def test_it_can_parse_an_identifier
    parser = Scheme::Parser.new("testing")
    root = parser.parse_next_exp
    assert_kind_of Scheme::Ident, root
    assert_equal root.name, "testing"
  end

  def test_it_can_parse_a_boolean_constant
    parser = Scheme::Parser.new("#t #f")
    root = parser.parse_next_exp
    assert_kind_of Scheme::BooleanLit, root
    assert_equal root.val, true
    root = parser.parse_next_exp
    assert_kind_of Scheme::BooleanLit, root
    assert_equal root.val, false
  end

  def test_it_can_parse_an_integer_constant
    parser = Scheme::Parser.new("124")
    root = parser.parse_next_exp
    assert_kind_of Scheme::IntegerLit, root
    assert_equal root.val, 124
  end

  def test_it_can_create_a_cons
    parser = Scheme::Parser.new("(hello)")

    root = parser.parse_next_exp
    assert_kind_of Scheme::Cons, root
    assert_kind_of Scheme::Ident, root.first
    assert_kind_of Scheme::Nil, root.rest

    root = parser.parse_next_exp
    assert_nil root
  end
end
