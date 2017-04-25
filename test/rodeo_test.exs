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
end
