defmodule Gcal.MixProject do
  use Mix.Project

  def project do
    [
      app: :gcal,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      elixir: "~> 1.14",
      package: package(),
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "1.0.3"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      t: ["test"],
      c: ["coveralls.html"]
    ]
  end

  defp description() do
    "The easy way to interact with Google Calendar from your Elixir Apps"
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # HTTP request lib: github.com/edgurgel/httpoison
      {:httpoison, "~> 2.0"},

      # Datetime transformation: github.com/bitwalker/timex
      {:timex, "~> 3.0"},

      # Useful functions: github.com/dwyl/useful
      {:useful, "~> 1.14.0"},

      # Create docs on localhost by running "mix docs"
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},

      # Track test coverage: github.com/parroty/excoveralls
      {:excoveralls, "~> 0.15", only: [:test, :dev]},

      # Environment Variables for testing
      {:envar, "~> 1.1.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      files: ["lib/gcal.ex", "lib/httpoison_mock.ex", "mix.exs", "mix.lock", "README.md"],
      name: "gcal",
      licenses: ["GPL-2.0-or-later"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/gcal"}
    ]
  end
end
