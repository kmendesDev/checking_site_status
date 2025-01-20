defmodule GiveUrls.HttpClientBehaviour do
    @callback get(String.t()) :: {:ok, %HTTPoison.Response{}} | {:error, %HTTPoison.Error{}}
  end
  