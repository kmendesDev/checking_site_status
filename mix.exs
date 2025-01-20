defmodule CheckSiteStatus.MixProject do
  use Mix.Project

  def project do
    [
      app: :urls_supervisor,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GiveUrls.Application, []} # Módulo principal da aplicação
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.2"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
