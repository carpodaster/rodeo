# Rodeo [![Build Status](https://travis-ci.org/carpodaster/rodeo.svg?branch=master)](https://travis-ci.org/carpodaster/rodeo) [![Inline docs](http://inch-ci.org/github/carpodaster/rodeo.svg)](http://inch-ci.org/github/carpodaster/rodeo)

When testing HTTP calls made by your Mix application, your options are to either fire them to the real HTTP endpoint (requires net availability and may count against an API's rate limit) or use a mock (be it is a [noun or a verb](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/)).

Or you could fire real HTTP requests to a real _in promptu_ webserver instead. Rodeo spawns one-off [cowboy](https://hex.pm/packages/cowboy) webserver instances that reply based on a simple handler API.

(Cowboy… Rodeo… get it?)

## Installation

1. Add `rodeo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:rodeo, "~> 0.2.0"}]
end
```

2. Ensure `rodeo` is started before your application. Also, you need to add `cowboy`:

```elixir
def application do
  [applications: [:cowboy, :rodeo]]
end
```
