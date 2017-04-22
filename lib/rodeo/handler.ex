defmodule Rodeo.Handler do
  @moduledoc "Defines boilerplate interface"
  @doc false
  defmacro __using__(_opts) do
    quote do
      def body(_),    do: ""
      def headers(_), do: []
      def status(_),  do: 200

      def init({:tcp, :http}, req, opts) do
        {:ok, resp} = :cowboy_req.reply(status(req), headers(req), body(req), req)
        {:ok, resp, opts}
      end

      def init(req, state, _opts) do
        handle(req, state)
      end

      def handle(request, state) do
        {:ok, request, state}
      end

      @doc "Extract the request's headers as list of key/value pairs"
      def request_headers(req) do
        elem(req, 16)
      end

      @doc "Extract the request URI (path with leading /)"
      def request_path(req) do
        elem(req, 11)
      end

      def terminate(_reason, _request, _state), do: :ok

      defoverridable [body: 1, headers: 1, status: 1, handle: 2]
    end
  end
end
