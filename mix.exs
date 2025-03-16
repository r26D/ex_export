defmodule ExExport.MixProject do
  use Mix.Project
  @version "0.8.8"
  def project do
    [
      app: :ex_export,
      version: version(),
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: description(),
      extra_applications: [:logger],
      source_url: "https://github.com/r26d/ex_export",
      docs: [
        source_ref: "v#{version()}",
        main: "readme",
        extras: ["README.md", "LICENSE.md"]
      ]
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Dirk Elmendorf"],
      licenses: ["MIT"],

      links: %{
        "GitHub" => "https://github.com/r26D/ex_export"
      }
    ]
  end

  defp description do
    """
     This library provides an easy way to make barrel files in Elixir.
      A barrel is a way to rollup exports from several modules into a single convenient module.
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  # adding in support to handle the seed
  defp elixirc_paths(:dev), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.2", only: :dev, runtime: false},
      {:ex_unit_notifier, "~> 1.3", only: :test}
    ]
  end

  def version(), do: @version

  defp aliases do
    [
      tag:
        "cmd  git tag -a v#{version()} -m \\'Version #{version()}\\' ;git push origin v#{version()}",
      tags: "cmd git tag --list 'v*'",
      publish: "cmd echo \$HEX_LOCAL_PASSWORD | mix hex.publish --yes",
      prettier: "format \"mix.exs\" \"{lib,test}/**/*.{ex,exs}\""
    ]
  end
end
