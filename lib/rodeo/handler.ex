defmodule Rodeo.Handler do
  @moduledoc """
  Defines the boilerplate callback functions to interface with
  cowboy's routing. Functions `body/1`, `headers/1`, and `status/1`
  can be overriden, receiving the cowboy request as their argument.

  `handle/2` may be overriden in rare cases to insert logic immediately
  after `init/3`.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do

      @doc "A string representing the response's body."
      def body(_),    do: ""

      @doc "A list of key/value response headers."
      def headers(_), do: []

      @doc "The HTTP status code."
      def status(_),  do: 200

      @doc false
      def init({:tcp, :http}, req, opts) do
        {:ok, resp} = :cowboy_req.reply(status(req), headers(req), body(req), req)
        {:ok, resp, opts}
      end

      @doc false
      def init(req, state, _opts) do
        handle(req, state)
      end

      @doc """
      Called by `init/3`. Expected to return a tuple `{:ok, request, state}`.
      """
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

      @doc false
      def terminate(_reason, _request, _state), do: :ok

      defoverridable [body: 1, headers: 1, status: 1, handle: 2]
    end
  end
end
