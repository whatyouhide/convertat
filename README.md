# Convertat

[![Build Status](https://travis-ci.org/whatyouhide/convertat.svg?branch=master)](https://travis-ci.org/whatyouhide/convertat)
[![Coverage Status](https://img.shields.io/coveralls/whatyouhide/convertat.svg?style=flat)](https://coveralls.io/r/whatyouhide/convertat)
[![Package](http://img.shields.io/hexpm/v/convertat.svg?style=flat)](https://hex.pm/packages/convertat)
[![License](https://img.shields.io/hexpm/l/convertat.svg?style=flat)](LICENSE.txt)

Convertat is a small Elixir library that provides functions for converting
values **from** and **to** arbitrary bases.


## Installation and docs

To use this library with Mix, just declare its dependency in the `mix.exs` file:

``` elixir
defp deps do
  [
    # Using the hex package manager:
    {:convertat, "~> 1.0"},
    # or grabbing the latest version (master branch) from GitHub:
    {:convertat, github: "whatyouhide/convertat"},
  ]
end
```

Then run `mix deps.get`. The documentation for the current and the older
versions of Convertat can be found on its [hex.pm
page](https://hex.pm/packages/convertat).


## Usage

Convertat leverages on the power of the `|>` operator in order to provide a
clean syntax for converting values between bases. The only two functions that it
exports are `Convertat.from_base/2` and `Convertat.to_base/3`.

For example, say we want to convert the binary value `"11011"` (27 in base 10)
to its hex representation:

``` elixir
iex> "10110" |> Convertat.from_base(2) |> Convertat.to_base(16)
"1b"
```

That's pretty straightforward and, moreover, easily achievable using Elixir's
standard library (`String.to_integer/2` and `to_string/1`). In fact, when using
*integers* as bases, you're limited to the standard `2..36` range.

What about this:

``` elixir
iex> "↑↓↑" |> Convertat.from_base(["↓", "↑"])
5
```

We just used a *binary* (it has two digits) base where the digits are the `"↓"`
and `"↑"` strings.

Digits in list bases are listed from the least significant one to the most
significant one; in the above example, `↓` would be 0 in the binary base while
`↑` would be 1.

We can also use lists as values (instead of strings); this allows for some cool
multicharacter-digits bases. Here's another binary base:

``` elixir
iex> ["foo", "bar"] |> Convertat.from_base(["bar", "foo"])
2
```

As you can see, digits significance in list values is the opposite from bases:
the least significant digits are on the right, like they would be in written
numbers.

While the `from_base/2` function converts a value in an arbitrary base to an
integer in base 10, the `to_base/3` function does the opposite:

``` elixir
iex> 20 |> Convertat.to_base(["a", "b"])
"babaa"
```

As with `from_base`, bases can be integers (in the `2..36` range, just like with
the standard library) or lists of digits.

By default, a string representation of the converted number is returned. You
can also specify that you want a list:

``` elixir
iex> 16 |> Convertat.to_base(16, as_list: true)
["1", "0"]
```

This may seem useless, but think of the multichar-digits base from above:

``` elixir
iex> 2 |> Convertat.to_base(["bar", "foo"])
"foobar"
```

How can you parse `"foobar"` back into a base 10 value with the same `["bar",
"foo"]` base?

``` elixir
iex> base = ["bar", "foo"]
["bar", "foo"]
iex> val = 2 |> Convertat.to_base(base, as_list: true)
["foo", "bar"]
iex> val |> Convertat.from_base(base)
2
```

One more thing: if you're converting between bases a lot of times, consider
`import`ing the two functions for a uber-clean syntax:

``` elixir
iex> import Convertat, only: :functions
nil
iex> "1011" |> from_base(2) |> to_base(16)
"b"
```


## Contributing

If you wish to contribute to this project, well, thanks! You know the deal:

* fork the repository
* make changes and **add/update tests**
* make sure the tests pass by running `mix test`
* commit changes
* open a pull request

Feel free to open an issue if you find something wrong with the library.


## License

MIT &copy; 2014 Andrea Leopardi, see [the license file](LICENSE.txt)
