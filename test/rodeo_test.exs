defmodule RodeoTest do
  use ExUnit.Case
  doctest Rodeo

  describe "the %Rodeo{} struct" do
    test "has a port" do
      assert %Rodeo{}.port == nil
    end
  end
end
