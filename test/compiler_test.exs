defmodule BrainfuckTest.CompilerTest do
  use ExUnit.Case

  test "compile a program to its AST representation" do
    ast = Brainfuck.Compiler.compile("+-><[.,]")
    assert ast == [{:add, 1}, {:sub, 1}, {:mvr, 1}, {:mvl, 1}, loop: [:put, :get]]

    ast = Brainfuck.Compiler.compile("[+][-][+[-]]")
    assert ast == [loop: [{:add, 1}], loop: [{:sub, 1}], loop: [{:add, 1}, loop: [{:sub, 1}]]]
  end

  test "compile to ast and back to brainfuck." do
    source = BrainfuckTest.load_fixture "primes.bf"
    ast = Brainfuck.Compiler.compile source
    assert source |> Brainfuck.Utils.strip == Brainfuck.Utils.to_bf(ast)
  end

  test "create a quine of itself" do
    source = BrainfuckTest.load_fixture "dquine.bf"
    {_, _, _, o} = Brainfuck.VM.run Brainfuck.Compiler.compile source
    assert o |> to_string == source |> Brainfuck.Utils.strip
  end

  test "hello world" do
    source = BrainfuckTest.load_fixture "hello_world.bf"
    {_, _, _, o} = Brainfuck.VM.run Brainfuck.Compiler.compile source
    assert o |> to_string == "Hello World!\n"
  end

  test "reverse a string" do
    {_, _, _, o} = Brainfuck.VM.run Brainfuck.Compiler.compile(">,[>,]<[.<]"), "abcde"
    assert o |> to_string == "edcba"
  end

  test "fail to compile a program because loop are unbalanced" do
    assert_raise RuntimeError, "unmatched ']'", fn ->
      Brainfuck.Compiler.compile("+[-]]")
    end
    assert_raise RuntimeError, "unmatched '['", fn ->
      Brainfuck.Compiler.compile("+[[[[[-]]")
    end
  end

end
