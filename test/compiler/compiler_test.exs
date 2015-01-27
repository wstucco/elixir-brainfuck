defmodule BrainfuckTest.CompilerTest do
  use ExUnit.Case

  test "compile a program to its AST representation" do
    ast = Brainfuck.Compiler.compile("+-><[.,]")
    assert ast == [:inc_d, :dec_d, :inc_p, :dec_p, loop: [:put_c, :get_c]]

    ast = Brainfuck.Compiler.compile("[+][-][+[-]]")
    assert ast == [loop: [:inc_d], loop: [:dec_d], loop: [:inc_d, loop: [:dec_d]]]
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

  test "fail to compile a program because loop are unbalanced" do
    assert_raise RuntimeError, "unmatched ']'", fn ->
      Brainfuck.Compiler.compile("+[-]]")
    end
    assert_raise RuntimeError, "unmatched '['", fn ->
      Brainfuck.Compiler.compile("+[[[[[-]]")
    end
  end

  # @tag timeout: 1000000
  # test "execute a simple benchmark, should return OK." do
  #   {_, _, _, o} = Brainfuck.VM.run Brainfuck.Compiler.compile BrainfuckTest.load_fixture("bench_ok.bf")
  #   assert o |> to_string == "OK"
  # end


end
