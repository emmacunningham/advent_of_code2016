defmodule Advent.Day4 do
  @input "day4.txt"

  def get_instructions() do
    File.read!(@input)
    |> String.split("\n")
  end

  def num_occurences(item, list) do
    Enum.reduce(list, 0, fn(letter, acc) ->
      case letter == item do
        true ->
          acc + 1
        false ->
          acc
      end
    end)
  end

  def is_valid?(letters, checksum) do
    top_letters =
      letters
      |> Enum.uniq()
      |> Enum.sort(fn(a, b) ->
          case num_occurences(a, letters) == num_occurences(b, letters) do
            true ->
              a < b
            _ ->
              num_occurences(a, letters) > num_occurences(b, letters)
          end
         end)
      |> Enum.slice(0, 5)
      |> Enum.join()

    top_letters == checksum
  end

  def row_value(row) do
    split_row = String.split(row, "-")
    row_elements =
      split_row
      |> List.last()
      |> String.split("[")

    checksum =
      row_elements
      |> List.last()
      |> String.replace("]", "")

    letters =
      split_row
      |> List.delete_at(length(split_row) - 1)
      |> Enum.join()
      |> String.graphemes()

    case is_valid?(letters, checksum) do
      true ->
        row_elements
        |> List.first()
        |> String.to_integer()

      false ->
        0
    end
  end

  def sum_valid_ids(rows) do
    rows
    |> Enum.reduce(0, fn(row, acc) ->
         acc + row_value(row)
       end)
  end
end

Advent.Day4.get_instructions()
|> Advent.Day4.sum_valid_ids()
|> IO.inspect()

