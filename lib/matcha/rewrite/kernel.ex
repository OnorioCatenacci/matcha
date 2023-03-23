defmodule Matcha.Rewrite.Kernel do
  @moduledoc """
  Replacements for Kernel functions when rewriting Elixir into match specs.

  These are versions that play nicer with Erlang's match spec limitations.
  """

  import Kernel, except: [and: 2, or: 2, is_boolean: 1]

  @doc """
  Re-implements `Kernel.and/2`.

  This ensures that Elixir 1.6.0+'s [boolean optimizations](https://github.com/elixir-lang/elixir/commit/25dc8d8d4f27ca105d36b06f3f23dbbd0b823fd0)
  don't create (disallowed) case statements inside match spec bodies.
  """
  defguard left and right when :erlang.andalso(left, right)

  @doc """
  Re-implements `Kernel.or/2`.

  This ensures that Elixir 1.6.0+'s [boolean optimizations](https://github.com/elixir-lang/elixir/commit/25dc8d8d4f27ca105d36b06f3f23dbbd0b823fd0)
  don't create (disallowed) case statements inside match spec bodies.
  """
  defguard left or right when :erlang.orelse(left, right)

  @doc """
  Re-implements `Kernel.is_boolean/1`.

  The original simply calls out to `:erlang.is_boolean/1`, which is
  not allowed in match specs. Instead, we re-implement it in terms of
  things that are.
  """
  defguard is_boolean(value)
           when is_atom(value) and (value == true or value == false)
end
