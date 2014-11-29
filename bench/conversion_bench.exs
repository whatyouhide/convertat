defmodule ConversionBench do
  use Benchfella
  Code.require_file "lib/convertat.ex"

  @binary_string "101010101010101101010101010101010101010"
  @binary_base ["0", "1"]

  @long_base String.codepoints("01234567890qwertyuioplkjhgfd-=sazxcvbnm,./;'[]")
  @long_string String.codepoints("138fu10irmjq[qic-]10i4[r01ix34-ufpq09wuf-qrq")

  @vlmax 1000
  @very_long_base 1..@vlmax |> Enum.to_list
  @very_long_string Enum.map(1..100, fn(el) ->
    (:random.uniform * @vlmax) |> trunc |> to_string
  end)

  bench "from_base binary" do
    @binary_string |> Convertat.from_base(@binary_base)
  end

  bench "from_base long_base" do
    @long_string |> Convertat.from_base(@long_base)
  end

  bench "from_base very_long_base" do
    @very_long_string |> Convertat.from_base(@very_long_base)
  end

  bench "to_base to a binary string" do
    1042341212123412 |> Convertat.to_base(@binary_base)
  end

  bench "to_base to a binary list" do
    1042341212123412 |> Convertat.to_base(@binary_base, as_list: true)
  end

  bench "to_base to a long string" do
    1042341212123412 |> Convertat.to_base(@long_base)
  end

  bench "to_base to a long list" do
    1042341212123412 |> Convertat.to_base(@long_base, as_list: true)
  end

  bench "to_base to a VL string" do
    1042341212123412 |> Convertat.to_base(@very_long_base)
  end

  bench "to_base to a VL list" do
    1042341212123412 |> Convertat.to_base(@very_long_base, as_list: true)
  end
end
