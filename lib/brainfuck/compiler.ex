defmodule Brainfuck.Compiler do

  def compile(program) when is_binary(program) do
    compile(program |> to_char_list)
  end

  def compile(program), do: compile(program, [], [])

  defp compile([], _, stack) when length(stack) > 0, do: raise "unmatched '['"
  defp compile([], ast, stack) when length(stack) == 0, do: ast

  defp compile([ic | tail], ast, stack) do
    case {[ic] |> to_string, stack} do
      { "+", _ } -> compile tail, ast ++ [:inc_data], stack
      { "-", _ } -> compile tail, ast ++ [:dec_data], stack
      { ">", _ } -> compile tail, ast ++ [:inc_ptr], stack
      { "<", _ } -> compile tail, ast ++ [:dec_ptr], stack
      { ".", _ } -> compile tail, ast ++ [:put_char], stack
      { ",", _ } -> compile tail, ast ++ [:get_char], stack
      { "[", _ } -> compile tail, [], [ast] ++ stack
      { "]", [] } -> raise "unmatched ']'"
      { "]", [h | t] } -> compile tail, h ++ [loop: ast], t
      _ -> compile tail, ast, stack
    end
  end

end
