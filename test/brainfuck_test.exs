Code.require_file "test_helper.exs", __DIR__

defmodule BrainfuckTest do
  use ExUnit.Case

  test "memory pointer increment" do
  	{output, mem} = Brainfuck.run(">>>")
    assert mem == [0, 0, 0, 0]
    assert mem |> length == 4
    assert output == <<>>
  end

  test "memory pointer decrement" do
  	{output, mem} = Brainfuck.run("<<<")
    assert mem == [0, 0, 0, 0]
    assert mem |> length == 4
    assert output == <<>>
  end

  test "memory value increment" do
  	{output, mem} = Brainfuck.run("+++")
    assert mem == [3]
    assert mem |> length == 1
    assert output == <<>>
  end

  test "memory value decrement" do
  	{output, mem} = Brainfuck.run("---")
    assert mem == [-3]
    assert mem |> length == 1
    assert output == <<>>
  end

  test "BF example 1: output A" do
    {output, mem} = Brainfuck.run("++++++ [ > ++++++++++ < - ] > +++++ .")
    assert mem == [5, 15]
    assert mem |> length == 2
    assert output == <<65>>
  end

  # 65 == A
  # ++++++ [ > ++++++++++ < - ] > +++++ .

  # hello world
  # >+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.>>>
	# ++++++++[<++++>-]<.>>>++++++++++[<+++++++++>-]<---.<<<<.+++.------.--------.>>+.
end
