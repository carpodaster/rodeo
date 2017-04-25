defmodule Rodeo do
  # TODO make ip and scheme configurable
  defstruct [:port, {:ip_address, "127.0.0.1"}, {:scheme, "http"}]
end
