defmodule Rodeo.CaseTest do
  use ExUnit.Case

  test "adds the 'with_webserver' macro" do
    use Rodeo.HTTPCase
    with_webserver do
      assert is_integer(port)
    end
  end

  test "exposes the TCP port variable" do
    require Rodeo.HTTPCase
    Rodeo.HTTPCase.with_webserver do
      assert is_integer(port)
    end
  end

  test "terminates the cowboy server after block execution" do
    require Rodeo.HTTPCase

    Rodeo.HTTPCase.with_webserver do
      assert {:ok, %{status_code: 200}} = HTTPoison.get("http://127.0.0.1:#{port}/")
    end

    {:error, %{reason: :econnrefused}} = HTTPoison.get("http://127.0.0.1:#{port}/")
  end

  test "injects a custom handler and brews tea" do
    require Rodeo.HTTPCase

    defmodule Teapot do
      use Rodeo.Handler
      def status(_), do: 418
    end

    Rodeo.HTTPCase.with_webserver Teapot do
      assert {:ok, %{status_code: 418}} = HTTPoison.get("http://127.0.0.1:#{port}/")
    end
  end

end

