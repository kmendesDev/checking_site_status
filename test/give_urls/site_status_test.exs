defmodule GiveUrls.SiteStatusTest do
    use ExUnit.Case, async: true
    
    import Mox
    
    alias GiveUrls.SiteStatus
    
    setup :verify_on_exit!
  
    setup do
      Application.put_env(:iris, :http_client, HttpClientMock)
      :ok
    end

    test "check_site registra que o site está online" do
        HttpClientMock
        |> Mox.expect(:get, fn _url ->
          {:ok, %HTTPoison.Response{status_code: 200}}
        end)
      
        assert SiteStatus.check_site("google", "www.google.com") == 
                 :ok
    end
      
  end
  