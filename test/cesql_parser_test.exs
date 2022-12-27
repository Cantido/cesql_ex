defmodule CESQL.ParserTest do
  use ExUnit.Case, async: true

  test "integer literals" do
    assert parse("420") == {:ok, 420}
  end

  test "boolean literals" do
    assert parse("true") == {:ok, true}
    assert parse("false") == {:ok, false}
  end

  test "single-quoted string literals" do
    assert parse("'hello'") == {:ok, '\'hello\''}
  end

  test "double-quoted string literals" do
    assert parse("\"hello\"") == {:ok, '\"hello\"'}
  end

  test "AND expression" do
    assert parse("a AND b") ==  {:ok, {{:keyword, 1, 'a'}, :keyword_and, {:keyword, 1, 'b'}}}
  end

  test "complex binary expression" do
    assert parse("firstname = 'Rosa' AND lastname = 'Richter'") ==
      {:ok, {
        {{:keyword, 1, 'firstname'}, :comparison_eq, '\'Rosa\''},
        :keyword_and,
        {{:keyword, 1, 'lastname'}, :comparison_eq, '\'Richter\''}
      }}

  end
  
  defp parse(str) do
    {:ok, tokens, _} = str |> String.to_charlist() |> :cesql_lexer.string()
    :cesql_parser.parse(tokens)
  end
end
