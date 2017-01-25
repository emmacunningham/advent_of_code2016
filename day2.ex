defmodule Advent.Day2 do
  @input "day2.txt"

  # Keypad
  # 1 2 3
  # 4 5 6
  # 7 8 9

  def move("U", cur_loc) when cur_loc < 4, do: cur_loc
  def move("U", cur_loc), do: cur_loc - 3

  def move("D", cur_loc) when cur_loc > 6, do: cur_loc
  def move("D", cur_loc), do: cur_loc + 3

  def move("L", cur_loc) when rem(cur_loc, 3) == 1, do: cur_loc
  def move("L", cur_loc), do: cur_loc - 1

  def move("R", cur_loc) when rem(cur_loc, 3) == 0, do: cur_loc
  def move("R", cur_loc), do: cur_loc + 1

  def get_code(lines, loc) do
    lines
      |> Enum.reduce([], fn(line, acc) ->
        start = List.last(acc) || loc

        code =
          line
            |> String.graphemes()
            |> Enum.reduce(start, fn(letter, acc) ->
                 move(letter, acc)
               end)

        acc ++ [code]

      end)
      |> Enum.join()
  end

  def get_instructions() do
    File.read!(@input)
    |> String.split("\n")
  end

end

origin = 5

Advent.Day2.get_instructions()
|> Advent.Day2.get_code(origin)
|> IO.inspect()

