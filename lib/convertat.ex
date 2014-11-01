defmodule Convertat do
  @moduledoc """
  Provides functions for converting **from** and **to** arbitrary bases.
  """

  @doc """
  Convert any string of digits or list of digits (where each digit is a string)
  to a value in decimal base (base 10), given a starting base.

  ## Examples

      iex> "101" |> Convertat.from_base(2)
      5

      iex> "fe" |> Convertat.from_base(16)
      254

      iex> "foo" |> Convertat.from_base(["f", "o"])
      3
  """
  @spec from_base(String.t | list, integer | list) :: integer
  def from_base(digits, source_base)

  def from_base("", _), do: 0

  def from_base([], _), do: 0

  def from_base(digits, base) when is_integer(base) and base in 2..36 do
    digits = if is_binary(digits), do: to_char_list(digits), else: digits
    List.to_integer(digits, base)
  end

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


  @doc """
  Convert a value in decimal base (`val`) to an arbitrary base. If the
  `:as_list` option is true, the resulting value in base `base` will be returned
  as a list of digits.

  ## Examples

      iex> 35 |> Convertat.to_base(36)
      "z"

      iex> 11 |> Convertat.to_base(["a", "b"])
      "babb"

      iex> 6 |> Convertat.to_base(["foo", "bar"], as_list: true)
      ["bar", "bar", "foo"]
  """
  @spec to_base(integer, integer | list, [Keyword]) :: String.t | list
  def to_base(val, base, opts \\ [as_list: false])

  def to_base(val, base, opts) when is_integer(base) and base in 2..36 do
    result = val |> Integer.to_string(base) |> String.downcase
    if opts[:as_list], do: String.codepoints(result), else: result
  end

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
