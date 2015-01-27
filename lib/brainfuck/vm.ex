defmodule Brainfuck.VM do
  def run(program, input \\ :stdio)
  def run(program, input) when is_binary(input), do: run(program, 0, [0], input |> to_char_list, [])
  def run(program, input) when not is_list(input), do: run(program, 0, [0], [input], [])
  def run(program, input), do: run(program, 0, [0], input, [])

  # final condition
  defp run([], addr, mem, input, output), do: {addr, mem, input, output}

  # commands
  defp run([:inc_d | tail], addr, mem, input, output) do
    run(tail, addr, mem |> inc_at(addr), input, output)
  end
  defp run([:dec_d | tail], addr, mem, input, output) do
    run(tail, addr,  mem |> dec_at(addr), input, output)
  end

  defp run([:inc_p | tail], addr, mem, input, output) when addr + 1 == mem |> length do
    run(tail, addr+1, mem ++ [0], input, output)
  end
  defp run([:inc_p | tail], addr, mem, input, output) do
    run(tail, addr+1, mem, input, output)
  end

  defp run([:dec_p | tail], addr, mem, input, output) when addr <= 0 do
    run(tail, 0, [0] ++ mem, input, output)
  end
  defp run([:dec_p | tail], addr, mem, input, output) do
    run(tail, addr-1, mem, input, output)
  end

  defp run([:put_c | tail], addr, mem, input, output) do
    run(tail, addr, mem, input, output ++ [mem |> byte_at addr])
  end
  # when input is a list and is empty, treat it like :eof and insert 0
  defp run([:get_c | tail], addr, mem, [], output) do
    run(tail, addr, mem |> put_at(addr, 0), [], output)
  end
  # when input is list, extract the first element as new memeory value
  defp run([:get_c | tail], addr, mem, [h | t], output) do
    run(tail, addr, mem |> put_at(addr, h), t, output)
  end
  # when input is stdio, read a char from it
  defp run([:get_c | tail], addr, mem, input, output) when input == :stdio do
    val = case IO.getn("Input\n", 1) do
      :eof -> 0
      c   -> c |> to_char_list |> Enum.at 0 # convert char to byte
    end
    run(tail, addr, mem |> put_at(addr, val), input, output)
  end

  defp run(program = [{:loop, loop} | tail], addr, mem, input, output) do
    case mem |> byte_at addr do
      0 ->
        run(tail, addr, mem, input, output)
      _ ->
        {a, m, i, o} = run(loop, addr, mem, input, output)
        run(program, a, m, i, o)
    end
  end

  # reject invalid op codes
  defp run([op_code | _], addr, mem, input, output), do: raise ~s(invalid op_code #{op_code})

  # helpers
  defp inc_at(list, addr), do: List.update_at(list, addr, &(&1+1 |> rem 255))
  defp dec_at(list, addr), do: List.update_at(list, addr, &(&1-1 |> rem 255))
  defp put_at(list, addr, val), do: List.replace_at(list, addr, val)

  defp byte_at(list, addr), do: list |> Enum.at addr
end