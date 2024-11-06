defmodule CheckSiteStatus do
  use HTTPoison.Base

  def check_google do
    case HTTPoison.get("https://www.google.com") do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.puts("O Google está online!")

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts("O Google respondeu com status #{status_code}, mas pode não estar totalmente acessível.")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("Falha ao acessar o Google: #{reason}")
    end
  end
end
