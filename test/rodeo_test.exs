defmodule RodeoTest do
  use ExUnit.Case
  doctest Rodeo

  describe "the %Rodeo{} struct" do
    test "has a port" do
      assert %Rodeo{}.port == nil
    end

    test "has an ip address" do
      assert %Rodeo{}.ip_address == "127.0.0.1"
    end

    test "has a protocol scheme" do
      assert %Rodeo{}.scheme == "http"
    end
  end

  describe "base_url/1" do
    test "creates a URL from scheme, host and port" do
      rodeo = %Rodeo{ip_address: "10.0.0.1", port: 8080, scheme: "https"}
      assert Rodeo.base_url(rodeo) == "https://10.0.0.1:8080"
    end
  end
end
