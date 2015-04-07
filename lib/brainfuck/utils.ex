defmodule Brainfuck.Utils do

  # translate an AST back to its brainfuck form
  def to_bf(ast), do: to_bf(ast, <<>>)
  defp to_bf([], source), do: source
  defp to_bf([h | t], source) do
    case h do
      {:add, n}     -> to_bf(t, source <> String.duplicate("+", n))
      {:sub, n}     -> to_bf(t, source <> String.duplicate("-", n))
      {:mvr, n}     -> to_bf(t, source <> String.duplicate(">", n))
      {:mvl, n}     -> to_bf(t, source <> String.duplicate("<", n))
      :put          -> to_bf(t, source <> ".")
      :get          -> to_bf(t, source <> ",")
      {:loop, loop} -> to_bf(t, source <>  "[" <> to_bf(loop, <<>>) <> "]")
      _             -> to_bf(t, source)
    end
  end

  # translate an AST to its C equivalent
  def to_c(ast) do
    """
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    // initialize the tape with 30,000 zeroes
    unsigned char mem[30000] = {0};

    // set the pointer to point at the left-most cell of the tape
    unsigned char p = 0;
    void main() {
    """
    <>
    to_c(ast, <<>>)
    <>
    "}"
  end

  defp to_c([], source), do: source
  defp to_c([h | t], source) do
    case h do
      {:add, n}     -> to_c(t, source <> "mem[p]+=#{n}; // +\n")
      {:sub, n}     -> to_c(t, source <> "mem[p]-=#{n}; // -\n")
      {:mvr, n}     -> to_c(t, source <> "p+=#{n}; // >\n")
      {:mvl, n}     -> to_c(t, source <> "p-=#{n}; // <\n")
      :put_c        -> to_c(t, source <> "putchar(mem[p]); // .\n")
      :get_c        -> to_c(t, source <> "mem[p] = getchar(); // ,\n")
      {:loop, loop} -> to_c(t, source <>  "while(mem[p]) {  // [\n" <> to_c(loop, <<>>) <> "}  // ] \n")
      _             -> to_c(t, source)
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