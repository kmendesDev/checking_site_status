defmodule GiveUrls.SiteStatus do
    require Logger
    
    def check_site(name, url) do
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
  
      case http_client().get(url) do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          Logger.info("[#{timestamp}] O site #{name} (#{url}) está online!")
  
        {:ok, %HTTPoison.Response{status_code: status_code}} ->
          Logger.warning("[#{timestamp}] O site #{name} (#{url}) respondeu com status #{status_code}, mas pode não estar totalmente acessível.")
  
        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error("[#{timestamp}] Falha ao acessar o site #{name} (#{url}): #{reason}")
      end
    end
    defp http_client() do
        Application.get_env(:iris, :http_client, Iris.Matches.HttpClient)
      end
  end
  