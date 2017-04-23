defmodule Rodeo.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :rodeo,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     source_url: "https://github.com/carpodaster/rodeo",
     description: "Test your API consuming Elixir app against a real (one-off) webserver",
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:httpoison, "~> 0.11", only: :test}
    ]
  end

  def package do
    [
      maintainers: ["Carsten Zimmermann"],
      licenses: ["BSD"],
      links: %{"GitHub" => "https://github.com/carpodaster/rodeo"},
    ]
  end
end
