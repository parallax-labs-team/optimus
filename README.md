# Optimus

Internal (lol) Elixir library for the [Prime Trust API](https://documentation.primetrust.com).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `optimus` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:optimus, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/optimus>.

## Getting Started

To do anything with the Prime Trust API, you have to create an account [per their documentation](https://documentation.primetrust.com/#section/Creating-a-User).

For now, a script named `create-account-jwt.sh` is provided that will set up your account and create a JWT you can use in your environment.

```
# in the terminal

# modify the NAME, AUTH_EMAIL, AUTH_PASSWORD values in the script
./create-account-jwt.sh
```
