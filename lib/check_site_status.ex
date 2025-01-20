defmodule CheckSiteStatus do
    alias GiveUrls.SiteStatus
  
    defdelegate check_site(name,url), to: SiteStatus
end
