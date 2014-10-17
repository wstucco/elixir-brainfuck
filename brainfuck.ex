#!/usr/bin/env elixir

defmodule BrainfuckCli do
  def run(argv) do
    {_addr, _mem, out} = Brainfuck.run File.read! "#{argv}"
    IO.write out
  end
end


BrainfuckCli.run System.argv
