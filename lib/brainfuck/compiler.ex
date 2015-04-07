defmodule Brainfuck.Compiler do

  def compile(program) when is_binary(program) do
    compile(program |> to_char_list)
  end

  def compile(program), do: compile(program, [], [])

  defp compile([], _, stack) when length(stack) > 0, do: raise "unmatched '['"
  defp compile([], ast, stack) when length(stack) == 0, do: ast

  defp compile([ic | tail], ast, stack) do
    case {[ic], stack} do
      { '+', _ } -> compile tail, ast ++ [add: 1], stack
      { '-', _ } -> compile tail, ast ++ [sub: 1], stack
      { '>', _ } -> compile tail, ast ++ [mvr: 1], stack
      { '<', _ } -> compile tail, ast ++ [mvl: 1], stack
      { '.', _ } -> compile tail, ast ++ [:put], stack
      { ',', _ } -> compile tail, ast ++ [:get], stack
      { '[', _ } -> compile tail, [], [ast] ++ stack
      { ']', [] } -> raise "unmatched ']'"
      { ']', [h | t] } -> compile tail, h ++ [loop: ast], t
      _ -> compile tail, ast, stack
    end
  end

end