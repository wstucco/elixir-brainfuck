defmodule Brainfuck.CLI do

	@moduledoc """
	Run a brainfuck program contained in the file passes as parameter.
	If the file does not exist or is not readable, raises an exception
	"""

  def main(args) do
    args |> parse_args
  end

  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean, interpreter: :boolean],
                                      aliases: [h: :help, i: :interpreter])

    case options do
      { [ help: true], _, _ }                    -> IO.puts "help"
      { [ interpreter: true], [file, input], _ } -> process :interpreter, file, input
      { [ interpreter: true], [file], _ }        -> process :interpreter, file, []
      { [ ], [file], _ }                         -> process :compiler, file, []
      { [ ], [file, input], _ }                  -> process :compiler, file, input
      _                                          -> IO.puts "else help"
    end
  end

  def process(:compiler, file, input) do
    ast = Brainfuck.Compiler.compile(File.read!(file))
    {_, _, _, o} = Brainfuck.VM.run ast, input
    IO.puts o |> to_string
  end

  def process(:interpreter, file, input) do
    program = File.read!(file)
    {_, _, _, o} = Brainfuck.run program, input
    IO.puts o |> to_string
  end

  # def main(args) do
  #   # {_addr, _mem, _in, out} = Brainfuck.run File.read! "#{args}"
  #   {_addr, _mem, _in, out} = Brainfuck.VM.run Brainfuck.Compiler.compile File.read! "#{args}"
  #   IO.write out
  # end
end
