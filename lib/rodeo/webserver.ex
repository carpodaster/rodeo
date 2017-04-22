defmodule Rodeo.Webserver do

  @port 8080

  def start(port \\ @port, identifier \\ __MODULE__)

  def start(:auto, identifier) do
    find_available_tcp_port()
    |> start(identifier)
  end

  @doc """
  Starts the server on a given TCP port `port`. You can pass `:auto` to
  find a random available TCP port. `identifier` is passed to `:cowboy`
  as its listener id.

  Returns a `{:ok, pid, port}` tuple.
  """
  def start(port, identifier) do
    {:ok, pid} = :cowboy.start_http(
      identifier, 100,
      [port: port],
      [env: [dispatch: router()]]
    )
    {:ok, pid, port}
  end

  @doc """
  See `Rodeo.Webserver.router` for format of `matches`.

  Example:

       iex>Rodeo.Webserver.start
       {:ok, #PID<0.306.0>}

       iex>Rodeo.Webserver.reload( {"/my/new/match", OtherHandler, []} )
       :ok
  """
  def reload(matches, identifier \\ __MODULE__) do
    :cowboy.set_env(identifier, :dispatch, router(matches))
  end

  @doc """
  Shortcut for `Rodeo.Webserver.reload({"/", handler, []})`.
  """
  def change_handler!(handler, identifier \\ __MODULE__) do
    reload({"/[...]", handler, []}, identifier)
  end

  @doc """
  Defines a default handler
  """
  def router do
    { "/[...]", Rodeo.Handler.Default, [] }
    |> router()
  end

  @doc """
  `matches` must be in format: `{ "/path/match/[...]", Handler, opts }`
  """
  def router(matches) when is_tuple(matches), do: router([matches])

  @doc """
  `matches` must be in format: `[{ "/foo/[...]", Handler, opts }]`
  """
  def router(matches) when is_list(matches) do
    :cowboy_router.compile([ { :_, matches } ])
  end

  defp find_available_tcp_port do
    {:ok, sock} = :gen_tcp.listen 0, []
    {:ok, port} = :inet.port(sock)
    :ok = :gen_tcp.close sock
    port
  end
end
