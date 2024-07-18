defmodule ExRock.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/Vonmo/ex_rock"
  @changelog_url "https://github.com/Vonmo/ex_rockblob/develop/CHANGELOG.md"

  def project do
    [
      app: :ex_rock,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "RocksDB wrapper for Elixir (based on Rust driver)",
      source_ref: @version,
      source_url: @source_url,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  defp elixirc_paths(:test),
    do: [
      "lib",
      "test/support",
      "test/factory"
    ]

  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchee, "~> 1.3", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.34.0", only: :dev, runtime: false},
      {:elixir_uuid, "~> 1.2", only: [:test, :dev]},
      {:perftest, git: "https://github.com/Vonmo/perftest.git", branch: "master", only: [:test]},
      {:rustler, "~> 0.34.0", optional: true},
      {:rustler_precompiled, "~> 0.7.1"}
    ]
  end

  defp package do
    [
      maintainers: ["Maxim Molchanov <m.molchanov@vonmo.com>"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url, "Changelog" => @changelog_url},
      files: [
        "lib",
        "native/rocker/.cargo",
        "native/rocker/src",
        "native/rocker/Cargo*",
        "checksum-*.exs",
        ".formatter.exs",
        "mix.exs",
        "README*",
        "LICENSE*",
        "CHANGELOG*"
      ]
    ]
  end

  defp docs do
    [
      main: "ex_rock",
      extras: ["README.md"]
    ]
  end
end
