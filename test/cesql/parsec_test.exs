defmodule CESQL.ParsecTest do
  use ExUnit.Case, async: true
  doctest CESQL.Parsec

  test "value identifiers are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("firstname")

    assert tree == [value_identifier: "firstname"]
  end

  test "boolean literals are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("true")

    assert tree == [boolean_literal: "true"]
  end

  test "number literals are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("420")

    assert tree == [number_literal: 420]
  end

  test "single-quoted string literals are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("'hello'")

    assert tree == [string_literal: "hello"]
  end

  test "double-quoted string literals are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression(~s("hello"))

    assert tree == [string_literal: "hello"]
  end

  test "parenthetical expressions are expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression(~s[("hello")])

    assert tree == [string_literal: "hello"]
  end

  test "unary logic expressions are valid expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("NOT true")

    assert tree == ["NOT", {:boolean_literal, "true"}]
  end
  
  test "unary numeric expressions are valid expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("-420")

    assert tree == ["-", {:number_literal, 420}]
  end

  test "binary AND expressions are valid expressions" do
    {:ok, tree, "", _, _, _} = CESQL.Parsec.expression("a AND b")

    assert tree == [{:value_identifier, "a"}, "AND", {:value_identifier, "b"}]
  end
  
end
