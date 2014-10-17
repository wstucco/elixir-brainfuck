defmodule Brainfuck do

	# opcodes
	@op_vinc "+" # increment value at memory address
	@op_vdec "-" # decrement value at memory address
	@op_pinc ">" # increment memory address
	@op_pdec "<" # decrement memory address
	@op_putc "." # output byte at memory address
	@op_getc "," # input byte into memory address
	@op_lbeg "[" # loop begin
	@op_lend "]" # loop end

	@empty ""

	def run(program), do: run(program, 0, [0], @empty)

	# final condition
	defp run(@empty, addr, mem, output), do: {addr, mem, output}

	# commands
	defp run(@op_vinc <> rest, addr, mem, output) do
		run(rest, addr, mem |> inc_at(addr), output)
	end
	defp run(@op_vdec <> rest, addr, mem, output) do
		run(rest, addr,  mem |> dec_at(addr), output)
	end

	defp run(@op_pinc <> rest, addr, mem, output) when addr + 1 == mem |> length do
		run(rest, addr+1, mem ++ [0], output)
	end
	defp run(@op_pinc <> rest, addr, mem, output) do
		run(rest, addr+1, mem, output)
	end

	defp run(@op_pdec <> rest, addr, mem, output) when addr == 0 do
		run(rest, 0, [0] ++ mem, output)
	end
	defp run(@op_pdec <> rest, addr, mem, output) do
		run(rest, addr-1, mem, output)
	end

	defp run(@op_lbeg <> rest, addr, mem, output) do
		case mem |> byte_at addr do
			0 ->
				run(rest |> jump_to_lend, addr,  mem, output)
			_ ->
				{a, m, o} = run(rest |> loop_body, addr,  mem, output)
				run(@op_lbeg <> rest, a, m, o)
		end
	end

	defp run(@op_putc <> rest, addr, mem, output) do
		run(rest, addr, mem, output <> (mem |> char_at addr))
	end
	defp run(@op_getc <> rest, addr, mem, output) do
		val = case IO.getn("Input\n", 1) do
			:eof -> 0
			c    -> c
		end
		run(rest, addr, mem |> put_at(addr, val), output)
	end


	# drop every other character
	defp run(<<_>> <> rest, addr, mem, output), do: run(rest, addr, mem, output)


	# helpers
	defp inc_at(list, addr), do: List.update_at(list, addr, &(&1+1 |> rem 255))
	defp dec_at(list, addr), do: List.update_at(list, addr, &(&1-1 |> rem 255))
	defp put_at(list, addr, val), do: List.replace_at(list, addr, val)

	defp byte_at(list, addr), do: list |> Enum.at addr
	defp char_at(list, addr), do: [list |> byte_at addr] |> to_string

	defp match_lend(source), do: match_lend(source, 1, 0)
	defp match_lend(_, 0, acc), do: acc
	defp match_lend(@empty, _, _), do: raise "unbalanced loop"
	defp match_lend(@op_lbeg <> rest, depth, acc), do: match_lend(rest, depth+1, acc+1)
	defp match_lend(@op_lend <> rest, depth, acc), do: match_lend(rest, depth-1, acc+1)
	defp match_lend(<<_>> <> rest, depth, acc), do: match_lend(rest, depth, acc+1)

	defp jump_to_lend(source), do: source |> String.slice (source |> match_lend)..-1
	defp loop_body(source), do: source |> String.slice 0..(source |> match_lend)-1

end
