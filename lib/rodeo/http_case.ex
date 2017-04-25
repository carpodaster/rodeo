defmodule Rodeo.HTTPCase do

  @doc false
  defmacro __using__(_opts) do
    quote do
      import(unquote(__MODULE__))
    end
  end

  @doc ~S"""
  Starts a cowboy server at a random open TCP port with handler `handler`
  (see `Rodeo.Handler`), calls the passed function and terminates the server
  instance.

  The function is passed a `%Rodeo{}` struct.

  ## ExUnit Example

      test "my private webserver with explicit require" do
        require Rodeo.HTTPCase
        Rodeo.HTTPCase.with_webserver(:my_handler), fn rodeo ->
          assert is_integer(rodeo.port)
        end
      end

      test "my private webserver with 'use Rodeo.HTTPCase'" do
        with_webserver(:my_handler, fn rodeo -> assert(is_integer(rodeo.port)) end)
      end

      test "uses default handler" do
        with_webserver fn rodeo ->
          "Cowboy server running on port #{rodeo.port}"
        end
      end
  """
  def with_webserver(handler, fun) do
    cowboy_ref = :crypto.strong_rand_bytes(24) |> Base.url_encode64 |> binary_part(0, 24) |> String.to_atom
    {:ok, _pid, port} = Rodeo.HTTP.start :auto, cowboy_ref
    Rodeo.HTTP.change_handler! handler, cowboy_ref
    fun.(%Rodeo{port: port})
    :cowboy.stop_listener cowboy_ref
  end

  def with_webserver(fun) when is_function(fun), do: with_webserver(Rodeo.Handler.Default, fun)

end
