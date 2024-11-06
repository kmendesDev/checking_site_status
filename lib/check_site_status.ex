defmodule CheckSiteStatus do
  use GenServer

  @check_interval 5_000

  def start_link(sites) do
    GenServer.start_link(__MODULE__, %{sites: sites}, name: __MODULE__)
  end

  def init(state) do
    schedule_checks(state[:sites])
    {:ok, state}
  end

  def handle_info({:check_site, {name, url}}, state) do
    check_site(name, url)
    schedule_check({name, url})
    {:noreply, state}
  end

  defp check_site(name, url) do
    timestamp = DateTime.utc_now()
                |> DateTime.to_naive()
                |> NaiveDateTime.truncate(:second)
                |> NaiveDateTime.to_string()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.inspect("[#{timestamp}] O site #{name} (#{url}) está online!")

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.inspect("[#{timestamp}] O site #{name} (#{url}) respondeu com status #{status_code}, mas pode não estar totalmente acessível.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect("[#{timestamp}] Falha ao acessar o site #{name} (#{url}): #{reason}")
    end
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
