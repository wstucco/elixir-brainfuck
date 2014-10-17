defmodule BrainfuckTest do
  use ExUnit.Case

  test "memory pointer increment (autogrow right)" do
  	{_addr, mem, output} = Brainfuck.run(">>>")
    assert mem == [0, 0, 0, 0]
    assert mem |> length == 4
    assert output == <<>>
  end

  test "memory pointer decrement (autogrow left)" do
  	{_addr, mem, output} = Brainfuck.run("<<<")
    assert mem == [0, 0, 0, 0]
    assert mem |> length == 4
    assert output == <<>>
  end

  test "memory value increment" do
  	{_addr, mem, output} = Brainfuck.run("+++")
    assert mem == [3]
    assert mem |> length == 1
    assert output == <<>>
  end

  test "memory value decrement" do
  	{_addr, mem, output} = Brainfuck.run("---")
    assert mem == [-3]
    assert mem |> length == 1
    assert output == <<>>
  end

  test "BF program: A" do
    {_addr, mem, output} = Brainfuck.run("++++++ [ > ++++++++++ < - ] > +++++ .")
    assert mem == [0, 65]
    assert mem |> length == 2
    assert output == "A"
  end

  test "BF program: Hello World!" do
    {_addr, mem, output} = Brainfuck.run load_fixture "hello_world.bf"
    assert mem == [0, 0, 72, 100, 87, 33, 10]
    assert mem |> length == 7
    assert output == "Hello World!\n"
  end

  test "BF program: modified Hello World!" do
    {_addr, mem, output} = Brainfuck.run load_fixture "hello_world_mod.bf"
    assert mem == [87, 0, 100, 0, 33, 10, 1]
    assert mem |> length == 7
    assert output == "Hello World!\n"
  end

  test "BF program: squares from 0 to 100" do
    {_addr, mem, output} = Brainfuck.run load_fixture "squares.bf"
    assert mem == [0, 203, 0, 0, 0, 0, 2, 1, 0, 1, 1, 0, 0, 9, 0, 2, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0]
    assert mem |> length == 26
    assert output == "0\n1\n4\n9\n16\n25\n36\n49\n64\n81\n100\n121\n144\n169\n196\n225\n256\n289\n324\n361\n400\n441\n484\n529\n576\n625\n676\n729\n784\n841\n900\n961\n1024\n1089\n1156\n1225\n1296\n1369\n1444\n1521\n1600\n1681\n1764\n1849\n1936\n2025\n2116\n2209\n2304\n2401\n2500\n2601\n2704\n2809\n2916\n3025\n3136\n3249\n3364\n3481\n3600\n3721\n3844\n3969\n4096\n4225\n4356\n4489\n4624\n4761\n4900\n5041\n5184\n5329\n5476\n5625\n5776\n5929\n6084\n6241\n6400\n6561\n6724\n6889\n7056\n7225\n7396\n7569\n7744\n7921\n8100\n8281\n8464\n8649\n8836\n9025\n9216\n9409\n9604\n9801\n10000\n"
  end

  def load_fixture file do
    case File.read "#{__DIR__}/fixtures/#{file}" do
      {:ok, body}   -> body
      {:error, err} -> raise "error loading file #{file}: #{err}"
    end
  end

end
