defmodule CESQL do
  @moduledoc """
  Documentation for `CESQL`.
  """

  
  def query(event, cesql) do
    {:ok, ast} = parse_cesql(cesql)

    case ast do
      {:keyword, _, field} ->
        field = List.to_string(field)
        if field in ~w(specversion source id type data datacontenttype dataschema subject time) do
          field = String.to_existing_atom(field)
          Map.fetch!(event, field)
        else
          Map.get(event.extensions, field)
        end
    end
  end

  defp parse_cesql(str) do
    {:ok, tokens, _} = str |> String.to_charlist() |> :cesql_lexer.string()
    :cesql_parser.parse(tokens)
  end
end
