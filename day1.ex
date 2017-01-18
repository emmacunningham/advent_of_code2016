defmodule Advent.Day1 do
  @input "day1.txt"

  def get_directions() do
    %{
      north: %{
        L: &(%{x: &1.x - &2, y: &1.y, direction: :west}),
        R: &(%{x: &1.x + &2, y: &1.y, direction: :east}),
      },
      south: %{
        L: &(%{x: &1.x + &2, y: &1.y, direction: :east}),
        R: &(%{x: &1.x - &2, y: &1.y, direction: :west}),
      },
      east: %{
        L: &(%{x: &1.x, y: &1.y + &2, direction: :north}),
        R: &(%{x: &1.x, y: &1.y - &2, direction: :south}),
      },
      west: %{
        L: &(%{x: &1.x, y: &1.y - &2, direction: :south}),
        R: &(%{x: &1.x, y: &1.y + &2, direction: :north}),
      },
    }
  end

  def find_end(origin, []), do: origin
  def find_end(origin, instructions) do
    cur_dir =
      get_directions()
      |> Map.get(origin.direction)

    parsed_instruction =
      hd(instructions)
      |> String.split_at(1)

    dir = elem(parsed_instruction, 0) |> String.to_existing_atom()
    distance = elem(parsed_instruction, 1) |> String.to_integer()

    new_origin = cur_dir[dir].(origin, distance)
    new_instructions = tl(instructions)

    find_end(new_origin, new_instructions)
  end

  def find_first_repeated(_, [], _), do: nil
  def find_first_repeated(origin, instructions, visited) do
    cur_dir =
      get_directions()
      |> Map.get(origin.direction)

    parsed_instruction =
      hd(instructions)
      |> String.split_at(1)

    dir = elem(parsed_instruction, 0) |> String.to_existing_atom()
    distance = elem(parsed_instruction, 1) |> String.to_integer()

    visited_path =
      Range.new(1, distance)
      |> Enum.map(fn(d) -> cur_dir[dir].(origin, d) end)

    prev_visited =
      visited_path
      |> Enum.find(fn(n_coord) ->
          found = Enum.find(visited, fn(v_coord) ->
            n_coord.x == v_coord.x and n_coord.y == v_coord.y
          end)

          not is_nil(found)
         end)

    if is_nil(prev_visited) do
      new_visited = visited ++ visited_path

      new_origin = cur_dir[dir].(origin, distance)
      new_instructions = tl(instructions)

      find_first_repeated(new_origin, new_instructions, new_visited)
    else
      prev_visited
    end
  end

  def get_location(coord) do
    Kernel.abs(coord.x) + Kernel.abs(coord.y)
  end

  def get_end_location(origin, instructions) do
    origin
    |> find_end(instructions)
    |> get_location()
  end

  def get_first_repeated_location(origin, instructions) do
    origin
    |> find_first_repeated(instructions, [])
    |> get_location()
  end

  def get_instructions() do
    File.read!(@input)
    |> String.split(", ")
  end

end

origin = %{
  x: 0,
  y: 0,
  direction: :north,
}

formatted_instructions = Advent.Day1.get_instructions()

Advent.Day1.get_end_location(origin, formatted_instructions)
  |> Integer.to_string()
  |> (fn(answer) -> "End location is: #{answer} units away" end).()
  |> IO.inspect()

Advent.Day1.get_first_repeated_location(origin, formatted_instructions)
  |> Integer.to_string()
  |> (fn(answer) -> "First repeated location is: #{answer} units away" end).()
  |> IO.inspect()

