defmodule Brainfuck do

	# opcodes
	@op_vinc "+" # increment value at memory address
	@op_vdec "-" # increment value at memory address
	@op_pinc ">" # increment memory address
	@op_pdec "<" # decrement memory address
	@op_putc "." # output byr at memory address
	@op_getc "," # input byte into memory address
	@op_lbeg "[" # loop begin
	@op_lend "]" # loop end

	def run(program), do: run(program |> String.codepoints, program |> String.codepoints, 0, [0], <<>>) 

	# commands
	defp run([@op_vinc | rest], program, addr, mem, output) do 		
		run(rest, program, addr, mem |> inc(addr), output)
	end
	defp run([@op_vdec | rest], program, addr, mem, output) do 		
		run(rest, program, addr,  mem |> dec(addr), output)
	end

	defp run([@op_pinc | rest], program, addr, mem, output) when addr == (mem |> length) - 1 do
		run(rest, program, addr+1, mem ++ [0], output)
	end	
	defp run([@op_pinc | rest], program, addr, mem, output) do 		
		run(rest, program, addr+1, mem, output)
	end

	defp run([@op_pdec | rest], program, addr, mem, output) when addr == 0 do 		
		run(rest, program, 0, [0] ++ mem, output)
	end	
	defp run([@op_pdec | rest], program, addr, mem, output) do 		
		run(rest, program, addr-1, mem, output)
	end

	defp run([@op_lbeg | rest], program, addr, mem, output) do
		cond do
			mem |> is_zero(addr) -> run(rest, program, addr,  mem, output)
			_                    -> run(rest, program, addr,  mem, output)
		end
		
	end
	defp run([@op_lend | rest], program, addr, mem, output) do		
		run(rest, program, addr,  mem, output <> char(mem, addr))
	end

	defp run([@op_putc | rest], program, addr, mem, output) do		
		run(rest, program, addr,  mem, output <> char(mem, addr))
	end

	# drop every other character
	defp run([_ | rest], program, addr, mem, output) do
	 	run(rest, program, addr, mem, output)
	end

	# final condition
	defp run([], _, _, mem, output), do: {output, mem}


	# helpers
	defp inc(list, addr), do: List.update_at(list, addr, &(&1+1 |> rem 255))
	defp dec(list, addr), do: List.update_at(list, addr, &(&1-1 |> rem 255))

	defp char(list, addr), do: [list |> Enum.at addr] |> to_string

	defp is_zero(list, addr), do: list |> Enum.at addr == 0

end