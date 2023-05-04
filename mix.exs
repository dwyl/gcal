defmodule Gcal.MixProject do
  use Mix.Project

  def project do
    [
      app: :gcal,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
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

      # create docs on localhost by running "mix docs"
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      # Track test coverage: github.com/parroty/excoveralls
      {:excoveralls, "~> 0.15", only: [:test, :dev]},
    ]
  end

  defp aliases do
    [
      t: ["test"],
      c: ["coveralls.html"]
    ]
  end
end
