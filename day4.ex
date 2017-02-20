defmodule Advent.Day4 do
  @input "day4.txt"
  @alphabet "abcdefghijklmnopqrstuvwxyz"

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

  def get_row_value(row) do
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
         acc + get_row_value(row)
       end)
  end

  def find_letter_idx(letter) do
    String.graphemes(@alphabet)
    |> Enum.with_index()
    |> Enum.find(fn({k, _}) ->
      k == letter
    end)
    |> elem(1)
  end

  def shift_letter(letter, shift_num) do
    num_alpha = String.length(@alphabet)

    start_idx = find_letter_idx(letter)
    end_idx =
      rem(shift_num + start_idx, num_alpha)

    String.at(@alphabet, end_idx)
  end

  def decrypt_string(segment, shift_num) do
    segment
    |> String.graphemes()
    |> Enum.map(fn(letter) -> shift_letter(letter, shift_num) end)
    |> Enum.join()
  end

  def decrypt_id(row) do
    split_row =
      row
      |> String.split("[")

    room_parts =
      split_row
      |> List.delete_at(length(split_row) - 1)
      |> List.first()
      |> String.split("-")

    sector_id =
      room_parts
      |> List.last()
      |> String.to_integer()

    encrypted_name =
      room_parts
      |> List.delete_at(length(room_parts) - 1)
      |> Enum.map(fn(segment) -> decrypt_string(segment, sector_id) end)
      |> Enum.join(" ")

    %{name: encrypted_name, id: sector_id}
  end

  def decrypt_ids(rows) do
    rows
    |> Enum.map(&decrypt_id/1)
  end

  def find_north_pole(rooms) do
    Enum.find(rooms, fn(room) ->
      String.contains?(room.name, "north")
    end)
  end
end

Advent.Day4.get_instructions()
|> Advent.Day4.decrypt_ids()
|> Advent.Day4.find_north_pole()
|> IO.inspect()

