use `npm create cloudflare`, follow instructions in prompts and answer `yes` to all questiosn

yeah proxy service for roblox, example:
```lua
local Proxy = ProxyService:New("#.worker.dev")
print(Proxy:Get("groups", "v1/groups/1"))
```