defmodule CheckSiteStatus do
  use GenServer
  use HTTPoison.Base

  @check_interval 10_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_check()
    {:ok, state}
  end

  def handle_info(:check_google, state) do
    check_google()
    schedule_check()
    {:noreply, state}
  end

  defp check_google do
    case HTTPoison.get("https://www.google.com") do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.puts("O Google está online!")

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts("O Google respondeu com status #{status_code}, mas pode não estar totalmente acessível.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("Falha ao acessar o Google: #{reason}")
    end
  end

  defp schedule_check do
    Process.send_after(self(), :check_google, @check_interval)
  end
end
