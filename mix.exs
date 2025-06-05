defmodule Spellrider.MixProject do
  use Mix.Project

  def project do
    [
      app: :spellrider,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      deps: deps(),
      name: "Spellrider",
      description: "TODO: write a proper description",
      docs: docs(),
      package: package(),
      aliases: aliases()
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
      main: readme,
      extras: ["README.md"]
    ]
  end

  def package do
    [
      name: :spellrider,
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/TODO/spellrider"}
    ]
  end

  def aliases do
    [
      check: [
        "compile --warnings-as-errors --force",
        "format --check-formatted",
        "credo",
        "dialyzer"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:deno_rider, "~> 0.2"},
      {:igniter, "~> 0.6", only: [:dev, :test]},
      {:ex_doc, "~> 0.31"},
      {:dialyxir, "~> 1.0"},
      {:credo, "~> 1.7"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
