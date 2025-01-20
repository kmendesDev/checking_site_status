Mox.defmock(HttpClientMock, for: GiveUrls.HttpClientBehaviour)
Application.put_env(:give_urls, :http_client, HttpClientMock) 

ExUnit.start()  