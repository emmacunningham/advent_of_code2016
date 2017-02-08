defmodule Advent.Day3 do
  @input "day3.txt"

  def get_instructions(:row) do
    File.read!(@input)
    |> String.split("\n")
    |> Enum.map(fn(row) ->
         String.trim(row)
         |> String.split()
         |> Enum.reduce({}, fn(cell, acc) ->
              Tuple.append(acc, String.to_integer(cell))
            end)
       end)
  end
  def get_instructions(:col) do
    File.read!(@input)
    |> String.split(~r{\s})
    |> Enum.reduce(%{idx: 0, rows: %{0 => {}, 1 => {}, 2 => {}}, num_triangles: 0}, fn(cell, acc) ->
         if cell == "" do
           acc
         else
          idx = rem(acc.idx, 3)
          cur_row = acc.rows[idx]
          new_cur_row = Tuple.append(cur_row, String.to_integer(cell))
          if tuple_size(new_cur_row) == 3 do
            if is_triangle?(new_cur_row) do
             %{idx: acc.idx + 1, rows: Map.put(acc.rows, idx, {}), num_triangles: acc.num_triangles + 1}
            else
             %{idx: acc.idx + 1, rows: Map.put(acc.rows, idx, {}), num_triangles: acc.num_triangles}
            end
          else
             %{idx: acc.idx + 1, rows: Map.put(acc.rows, idx, new_cur_row), num_triangles: acc.num_triangles}
          end
         end
       end)
  end

  def is_triangle?({a, b, c}), do: a + b > c && a + c > b && b + c > a
  def is_triangle?(_), do: false

  def count_valid_triangles(%{:num_triangles => num_triangles}), do: num_triangles
  def count_valid_triangles(input) do
    Enum.reduce(input, 0, fn(row, acc) ->
      case is_triangle?(row) do
        true ->
          acc + 1
        false ->
          acc
      end
    end)
  end
end

Advent.Day3.get_instructions(:col)
|> Advent.Day3.count_valid_triangles()
|> IO.inspect()

