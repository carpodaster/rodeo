defmodule Rodeo do
  # TODO make ip and scheme configurable
  defstruct [:port, {:ip_address, "127.0.0.1"}, {:scheme, "http"}]

  @doc ~S"""
  Creates a URL from the protocol scheme, the ip address and the
  TCP port extracted from `rodeo`, a `%Rodeo` struct.

  ## Examples

      iex>Rodeo.base_url(%Rodeo{port: 8080, ip_address: "127.0.0.1", scheme: "http" })
      "http://127.0.0.1:8080"
  """
  @spec base_url(struct()) :: String.t
  def base_url(rodeo) do
    rodeo.scheme <> "://" <> rodeo.ip_address <> ":" <> to_string(rodeo.port)
  end
end
