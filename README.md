use `npm create cloudflare`, follow instructions in prompts and answer `yes` to all the questions

yeah proxy service for roblox, example usage:
```lua
local Proxy = ProxyService:New("#.worker.dev")
print(Proxy:Get("groups", "v1/groups/1", true))
```

API:
```
Subdomain.roblox.com
example.roblox.com/Subdirectory

Subdomain : string 
Subdirectory : string
Data : string
ContentType : Enum.HttpContentType
Headers : {} or nil

#:Post(Subdomain, Subdirectory, Data, ContentType, Headers);
#:Put(Subdomain, Subdirectory, Data, ContentType, Headers);
#:Patch(Subdomain, Subdirectory Data, ContentType, Headers);

NoCache : boolean or nil, default true

#:Get(Subdomain, Subdirectory, NoCache, Headers);
#:Delete(Subdomain, Subdirectory, NoCache, Headers);
```
