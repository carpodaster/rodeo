defmodule Rodeo.HTTPTest do
  use ExUnit.Case

  describe "Rodeo.HTTP.start/2" do
    test "starts a server on 127.0.0.1:8080 by default" do
      assert {:ok, _pid, port} = Rodeo.HTTP.start
      assert port == 8080

      assert {:ok, response} = HTTPoison.get("http://127.0.0.1:8080/")
      assert response.status_code == 200

      :cowboy.stop_listener Rodeo.HTTP
    end

    test "starts a server on the specified port" do
      assert {:ok, _pid, port} = Rodeo.HTTP.start 4711
      assert port == 4711

      assert {:ok, response} = HTTPoison.get("http://127.0.0.1:4711/")
      assert response.status_code == 200

      :cowboy.stop_listener Rodeo.HTTP
    end

    test "starts a server on a random free tcp port" do
      assert {:ok, _pid, port} = Rodeo.HTTP.start :auto
      assert is_integer(port)

      assert {:ok, response} = HTTPoison.get("http://127.0.0.1:#{port}/")
      assert response.status_code == 200

      :cowboy.stop_listener Rodeo.HTTP
    end

    test "assigns the specified name to the cowboy server" do
      assert {:ok, _pid, port} = Rodeo.HTTP.start :auto, :my_rodeo_test_server

      assert {:ok, response} = HTTPoison.get("http://127.0.0.1:#{port}/")
      assert response.status_code == 200

      assert {:error, :not_found} = :cowboy.stop_listener(Rodeo.HTTP) # the default name
      assert :ok = :cowboy.stop_listener(:my_rodeo_test_server)
    end

    test "complains about a server process with the same name already running" do
      assert {:ok, pid, _} = Rodeo.HTTP.start
      assert {:error, {:already_started, ^pid}} = Rodeo.HTTP.start(:auto)

      :cowboy.stop_listener(Rodeo.HTTP)
    end
  end

end
