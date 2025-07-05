--[[

      .o.       oooo    oooo ooooo 
     .888.      `888   .8P'  `888' 
    .8"888.      888  d8'     888  
   .8' `888.     88888[       888  
  .88ooo8888.    888`88b.     888  
 .8'     `888.   888  `88b.   888  
o88o     o8888o o888o  o888o o888o 

		- aki6
]]
local HttpService = game:GetService("HttpService");

local ProxyService = {};

local POST_METHODS = {'POST', 'PUT', 'PATCH'};
local GET_METHODS = {'GET', 'DELETE'};

type PostMethod = (self : ProxyService, Subdomain : string, Subdirectory : string, Data : string, ContentType : Enum.HttpContentType, Headers : { [string] : string }? ) -> unknown;
type GetMethod = (self : ProxyService, Subdomain : string, Subdirectory : string, Data : string, ContentType : Enum.HttpContentType, Headers : { [string] : string }? ) -> unknown;
export type ProxyService = {
	New : ( Root : string ) -> ProxyService,
	Root : string,

	-- Post-based methods
	Post: PostMethod,
	Put: PostMethod,
	Patch: PostMethod,

	-- Get-based methods
	Get: GetMethod,
	Delete: GetMethod,
};

function ProxyService:New(Root : string)
	self.Root = string.format("https://%s/", Root);

	return self;
end

local ProcessHeaders = function(Method, Headers) : {}
	local Temp = {};

	for Index, Value in Headers do
		Temp["proxy-" .. Index] = Value;
	end
	
	if Method ~= "Get" and Method ~= "Post" then
		Temp["proxy-override-method"] = Method;
	end
	return Temp;
end

local ProcessBody = function(Body)
	return HttpService:JSONDecode(Body);
end

local HandlePost = function(Method)
	return function (self, Path : string, Data : string, ContentType : Enum.HttpContentType, Headers : {}?)
		Headers = ProcessHeaders(Method, Headers == nil and {} or Headers);
		local Body = HttpService:PostAsync(self.Root .. Path, Data, ContentType, false, Headers);

		return ProcessBody(Body);
	end
end

local HandleGet = function(Method)
	return function (self, Path : string, NoCache : boolean?, Headers : {}?)
		Headers = ProcessHeaders(Method, Headers or {});
		local Body = HttpService:GetAsync(self.Root .. Path, NoCache == nil and true or NoCache, Headers);

		return ProcessBody(Body);
	end
end

local ProcessPath = function(Callback)
	return function(self, Subdomain : string, Subdirectory : string, ...)
		return Callback(self, string.format("%s/%s", Subdomain, Subdirectory), ...);
	end
end

for _, Method : string in POST_METHODS do
	local Name = Method:sub(1,1):upper() .. Method:sub(2):lower();
	ProxyService[Name] = ProcessPath(HandlePost(Method));
end
for _, Method : string in GET_METHODS do
	local Name = Method:sub(1,1):upper() .. Method:sub(2):lower();
	ProxyService[Name] = ProcessPath(HandleGet(Method));
end

return ProxyService;
