local module = {}

local Http = game:GetService("HttpService")

local HTTP_MS = {
	Average = 0,
	Times = 0
}
local Cache = {}
local FailedRequests = {}
local SuccessfulRequests = {}

function module.ClearCache()
	Cache = {}
end

function module.GetMS()
	return HTTP_MS.Average
end

function module.GetRequests()
	return HTTP_MS.Times
end

function module.GetCached()
	return Cache
end

function module.GetFailedRequests()
	return FailedRequests
end

function module.GetSuccessfulRequests()
	return SuccessfulRequests
end

function module.GET(Executer, Url, Headers, Body)
	local CurrentTime = workspace.DistributedGameTime
	local Start = tick()
	if not Headers then Headers = {} end
	if not Body then Body = {} end
	local Request = Http:RequestAsync({
		Url = Url,
		Method = "GET",
		Headers = Headers,
		Body = Body
	})
	local End = tick()
	local Delta = math.abs(Start-End)
	HTTP_MS.Times = HTTP_MS.Times + 1
	HTTP_MS.Average = (HTTP_MS.Average + Delta) / HTTP_MS.Times
	if Request.Success then
		table.insert(SuccessfulRequests,{Owner = Executer,Url = Url,Headers = Headers,Body = Body,Responce = Request.Body,Method = "GET", TimeToMakeRequest = tostring(Delta).." seconds"})
	else
		table.insert(FailedRequests,{Owner = Executer,Url = Url,Headers = Headers,Body = Body,Responce = Request.Body,Method = "GET"})
	end
	return Request.Body
end

function module.POST(Executer, Url, Headers, Body)
	local CurrentTime = workspace.DistributedGameTime
	local Start = tick()
	if not Headers then Headers = {} end
	if not Body then Body = {} end
	local Request = Http:RequestAsync({
		Url = Url,
		Method = "POST",
		Headers = Headers,
		Body = Body
	})
	local End = tick()
	local Delta = math.abs(Start-End)
	HTTP_MS.Times = HTTP_MS.Times + 1
	HTTP_MS.Average = (HTTP_MS.Average + Delta) / HTTP_MS.Times
	if Request.Success then
		table.insert(SuccessfulRequests,{Owner = Executer,Url = Url,Headers = Headers,Body = Body,Responce = Request.Body,Method = "POST", TimeToMakeRequest = tostring(Delta).." seconds"})
	else
		table.insert(FailedRequests,{Owner = Executer,Url = Url,Headers = Headers,Body = Body,Responce = Request.Body,Method = "POST"})
	end
	return Request.Body
end

function module.JSONDecode(...)
	return Http:JSONDecode(...)
end

function module.JSONEncode(...)
	return Http:JSONEncode(...)
end

function module.UrlEncode(...)
	return Http:UrlEncode(...)
end

return module