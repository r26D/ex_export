defmodule ExExport.MixProject do
  use Mix.Project
  @version "0.1.0"
  def project do
    [
      app: :ex_export,
      version: @version,
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: description(),
      docs: [
        source_ref: "v#{@version}",
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
      The barrel itself is a module file that re-exports selected exports of other modules.
      Source: Barasat Gitbooks
       https://basarat.gitbook.io/typescript/main-1/barrel
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0.2", only: :dev, runtime: false},
      {:ex_unit_notifier, "~> 0.1", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases do
    [
      tag:
        "cmd git tag -a v#{@version} -m 'Version #{@version}';cmd git push origin v#{@version}",
      prettier: "format \"mix.exs\" \"{lib,test}/**/*.{ex,exs}\""
    ]
  end
end
