defmodule Convertat do
  @type base :: non_neg_integer | list(String.t)

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

      iex> "↑" |> Convertat.from_base(["↓", "↑"])
      1

      iex> ["foo", "bar"] |> Convertat.from_base(["bar", "foo"])
      2
  """
  @spec from_base(String.t | list(String.t), base) :: non_neg_integer
  def from_base(digits, source_base)

  def from_base("", _), do: 0

  def from_base([], _), do: 0

  def from_base(digits, base) when is_binary(digits)
  and is_integer(base)
  and base in 2..36 do
    String.to_integer(digits, base)
  end

  def from_base(digits, source_base) when is_binary(digits) do
    digits |> String.codepoints |> from_base(source_base)
  end

  def from_base(digits, source_base) do
    numeric_base = Enum.count(source_base)
    digits_map = source_base
                  |> Enum.map(&to_string/1)
                  |> Enum.with_index
                  |> Enum.into(%{})

    Enum.reduce(digits, 0, fn(digit, acc) ->
      Dict.get(digits_map, digit) + numeric_base * acc
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

      iex> 10 |> Convertat.to_base(["↓", "↑"])
      "↑↓↑↓"
  """
  @spec to_base(non_neg_integer, base, [Keyword]) :: String.t | list(String.t)
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

  @spec _to_base(non_neg_integer, base) :: list(String.t)
  defp _to_base(val, _base) when val == 0, do: []
  defp _to_base(val, base) do
    numeric_base = Enum.count(base)
    digit = Enum.at(base, rem(val, numeric_base))
    [ digit | _to_base(div(val, numeric_base), base) ]
  end

  @spec zero_digit(base) :: String.t
  defp zero_digit(base), do: base |> Enum.at(0) |> to_string
end
