defmodule Optimus.MixProject do
  use Mix.Project

  def project do
    [
      app: :optimus,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/optimus.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:hackney, "~> 1.18"},
      {:jason, "~> 1.4"},
      {:decimal, "~> 1.0 or ~> 2.0"},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
