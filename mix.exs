defmodule Spellweaver.MixProject do
  use Mix.Project

  def project do
    [
      app: :spellweaver,
      version: "0.1.3",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      name: "Spellweaver",
      description: "A spellchecker for Elixir, made with Bun and cspell",
      docs: docs(),
      package: package(),
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: [:mix, :igniter],
        ignore_warnings: ".dialyzer_ignore.exs"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end

  def package do
    [
      name: :spellweaver,
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/underjord/spellweaver"}
    ]
  end

  def aliases do
    [
      check: [
        "hex.audit",
        "compile --warnings-as-errors --force",
        "format --check-formatted",
        "credo",
        "deps.unlock --check-unused",
        "spellweaver.check",
        "dialyzer"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bun, "~> 1.0"},
      {:igniter, "~> 0.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
