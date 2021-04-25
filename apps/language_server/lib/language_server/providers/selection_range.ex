defmodule ElixirLS.LanguageServer.Providers.SelectionRange do
  @moduledoc """
  A textDocument/SelectionRange provider implementation.

  ## Background

  See specification here:

  https://microsoft.github.io/language-server-protocol/specification#textDocument_selectionRange

  ## Methodology

  """

  # @type positions :: [position.t()]

  # @type position :: %{
  #         required(:line) => non_neg_integer(),
  #         required(:character) => non_neg_integer()
  #       }

  @doc """
  Provides folding ranges for a source file

  ## Example

      iex> alias ElixirLS.LanguageServer.Providers.FoldingRange
      iex> text = \"""
      ...> defmodule A do    # 0
      ...>   def hello() do  # 1
      ...>     :world        # 2
      ...>   end             # 3
      ...> end               # 4
      ...> \"""
      iex> FoldingRange.provide(%{text: text})
      {:ok, [
        %{startLine: 0, endLine: 3, kind?: :region},
        %{startLine: 1, endLine: 2, kind?: :region}
      ]}

  """
  # @spec provide(text: String.t(), positions: List.t()) :: {:ok, [t()]} | {:error, String.t()}
  def provide(text, positions) do
    # IO.inspect(text, label: "got text")
    IO.inspect(positions, label: "got positions")

    line = List.first(positions) |> Map.get("line")
    character = List.first(positions) |> Map.get("character")

    new_range = [
      %{
        range: %{
          start: %{line: line, character: character - 1},
          end: %{line: line, character: character + 1}
        },
        parent: %{
          range: %{
            start: %{line: line, character: character - 2},
            end: %{line: line, character: character + 2}
          },
          parent: %{
            range: %{
              start: %{line: line, character: character - 3},
              end: %{line: line, character: character + 3}
            },
            parent: %{
              range: %{
                start: %{line: line, character: character - 4},
                end: %{line: line, character: character + 4}
              }
            }
          }
        }
      }
    ]

    {:ok, new_range}
  end

  def provide(not_a_source_file) do
    {:error, "Expected a source file, found: #{inspect(not_a_source_file)}"}
  end
end
