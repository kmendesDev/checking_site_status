defmodule GiveUrls.Scheduler do
  use GenServer
  alias GiveUrls.SiteStatus

  @check_interval 30_000

  def start_link(sites) do
    GenServer.start_link(__MODULE__, %{sites: sites}, name: __MODULE__)
  end

  def init(state) do
    schedule_checks(state[:sites])
    {:ok, state}
  end

  def handle_info({:check_site, {name, url}}, state) do
    SiteStatus.check_site(name, url)
    schedule_check({name, url})
    {:noreply, state}
  end

  defp schedule_checks(sites) do
    Enum.each(sites, fn site ->
      schedule_check(site)
    end)
  end

  defp schedule_check(site) do
    Process.send_after(self(), {:check_site, site}, @check_interval)
  end
end
