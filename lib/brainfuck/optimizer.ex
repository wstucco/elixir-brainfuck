defmodule Brainfuck.Optimizer do

  # optimizing compiler

  def optimize(ast) do
    ast |>
    rle([])
  end

  defp rle([], ast), do: ast
  defp rle(p = [ic | tail], ast) do
    case ic do
      :put          -> rle tail, ast ++ [:put]
      :get          -> rle tail, ast ++ [:get]
      {:loop, loop} -> rle tail, ast ++ [loop: rle(loop, [])]
      {op, _}       -> rle tail |> drop(op), ast ++ [{op, (p |> take(op) |> count)}]
    end
  end

  defp drop(ast, op), do: ast |> Enum.drop_while fn(x) -> is_tuple(x) && x |> elem(0) == op end
  defp take(ast, op), do: ast |> Enum.take_while fn(x) -> is_tuple(x) && x |> elem(0) == op end
  defp count(ast), do: ast |> Enum.reduce 0, fn({_, v}, acc) -> v + acc end

end