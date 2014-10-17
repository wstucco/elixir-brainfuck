#!/usr/bin/env elixir

defmodule BrainfuckCli do
	# import Brainfuck

  def run(args) do
    {_addr, _mem, out} = Brainfuck.run args |> parse_args
    IO.write out
  end

  defp parse_args([]), do: raise "missing file parameter"
  defp parse_args([file | _]), do: parse_args file

  defp parse_args(file) do
    case File.read "#{file}" do
      {:ok, body}   -> body
      {:error, err} -> raise "error loading file #{file}: #{err}"
    end
  end

end


BrainfuckCli.run System.argv
