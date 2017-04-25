# Rodeo [![Build Status](https://travis-ci.org/carpodaster/rodeo.svg?branch=master)](https://travis-ci.org/carpodaster/rodeo) [![Inline docs](http://inch-ci.org/github/carpodaster/rodeo.svg)](http://inch-ci.org/github/carpodaster/rodeo)

When testing HTTP calls made by your Mix application, your options are to either fire them to the real HTTP endpoint (requires net availability and may count against an API's rate limit) or use a mock (be it is a [noun or a verb](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)).

Or you could fire real HTTP requests to a real _in promptu_ webserver instead. Rodeo spawns one-off [cowboy](https://hex.pm/packages/cowboy) webserver instances that reply based on a simple handler API.

(Cowboy… Rodeo… get it?)

## Installation

1. Add `rodeo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rodeo, "~> 0.3.0"}]
end
```

2. Ensure `rodeo` is started before your application. Also, you need to add `cowboy`:

```elixir
def application do
  [applications: [:cowboy, :rodeo]]
end
```

## Usage

Rodeo provides a `with_webserver` macro that can be used in a test case:

```elixir
defmodule MyApp.APIClientTest do
  use ExUnit.Case
  use Rodeo.HTTPCase

  test "will start a new cowboy server on a free tcp port" do
    with_webserver fn rodeo ->
      # rodeo is a %Rodeo{} struct, holding the port of the web server
      assert HTTPoison.get!("http://127.0.0.1:#{rodeo.port}/") == "Hello World"
    end
    # The webserver is torn down again at this point
  end

  test "uses a custom request handler" do
    defmodule Teapot do
      use Rodeo.Handler
      def body(_req),   do: "I'm a teapot"
      def status(_req), do: 418
    end

    with_webserver Teapot, fn rodeo ->
      # Rodeo.base_url is a convenience function to
      # glue scheme, ip and port together
      assert HTTPoison.get!(Rodeo.base_url(rodeo) <> "/earl-grey") == "I'm a teapot"
    end
  end
end
```

## Writing your own handlers

Rodeo provides `Rodeo.Handler` that can be used as a template for custom handlers (see [module documentation](https://hexdocs.pm/rodeo/Rodeo.Handler.html)).

```elixir
defmodule MyApp.InternalServerError do
  use Rodeo.Handler

  def status(_),  do: 500
  def body(_),    do: "Oooops!"
  def headers(_), do: [{"X-Reason", "Server rolled a 1"}]
end
```
