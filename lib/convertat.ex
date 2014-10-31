defmodule Convertat do
  def from_base("", _), do: 0

  def from_base([], _), do: 0

  def from_base(digits, source_base) when is_binary(digits) do
    digits |> String.codepoints |> from_base(source_base)
  end

  def from_base(digits, source_base) do
    numeric_base = Enum.count(source_base)
    source_base = Enum.map source_base, &to_string/1

    digits_with_indexes = digits |> Enum.reverse |> Enum.with_index
    Enum.reduce(digits_with_indexes, 0, fn({digit, i}, acc) ->
      acc + digit_value_in_base10(source_base, digit) * pow(numeric_base, i)
    end)
  end


  def to_base(val, base, opts \\ [as_list: false])
  def to_base(0, base, as_list: false), do: zero_digit(base)
  def to_base(0, base, as_list: true), do: List.wrap(zero_digit(base))
  def to_base(val, base, opts) do
    result = _to_base(val, base) |> Enum.reverse
    if opts[:as_list], do: result, else: Enum.join(result)
  end

  defp _to_base(val, _base) when val == 0, do: []
  defp _to_base(val, base) do
    numeric_base = Enum.count(base)
    digit = Enum.at(base, rem(val, numeric_base))
    [ digit | _to_base(div(val, numeric_base), base) ]
  end

  defp zero_digit(base), do: base |> Enum.at(0) |> to_string

  defp digit_value_in_base10(base, digit) do
    base |> Enum.find_index(&(&1 === digit))
  end

  # Fast exponentiation.
  defp pow(_, 0), do: 1
  defp pow(1, _), do: 1
  defp pow(base, exp) when rem(exp, 2) === 1, do: base * pow(base, exp - 1)
  defp pow(base, exp) do
    half = pow(base, div(exp, 2))
    half * half
  end
end
