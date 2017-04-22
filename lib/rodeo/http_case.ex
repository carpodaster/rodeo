defmodule Rodeo.HTTPCase do

  defmacro with_webserver(handler, do: block) do
    quote do
      cowboy_ref = :crypto.strong_rand_bytes(24) |> Base.url_encode64 |> binary_part(0, 24) |> String.to_atom
      {:ok, _pid, var!(port)} = Rodeo.Webserver.start :auto, cowboy_ref
      Rodeo.Webserver.change_handler! unquote(handler), cowboy_ref
      unquote(block)
      :cowboy.stop_listener cowboy_ref
    end
  end

end
