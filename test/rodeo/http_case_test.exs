defmodule Rodeo.CaseTest do
  use ExUnit.Case

  @handler Rodeo.Handler.Default

  test "adds the 'with_webserver' macro" do
    use Rodeo.HTTPCase
    with_webserver @handler do
      assert is_integer(port)
    end
  end

  test "exposes the TCP port variable" do
    require Rodeo.HTTPCase
    Rodeo.HTTPCase.with_webserver @handler do
      assert is_integer(port)
    end
  end

  test "terminates the cowboy server after block execution" do
    require Rodeo.HTTPCase

    Rodeo.HTTPCase.with_webserver @handler do
      assert {:ok, %{status_code: 200}} = HTTPoison.get("http://127.0.0.1:#{port}/")
    end

    {:error, %{reason: :econnrefused}} = HTTPoison.get("http://127.0.0.1:#{port}/")
  end

end

