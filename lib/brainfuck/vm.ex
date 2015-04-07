defmodule Brainfuck.VM do
  def run(program, input \\ :stdio)
  def run(program, input) when is_binary(input), do: run(program, 0, [0], input |> to_char_list, [])
  def run(program, input), do: run(program, 0, [0], input, [])

  # final condition
  defp run([], addr, mem, input, output), do: {addr, mem, input, output}

  # commands
  defp run([{:add, n} | tail], addr, mem, input, output) do
    run(tail, addr, mem |> add_at(addr, n), input, output)
  end
  defp run([{:sub, n} | tail], addr, mem, input, output) do
    run(tail, addr,  mem |> sub_at(addr, n), input, output)
  end

  defp run([{:mvr, n} | tail], addr, mem, input, output) when addr + n >= length(mem) do
    run(tail, addr+n, mem |> expand_right(n), input, output)
  end
  defp run([{:mvr, n} | tail], addr, mem, input, output) do
    run(tail, addr+n, mem, input, output)
  end

  defp run([{:mvl, n} | tail], addr, mem, input, output) when addr - n  < 0 do
    run(tail, addr-n, mem |> expand_left(n), input, output)
  end
  defp run([{:mvl, n} | tail], addr, mem, input, output) do
    run(tail, addr-n, mem, input, output)
  end

  defp run([:put| tail], addr, mem, input, output) do
    run(tail, addr, mem, input, output ++ [mem |> byte_at addr])
  end
  # when input is stdio, read a char from it
  defp run([:get | tail], addr, mem, input, output) when input == :stdio do
    val = case IO.getn("Input\n", 1) do
      :eof -> 0
      c   -> c |> to_char_list |> Enum.at 0 # convert char to byte
    end
    run(tail, addr, mem |> put_at(addr, val), input, output)
  end
  # when input is a list and is empty, treat it like :eof and insert 0
  defp run([:get | tail], addr, mem, [], output) do
    run(tail, addr, mem |> put_at(addr, 0), [], output)
  end
  # when input is list, extract the first element as new memeory value
  defp run([:get | tail], addr, mem, [h | t], output) do
    run(tail, addr, mem |> put_at(addr, h), t, output)
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
  defp run([op_code | _], _, _, _, _), do: raise ~s(invalid op_code #{op_code})

  # helpers
  defp add_at(list, addr, n), do: List.update_at(list, addr, &(&1+n |> rem 255))
  defp sub_at(list, addr, n), do: List.update_at(list, addr, &(&1-n |> rem 255))
  defp put_at(list, addr, val), do: List.replace_at(list, addr, val)
  defp expand_right(mem, n), do: mem ++ Enum.take(Stream.cycle([0]), n)
  defp expand_left(mem, n), do: Enum.take(Stream.cycle([0]), n) ++ mem

  defp byte_at(list, addr), do: list |> Enum.at addr
end