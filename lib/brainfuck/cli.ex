defmodule Brainfuck.CLI do

	@moduledoc """
	Run a brainfuck program contained in the file passes as parameter.
	If the file does not exist or is not readable, raises an exception
	"""

  def main(args) do
    {_addr, _mem, out} = Brainfuck.run File.read! "#{args}"
    IO.write out
  end
end
