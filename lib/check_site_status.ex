defmodule CheckSiteStatus do
  use GenServer # Permite a atuação como um OTP
  use HTTPoison.Base

  @check_interval 5_000

  def start_link(_) do # Iniciando o GenServer
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__) # Próprio módulo , mapa vazio no estado inicial e o nome do módulo
  end

  def init(state) do # É chamada quando o GenServer é iniciado
    schedule_check() # Agenda a verificação
    {:ok, state} # Indica que o processo iniciou vazio retornando o state
  end

  def handle_info(:check_google, state) do # Chamada quando o GenServer recebe a mensagem :check_google
    check_google()
    schedule_check()
    {:noreply, state} # O processo não precisa responder a nenhum outro e mantém o estado atual
  end

  defp check_google do
    #          hora utc atual |> converte retirando o id utc |> Remove as frações dos segs   |> Converte para string
    timestamp = DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.truncate(:second) |> NaiveDateTime.to_string()

    case HTTPoison.get("https://www.google.com") do # Requisição get
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.inspect("[#{timestamp}] O Google está online!")

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.inspect("[#{timestamp}] O Google respondeu com status #{status_code}, mas pode não estar totalmente acessível.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect("[#{timestamp}] Falha ao acessar o Google: #{reason}")
    end
  end

  defp schedule_check do
    Process.send_after(self(), :check_google, @check_interval) # Envia a mensagem :check_google para o próprio processo com o intervalo definido.
  end
end
