defmodule BrainfuckTest.CompilerTest do
  use ExUnit.Case

  test "compile a program to its AST representation" do
    ast = Brainfuck.Compiler.compile("+-><[.,]")
    assert ast == [:inc_data, :dec_data, :inc_ptr, :dec_ptr, loop: [:put_char, :get_char]]

    ast = Brainfuck.Compiler.compile("[+][-][+[-]]")
    assert ast == [loop: [:inc_data], loop: [:dec_data], loop: [:inc_data, loop: [:dec_data]]]
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
