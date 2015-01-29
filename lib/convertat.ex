defmodule Convertat do
  @moduledoc """
  Provides functions for converting **from** and **to** arbitrary bases.
  """

  @type integer_base :: 2..36
  @type list_base :: []

  @doc """
  Converts any string of digits or list of digits (where each digit is a string)
  to a value in decimal base (base 10), given a starting base.

  The starting base can be an integer in the `2..36` range (in which case the
  native `String.to_integer/2` function is used) or a list with at least two
  elements (digits).

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

      iex> "test" |> Convertat.from_base(["onedigit"])
      ** (ArgumentError) list bases must have at least two digits

  """
  @spec from_base(String.t, integer_base) :: integer
  @spec from_base([] | String.t, list_base) :: integer
  def from_base(digits, base)

  def from_base("", _), do: 0

  def from_base([], _), do: 0

  def from_base(digits, base) when is_binary(digits) and is_integer(base),
    do: String.to_integer(digits, base)

  def from_base(_digits, base) when is_list(base) and length(base) < 2,
    do: raise(ArgumentError, "list bases must have at least two digits")

  def from_base(digits, base) when is_binary(digits) and is_list(base),
    do: digits |> String.codepoints |> from_base(base)

  def from_base(digits, base) when is_list(digits) and is_list(base) do
    numeric_base = Enum.count(base)
    digits_map = base
                  |> Enum.map(&to_string/1)
                  |> Enum.with_index
                  |> Enum.into(%{})

    Enum.reduce digits, 0, fn(digit, acc) ->
      Dict.get(digits_map, digit) + numeric_base * acc
    end
  end


  @doc """
  Converts a value in decimal base (`val`, which has to be an integer) to an
  arbitrary base. If the `:as_list` option is true, the resulting value in base
  `base` will be returned as a list of digits instead of a string of digits.

  ## Examples

      iex> 35 |> Convertat.to_base(36)
      "z"

      iex> 11 |> Convertat.to_base(["a", "b"])
      "babb"

      iex> 6 |> Convertat.to_base(["foo", "bar"], as_list: true)
      ["bar", "bar", "foo"]

      iex> 10 |> Convertat.to_base(["↓", "↑"])
      "↑↓↑↓"

      iex> 42 |> Convertat.to_base(["onedigitbase"])
      ** (ArgumentError) list bases must have at least two digits

  """
  @spec to_base(integer, integer_base | list_base, [as_list: true]) :: [String.t]
  @spec to_base(integer, integer_base | list_base, [as_list: false]) :: [String.t]
  def to_base(val, base, opts \\ [as_list: false])

  def to_base(_val, base, _opts) when is_list(base) and length(base) < 2,
    do: raise(ArgumentError, "list bases must have at least two digits")

  def to_base(val, base, as_list: as_list?) when is_integer(base) do
    result = val |> Integer.to_string(base) |> String.downcase
    if as_list?, do: String.codepoints(result), else: result
  end

  def to_base(0, base, as_list: as_list?) do
    if as_list?, do: [zero_digit(base)], else: zero_digit(base)
  end

  def to_base(val, base, opts) do
    result = do_to_base(val, base, Enum.count(base)) |> Enum.reverse
    if opts[:as_list], do: result, else: Enum.join(result)
  end

  @spec do_to_base(integer, list_base, non_neg_integer) :: [String.t]
  defp do_to_base(val, _base, _numeric_base) when val == 0, do: []
  defp do_to_base(val, base, numeric_base) do
    digit = Enum.at(base, rem(val, numeric_base))
    [digit|do_to_base(div(val, numeric_base), base, numeric_base)]
  end

  @compile {:inline, zero_digit: 1}
  @spec zero_digit(list_base) :: String.t
  defp zero_digit(base), do: base |> Enum.at(0) |> to_string
end
