defmodule Rodeo.Handler.Default do
  use Rodeo.Handler
  def body(_), do: "Hello World"
  def headers(_), do: [{"content-type", "text/plain; charset=utf-8"}]
end
