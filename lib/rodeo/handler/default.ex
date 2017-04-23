defmodule Rodeo.Handler.Default do

  @moduledoc "A handler returning 'Hello World' as plain text response."

  use Rodeo.Handler

  @doc false
  def body(_), do: "Hello World"

  @doc false
  def headers(_), do: [{"content-type", "text/plain; charset=utf-8"}]
end
