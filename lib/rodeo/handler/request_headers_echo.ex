defmodule Rodeo.Handler.RequestHeadersEcho do

  @moduledoc """
  This handler returns the client's request headers as its body.
  """

  use Rodeo.Handler

  def headers(_), do: [{"content-type", "text/plain; charset=utf-8"}]

  @doc """
  Returns request headers as "header: value"
  """
  def body(req) do
    req
    |> request_headers
    |> Enum.map(&join/1)
    |> Enum.join("\n")
    |> add_remote_ip(req)
    |> prepend_banner
  end

  defp join(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.join(": ")
  end

  defp add_remote_ip(body, req) do
    remote_ip = elem(req, 8)
    body <> "\n\n" <> "remote_ip: #{remote_ip}"
  end

  defp prepend_banner(body) do
    ~S"""
    Welcome to ECHO BASE
    """
    |> Kernel.<>(body)
  end
end
