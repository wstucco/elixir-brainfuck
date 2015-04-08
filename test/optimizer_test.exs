defmodule BrainfuckTest.OptimizerTest do
  use ExUnit.Case

  test "rle simple compiled program" do
    ast = Brainfuck.Compiler.compile "+++--[--[<<]],."
    optimized = Brainfuck.Optimizer.optimize(ast)
    assert optimized == [{:add, 3}, {:sub, 2}, {:loop, [sub: 2, loop: [mvl: 2]]}, :get, :put]
  end

  test "run optimzed hello world" do
    source = BrainfuckTest.load_fixture "hello_world.bf"
    ast    = Brainfuck.Compiler.compile source
    # IO.inspect ast
    optimized = Brainfuck.Optimizer.optimize ast
    {_, _, _, o} = Brainfuck.VM.run optimized
    assert o |> to_string == "Hello World!\n"
  end

  # test "macro" do
  #   require Brainfuck.Optimizer
  #   IO.puts Brainfuck.Optimizer.add(1, 2)
  # end

  # test "cancel out adjacent opposite opcodes" do
  #   ast = [:inc_d, :inc_d, :inc_d, :inc_d, :dec_d, :dec_d, :inc_p, :inc_p, :inc_d, :dec_d, :dec_p, :dec_p, :dec_p]
  #   optimized = Brainfuck.Optimizer.optimize(ast)
  #   assert optimized == [:inc_d, :dec_p]
  # end

end
