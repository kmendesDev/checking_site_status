defmodule CheckSiteStatus do
  use GenServer
  require Logger

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
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_string()

    try do
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          Logger.info("[#{timestamp}] O site #{name} (#{url}) está online!")

        {:ok, %HTTPoison.Response{status_code: status_code}} ->
          Logger.warning("[#{timestamp}] O site #{name} (#{url}) respondeu com status #{status_code}, mas pode não estar totalmente acessível.")

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error("[#{timestamp}] Falha ao acessar o site #{name} (#{url}): #{reason}")
      end
    rescue
      exception ->
        Logger.error("[#{timestamp}] Erro inesperado ao verificar o site #{name} (#{url}): #{inspect(exception)}")
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
