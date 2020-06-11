defmodule WorldTemp.MixProject do
  use Mix.Project

  def project do
    [
      app: :world_temp,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WorldTemp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2.0"},
      {:httpoison, "~> 1.7.0"},
      {:broadway, "~> 0.6.0"}
    ]
  end
end
