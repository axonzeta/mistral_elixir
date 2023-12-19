defmodule MistralClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :mistral_client,
      version: "0.1.0",
      elixir: "~> 1.11",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "mistral_client",
      source_url: "https://github.com/axonzeta/mistral_elixir",
      docs: [
	main: "MistralClient"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MistralClient, []},
      applications: [:httpoison, :jason, :logger],
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Mistral API Wrapper written in Elixir.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      exclude_patterns: ["./config/*"],
      links: %{
        "GitHub" => "https://github.com/axonzeta/mistral_elixir"
      },
      maintainers: [
        "rhys101"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:httpoison, "~> 2.0"},
      {:mock, "~> 0.3.6", only: [:test]},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.29.3", only: :dev}
    ]
  end
end
