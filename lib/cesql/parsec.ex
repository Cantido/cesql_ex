defmodule CESQL.Parsec do
  import NimbleParsec
  

  value_identifier =
    ascii_string([?a..?z], min: 1, max: 20)
    |> unwrap_and_tag(:value_identifier)
    |> label("value identifier")

  boolean_literal =
    choice([string("true"), string("false")])
    |> unwrap_and_tag(:boolean_literal)
    |> label("boolean literal")

  number_literal =
    integer(min: 1)
    |> unwrap_and_tag(:number_literal)
    |> label("number literal")

  single_quoted_string_literal = 
    empty()
    |> ignore(ascii_char([?']))
    |> repeat(choice([
      utf8_char(not: ?'),
      string("\\'")
    ]))
    |> ignore(ascii_char([?']))
    |> reduce({List, :to_string, []})

  double_quoted_string_literal =
    empty()
    |> ignore(ascii_char([?"]))
    |> repeat(choice([
      utf8_char(not: ?"),
      string(~s(\\"))
    ]))
    |> ignore(ascii_char([?"]))
    |> reduce({List, :to_string, []})

  string_literal =
    choice([single_quoted_string_literal, double_quoted_string_literal])
    |> unwrap_and_tag(:string_literal)
    |> label("string literal")

  literal = choice([boolean_literal, number_literal, string_literal])


  not_operator = string("NOT") 

  unary_logic_operator = not_operator
  unary_numeric_operator = string("-")
  unary_operation =
    choice([
      unary_numeric_operator |> ignore(optional(string(" "))),
      unary_logic_operator |> ignore(string(" "))
    ])
    |> parsec(:expression)
    |> label("unary operation")

  binary_logic_operator =
    choice([
      string("AND"),
      string("OR"), 
      string("XOR")
    ])
    |> lookahead(string(" "))
    |> label("binary logic operation")

  binary_comparison_operator =
    choice([
      string("="),
      string("!="),
      string("<>"),
      string(">="),
      string("<="),
      string("<"),
      string(">")
    ])
    |> label("binary comparison operator")

  binary_numeric_arithmetic_operator =
    choice([
      string("+"),
      string("-"),
      string("*"),
      string("/"),
      string("%")
    ])
    |> label("binary arithmetic operator")

  binary_operation =
    parsec(:expression)
    |> ignore(string(" "))
    |> choice([
      binary_comparison_operator,
      binary_numeric_arithmetic_operator,
      binary_logic_operator
    ])
    |> ignore(string(" "))
    |> parsec(:expression)

  parenthetical_expression =
    ignore(string("("))
    |> parsec(:expression)
    |> ignore(string(")"))

  expression = choice([
    literal, 
    value_identifier,
    parenthetical_expression,
    unary_operation,
    binary_operation, 
  ])

  defparsec :expression, expression
end
