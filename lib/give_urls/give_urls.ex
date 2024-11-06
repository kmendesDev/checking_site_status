defmodule GiveUrls.Application do
  use Application

  def start(_type, _args) do
    sites = [
      {"Google", "https://www.google.com"},
      {"GitHub", "https://www.github.com"},
      {"W3Schools", "https://www.w3schools.com"}
    ]

    children = [
      {CheckSiteStatus, sites}
    ]

    opts = [strategy: :one_for_one, name: GiveUrls.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
