defmodule ConvertatFacts do
  use ExUnit.Case, async: true
  import Convertat, only: :functions

  # Run the tests in the docstrings.
  doctest Convertat

  @base2 ["0", "1"]
  @base16 String.codepoints("0123456789abcdef")

  test "from_base with integer base" do
    assert from_base("01", 2)  === 1
    assert from_base("10", 13) === 13
    assert from_base("z", 36)  === 35
    assert from_base("0", 30)  === 0
  end

  test "from_base with empty string or list of digits is always 0" do
    # Empty strings with different bases.
    assert from_base("", [0, 1])               === 0
    assert from_base("", Enum.to_list(0..100)) === 0
    assert from_base("", @base16)              === 0
    assert from_base("", ['ø', 1])             === 0
    assert from_base("", 93)                   === 0

    # Empty list.
    assert from_base([], @base2)               === 0
    assert from_base([], 9494)                 === 0
    assert from_base([], ['ø', 1])             === 0
    assert from_base([], ["foo", "bar"])       === 0
  end

  test "from_base with array base 2 and string value" do
    assert from_base("10", @base2)       === 2
    assert from_base("100", @base2)      === 4
    assert from_base("11111111", @base2) === 255
    assert from_base("0", @base2)        === 0
    assert from_base("00", @base2)       === 0
    assert from_base("010", @base2)      === 2
  end

  test "from_base with array base 16 and string value" do
    assert from_base("a", @base16)  === 10
    assert from_base("10", @base16) === 16
    assert from_base("ff", @base16) === 255
    assert from_base("fe", @base16) === 254
    assert from_base("09", @base16) === 9
  end

  test "from_base with single-char-string digits base" do
    assert from_base(["1", "0"], @base2)      === 2
    assert from_base(["0", "0", "1"], @base2) === 1

    base = ["a", "b", "k"]
    assert from_base("k", base)   === 2
    assert from_base("ak", base)  === 2
    assert from_base("kba", base) === 21
  end

  test "from_base with non-string digits in the base" do
    base = [1, '*']
    assert from_base("1**", base) === 3
    assert from_base("1", base) === 0
  end

  test "from_base with multichar digits in the base" do
    base = ["føø", "bar", "π"]
    assert from_base(["føø", "føø", "π"], base) === 2
  end

  test "to_base with array base and string result" do
    assert to_base(10, @base2)  === "1010"
    assert to_base(0, @base2)   === "0"
    assert to_base(255, @base2) === "11111111"

    assert to_base(10, @base16)  === "a"
    assert to_base(0, @base16)   === "0"
    assert to_base(254, @base16) === "fe"
  end

  test "to_base with array base and array result" do
    assert to_base(10, @base2, as_list: true)  === ["1", "0", "1", "0"]
    assert to_base(0, @base2, as_list: true)   === ["0"]

    assert to_base(10, @base16, as_list: true)  === ["a"]
    assert to_base(0, @base16, as_list: true)   === ["0"]
    assert to_base(254, @base16, as_list: true) === ["f", "e"]
  end

  test "to_base with integer base" do
    assert to_base(10, 2) === "1010"
    assert to_base(254, 16) === "fe"
    assert to_base(19, 19) === "10"
    assert to_base(35, 36, as_list: true) === ["z"]
    assert to_base(11, 2, as_list: true) === ["1", "0", "1", "1"]
  end

  test "to_base with 0 as a value (first digit of the base)" do
    assert to_base(0, 16) === "0"
    assert to_base(0, 22, as_list: true) === ["0"]
    assert to_base(0, ["π", "ø"], as_list: true) === ["π"]
    assert to_base(0, ['^', 1], as_list: true) === ["^"]
    assert to_base(0, ["foo", "bar"]) === "foo"
  end

  test "entire chain in base 2" do
    actual = "1010" |> from_base(@base2) |> to_base(@base16)
    assert actual === "a"
  end

  test "entire chain in base 16" do
    actual = "fe" |> from_base(@base16) |> to_base(@base2)
    assert actual === "11111110"
  end

  test "entire chain in exoteric base" do
    actual = "kikki" |> from_base(["k", "i"]) |> to_base(@base2)
    assert actual === "1001"
  end

  test "entire chain with unicode characters" do
    base = ["↓", "↑"]
    assert from_base("↓↓↓", base) === 0
    assert from_base("↑↓", base) === 2

    assert to_base(2, base) === "↑↓"
    assert to_base(0, base) === "↓"
  end

  test "from_base/2: invalid integer bases" do
    assert_raise ArgumentError, fn -> from_base("foo", -10) end
    assert_raise ArgumentError, fn -> from_base("foo", 0) end
    assert_raise ArgumentError, fn -> from_base("foo", 1) end
    assert_raise ArgumentError, fn -> from_base("foo", 55) end
  end

  test "to_base/2: invalid integer bases" do
    assert_raise ArgumentError, fn -> to_base(42, -10) end
    assert_raise ArgumentError, fn -> to_base(42, 0) end
    assert_raise ArgumentError, fn -> to_base(42, 1) end
    assert_raise ArgumentError, fn -> to_base(42, 55) end
  end

  test "invalid list bases" do
    msg = "list bases must have at least two digits"
    assert_raise ArgumentError, msg, fn -> from_base("foo", []) end
    assert_raise ArgumentError, msg, fn -> from_base("foo", ["onedigit"]) end
    assert_raise ArgumentError, msg, fn -> to_base(42, []) end
    assert_raise ArgumentError, msg, fn -> to_base(42, ["onedigit"]) end
  end
end
