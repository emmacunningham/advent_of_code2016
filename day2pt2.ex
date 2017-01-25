# TODO: consider how we might generalize this for all keypad inputs
# We could use the whitespaces to determine key layout
# and possibly generate the moves based on the number of whitespaces between keys?

defmodule Advent.Day2 do
  @input "day2.txt"
  @keypad_input "day2keypad.txt"
  @keypad File.read!(@keypad_input)
    |> String.graphemes()
    |> Enum.filter(fn(grapheme) -> String.match?(grapheme, ~r/[A-D1-9]/) end)
  @keypad_tuple List.to_tuple(@keypad)

  # Keypad
  #     1
  #   2 3 4
  # 5 6 7 8 9
  #   A B C
  #     D

  # Keypad indices
  #     0
  #   1 2 3
  # 4 5 6 7 8
  #   9 10 11
  #     12

  def get_key_index(loc) do
    keypad_list = @keypad
    Enum.find_index(keypad_list, fn(n) -> n == loc end)
  end

  def move("U", cur_loc_idx) when cur_loc_idx in [0, 1, 3, 4, 8], do: cur_loc_idx
  def move("U", cur_loc_idx) when cur_loc_idx in [2, 12], do: cur_loc_idx - 2
  def move("U", cur_loc_idx), do: cur_loc_idx - 4

  def move("D", cur_loc_idx) when cur_loc_idx in [4, 8, 9, 11, 12], do: cur_loc_idx
  def move("D", cur_loc_idx) when cur_loc_idx in [0, 10], do: cur_loc_idx + 2
  def move("D", cur_loc_idx), do: cur_loc_idx + 4

  def move("L", cur_loc_idx) when cur_loc_idx in [0, 1, 4, 9, 12], do: cur_loc_idx
  def move("L", cur_loc_idx), do: cur_loc_idx - 1

  def move("R", cur_loc_idx) when cur_loc_idx in [0, 3, 8, 11, 12], do: cur_loc_idx
  def move("R", cur_loc_idx), do: cur_loc_idx + 1

  def get_code(lines, loc) do
    lines
      |> Enum.reduce([], fn(line, acc) ->
        start_index = List.last(acc) || get_key_index(loc)

        code_index =
          line
            |> String.graphemes()
            |> Enum.reduce(start_index, fn(letter, acc) ->
                 move(letter, acc)
               end)

        acc ++ [code_index]

      end)
      |> Enum.map(fn(idx) -> elem(@keypad_tuple, idx) end)
      |> Enum.join()
  end

  def get_instructions() do
    File.read!(@input)
    |> String.split("\n")
  end

end

origin = "5"

Advent.Day2.get_instructions()
|> Advent.Day2.get_code(origin)
|> IO.inspect()

