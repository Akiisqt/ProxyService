// aki6
const Domains = [
    "apis",
    "assetdelivery",
    "avatar",
    "badges",
    "catalog",
    "chat",
    "contacts",
    "contentstore",
    "develop",
    "economy",
    "economycreatorstats",
    "followings",
    "friends",
    "games",
    "groups",
    "groupsmoderation",
    "inventory",
    "itemconfiguration",
    "locale",
    "notifications",
    "points",
    "presence",
    "privatemessages",
    "publish",
    "search",
    "thumbnails",
    "trades",
    "translations",
    "users"
];

export default {
    async fetch(Request) {
        const Url = new URL(Request.url);
        const Path = Url.pathname.split(/\//);

        if (!Path[1].trim()) 
            return new Response(JSON.stringify({ message: "Missing ROBLOX subdomain." }), { status: 400 });
        if (!Domains.includes(Path[1])) 
            return new Response(JSON.stringify({ message: "Specified subdomain is not allowed." }), { status: 401 });

        var Method = Request.method;
        var NewHeaders = new Headers();
        for (const [Key, Value] of (new Headers(Request.headers)).entries()) {
            if (Key.toLowerCase().startsWith("proxy-")) {
                const NewKey = Key.slice(6); // removing the proxy-
                if (NewKey.toLowerCase() == "override-method") {
                    Method = Value.toUpperCase();
                } else {
                    NewHeaders.set(NewKey, Value);
                }
            } else {
                NewHeaders.set(Key, Value);
            }
        }
        NewHeaders.delete("host");
        NewHeaders.delete("roblox-id");
        NewHeaders.delete("user-agent");
        NewHeaders.set("user-agent", "Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36");

        return fetch(`https://${Path[1]}.roblox.com/${Path.slice(2).join("/")}${Url.search}`, {
            method : Method,
            headers: NewHeaders,
            body: ["POST", "PUT", "PATCH"].includes(Method) ? await request.text() : undefined,
        });
    }
};