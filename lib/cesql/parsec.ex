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

  expression = choice([literal, value_identifier])

  defparsec :expression, expression

end
