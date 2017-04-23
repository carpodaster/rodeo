defmodule Rodeo.HTTPCase do

  @doc false
  defmacro __using__(_opts) do
    quote do
      import(unquote(__MODULE__))
    end
  end

  @doc """
  Starts a cowboy server at a random open TCP port with handler `handler`
  (see `Rodeo.Handler`), runs `block` and terminates the server instance.

  The variable `port` is available within the block, holding the TCP port
  number of the running cowboy web server.

  ## ExUnit Example

      test "my private webserver with explicit require" do
        require Rodeo.HTTPCase
        Rodeo.HTTPCase.with_webserver(:my_handler) do
          assert is_integer(port)
        end
      end

      test "my private webserver calling __using__ first" do
        use Rodeo.HTTPCase
        with_webserver(:my_handler), do: assert(is_integer(port))
      end
  """
  defmacro with_webserver(handler, do: block) do
    quote do
      cowboy_ref = :crypto.strong_rand_bytes(24) |> Base.url_encode64 |> binary_part(0, 24) |> String.to_atom
      {:ok, _pid, var!(port)} = Rodeo.HTTP.start :auto, cowboy_ref
      Rodeo.HTTP.change_handler! unquote(handler), cowboy_ref
      unquote(block)
      :cowboy.stop_listener cowboy_ref
    end
  end

end
