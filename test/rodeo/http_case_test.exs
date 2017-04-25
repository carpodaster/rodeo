defmodule Rodeo.CaseTest do
  use ExUnit.Case, async: true

  test "adds the 'with_webserver' macro" do
    use Rodeo.HTTPCase
    with_webserver fn rodeo ->
      assert is_integer(rodeo.port)
    end
  end

  test "exposes the data for running server" do
    require Rodeo.HTTPCase
    Rodeo.HTTPCase.with_webserver fn rodeo ->
      assert is_integer(rodeo.port)
      assert rodeo.ip_address == "127.0.0.1"
      assert rodeo.scheme == "http"
    end
  end

  test "terminates the cowboy server after block execution" do
    require Rodeo.HTTPCase
    Agent.start(fn -> nil end, name: :rodeo_port_check)

    Rodeo.HTTPCase.with_webserver fn rodeo ->
      Agent.update(:rodeo_port_check, fn _ -> rodeo.port end)
      assert {:ok, %{status_code: 200}} = HTTPoison.get("http://127.0.0.1:#{rodeo.port}/")
    end

    port = Agent.get(:rodeo_port_check, &(&1))
    {:error, %{reason: :econnrefused}} = HTTPoison.get("http://127.0.0.1:#{port}/")
    Agent.stop(:rodeo_port_check)
  end

  test "injects a custom handler and brews tea" do
    require Rodeo.HTTPCase

    defmodule Teapot do
      use Rodeo.Handler
      def status(_), do: 418
    end

    Rodeo.HTTPCase.with_webserver Teapot, fn rodeo ->
      assert {:ok, %{status_code: 418}} = HTTPoison.get("http://127.0.0.1:#{rodeo.port}/")
    end
  end

end

