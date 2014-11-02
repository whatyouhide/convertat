defmodule ConvertatFacts do
  use ExUnit.Case, async: true

  # Run tests in the docstrings.
  doctest Convertat

  alias Convertat, as: C

  @base2 ["0", "1"]
  @base16 String.codepoints("0123456789abcdef")

  test "from_base with empty string is always 0" do
    assert C.from_base("", [0, 1])               === 0
    assert C.from_base("", Enum.to_list(0..100)) === 0
    assert C.from_base("", @base16)              === 0
    assert C.from_base("", 93)                   === 0

    assert C.from_base([], @base2)               === 0
    assert C.from_base([], 9494)                 === 0
  end

  test "from_base with array base 2 and string value" do
    assert C.from_base("10", @base2)       === 2
    assert C.from_base("100", @base2)      === 4
    assert C.from_base("11111111", @base2) === 255
    assert C.from_base("0", @base2)        === 0
    assert C.from_base("00", @base2)       === 0
    assert C.from_base("010", @base2)      === 2
  end

  test "from_base with array base 2 and list value" do
    assert C.from_base(["1", "0"], @base2)      === 2
    assert C.from_base(["0", "0", "1"], @base2) === 1
  end

  test "from_base with array base 16 and string value" do
    assert C.from_base("a", @base16)  === 10
    assert C.from_base("10", @base16) === 16
    assert C.from_base("ff", @base16) === 255
    assert C.from_base("fe", @base16) === 254
    assert C.from_base("09", @base16) === 9
  end

  test "from_base with custom array bases" do
    base = ["a", "b", "k"]
    assert C.from_base("k", base)   === 2
    assert C.from_base("ak", base)  === 2
    assert C.from_base("kba", base) === 21
  end

  test "from_base with integer base" do
    assert C.from_base("01", 2) === 1
    assert C.from_base('101', 2) === 5
    assert C.from_base("10", 13) === 13
    assert C.from_base('fe', 16) === 254
    assert C.from_base("z", 36) === 35
  end

  test "to_base with array base and string result" do
    assert C.to_base(10, @base2)  === "1010"
    assert C.to_base(0, @base2)   === "0"
    assert C.to_base(255, @base2) === "11111111"

    assert C.to_base(10, @base16)  === "a"
    assert C.to_base(0, @base16)   === "0"
    assert C.to_base(254, @base16) === "fe"
  end

  test "to_base with array base and array result" do
    assert C.to_base(10, @base2, as_list: true)  === ["1", "0", "1", "0"]
    assert C.to_base(0, @base2, as_list: true)   === ["0"]

    assert C.to_base(10, @base16, as_list: true)  === ["a"]
    assert C.to_base(0, @base16, as_list: true)   === ["0"]
    assert C.to_base(254, @base16, as_list: true) === ["f", "e"]
  end

  test "to_base with integer base" do
    assert C.to_base(10, 2) === "1010"
    assert C.to_base(0, 16) === "0"
    assert C.to_base(254, 16) === "fe"
    assert C.to_base(19, 19) === "10"
    assert C.to_base(35, 36, as_list: true) === ["z"]
    assert C.to_base(11, 2, as_list: true) === ["1", "0", "1", "1"]
  end

  test "entire chain in base 2" do
    actual = "1010" |> C.from_base(@base2) |> C.to_base(@base16)
    assert actual === "a"
  end

  test "entire chain in base 16" do
    actual = "fe" |> C.from_base(@base16) |> C.to_base(@base2)
    assert actual === "11111110"
  end

  test "entire chain in exoteric base" do
    actual = "kikki" |> C.from_base(["k", "i"]) |> C.to_base(@base2)
    assert actual === "1001"
  end

  test "entire chain with unicode characters" do
    base = ["↓", "↑"]
    assert C.from_base("↓↓↓", base) === 0
    assert C.from_base("↑↓", base) === 2

    assert C.to_base(2, base) === "↑↓"
    assert C.to_base(0, base) === "↓"
  end
end
