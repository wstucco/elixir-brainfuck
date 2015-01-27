defmodule Brainfuck.Utils do

  # translate an AST back to its brainfuck form
  def to_bf(ast), do: to_bf(ast, <<>>)
  defp to_bf([], source), do: source
  defp to_bf([h | t], source) do
    case h do
      :inc_d        -> to_bf(t, source <> "+")
      :dec_d        -> to_bf(t, source <> "-")
      :inc_p        -> to_bf(t, source <> ">")
      :dec_p        -> to_bf(t, source <> "<")
      :put_c        -> to_bf(t, source <> ".")
      :get_c        -> to_bf(t, source <> ",")
      {:loop, loop} -> to_bf(t, source <>  "[" <> to_bf(loop, <<>>) <> "]")
      _             -> to_bf(t, source)
    end
  end

  # remove comments from brainfuck programs
  def strip(program) when is_binary(program), do: strip(program |> to_char_list, [])
  def strip(program), do: raise "program must be a binary string"

  defp strip([], stack), do: stack |> to_string

  defp strip([h = _ | t], stack) do
    cond do
      [h] |> to_string |> String.contains?(~w( + - < > . , [ ])) ->
        strip(t, stack ++ [h])
      true -> strip(t, stack)
    end
  end

end