# Convertat

*Convertat* is a small Elixir library that provides functions for converting
values **from** and **to** arbitrary bases.


## Installation

To use this library with Mix, just declare its dependency in the `mix.exs` file:

``` elixir
defp deps do
  [
    # Using the hex package manager:
    {:convertat, "~> 1.0"},
    # or grabbing the lastes version (master branch) from GitHub:
    {:convertat, github: "whatyouhide/convertat"},
  ]
end
```

Then run `mix deps.get` and go on with your life.


## Usage

Convertat leverages on the power of the `|>` operator in order to provide a
clean syntax for converting values between bases.

For example, say we want to convert the binary value `"11011"` (27 in base 10)
to its hex representation:

``` elixir
"10110" |> Convertat.from_base(2) |> Convertat.to_base(16) #=> "1b"
```

That's pretty straightforward and, moreover, easily achievable using Elixir's
standard library. In fact, when using integers as bases, you're limited to the
standard `2..36` range. What about this:

``` elixir
"↑↓↑" |> Convertat.from_base(["↓", "↑"]) #=> 5
```

We just used a (*binary*, since it has two digits) base where the digits are the
`↓` and `↑` characters.

Digits in list bases are listed from the least significant one to the most
significant one; in the above example, `↓` would be 0 in the binary base while
`↑` would be 1.

We can also use lists as values (instead of strings); this allows for some cool
multicharacter-digits bases. Here's another binary base:

``` elixir
["foo", "bar"] |> Convertat.from_base(["bar", "foo"]) #=> 2
```

As you can see, digits significance in list values is the opposite from list
bases: the least significant digits are on the right, like they would be in
written numbers.

As you just saw, the `from_base` function converts a value in an arbitrary base
to an integer in base 10. The `to_base` functions does the opposite: it converts
an integer (in base 10) into a value in an arbitrary base.

``` elixir
20 |> Convertat.to_base(["a", "b"]) #=> "babaa"
```

As with `from_base`, bases can be integers (in the `2..36` range, just like with
the standard library) or lists of digits.

By default, a string representation of the converted number is returned. You
can also specify that you want a list:

``` elixir
16 |> Convertat.to_base(16, as_list: true) #=> "10"
```

This may seem useless, but think of the multichar-digits base from above:

``` elixir
2 |> Convertat.to_base(["bar", "foo"]) #=> "foobar"
```

How can you parse `"foobar"` back into a base 10 value with the same `["bar",
"foo"]` base?

``` elixir
base = ["bar", "foo"]
val = 2 |> Convertat.to_base(base, as_list: true) #=> val = ["foo", "bar"]
val |> Convertat.from_base(base) #=> 2
```


## License

MIT &copy; 2014 Andrea Leopardi, see [the license file](LICENSE.txt)
