defmodule Convertat.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :convertat,
      version: @version,
      name: "Convertat",
      source_url: "https://github.com/whatyouhide/convertat",
      elixir: "~> 1.0",
      deps: deps,
      package: package,
      description: description
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    Provides functions for converting from and to arbitrary bases.
    """
  end

  defp package do
    [
      contributors: ["Andrea Leopardi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/whatyouhide/convertat"},
    ]
  end

  defp deps do
    [{:ex_doc, "~> 0.6", only: :dev}]
  end
end
