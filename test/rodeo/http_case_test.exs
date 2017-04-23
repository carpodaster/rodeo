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

end

