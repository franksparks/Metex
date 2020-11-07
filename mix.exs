defmodule Metex.MixProject do
  use Mix.Project

  def project do
    [
      app: :metex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :json]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dep_from_hexpm, "~> 0.3.0"},
      {:ex_doc, "~> 0.23"},
      {:httpoison, "~> 1.0"},
      {:json, "~> 1.3"},
      {:hackney, "~> 1.16.0"}
    ]
  end
end
