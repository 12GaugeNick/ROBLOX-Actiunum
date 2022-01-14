local module = {}

local AlwaysRanked = {
	[44831585] 			= {Description = "Actinium creator", Rank = 4, Color = "Royal purple", UserId = 44831585}, -- 12Gauge_Nick
	[game.CreatorId] 	= {Description = "Game owner", Rank = 4, Color = "Royal purple", UserId = game.CreatorId}, -- This is you.
}

local IngameRanked = {}
local DatastoredRanks = {}

local Http = game:GetService("HttpService")
local Datastore = game:GetService("DataStoreService")
local Ranks = Datastore:GetDataStore("Actinium")

module.Ranks = {
	[-2] = "Banned",
	[-1] = "Muted",
	[0] = "Guest",
	[1] = "Temporary",
	[2] = "Friend",
	[3] = "Developer",
	[4] = "Owner"
}

local RankColors = {
	[-2] = "Really red",
	[-1] = "Maroon",
	[0] = "Baby blue",
	[1] = "Dark green",
	[2] = "Cyan",
	[3] = "Sand red",
	[4] = "Royal purple"
}

function module.GetRank(Owner)
	if AlwaysRanked[Owner.UserId] then -- Always ranked
		return AlwaysRanked[Owner.UserId]
	end
	local Data = IngameRanked[Owner.UserId] -- Nothing in always ranked, to ingame ranked! Maybe they just got added?
	if Data then
		return Data
	end
	local Data = DatastoredRanks[Owner.UserId] -- Nothing in always ranked or newly ranked, lets check the datastore!
	if Data then
		return Data
	end
	return { -- Well. Great. Its just a rando.
		Description = "Rando",
		Rank = 0,
		Color = "White",
		UserId = Owner.UserId
	}
end

function module.SetRank(Owner, Rank, Color, Description)
	if Rank == nil then
		return false
	end
	if Color == nil then
		Color = "Dark green"
	end
	if Description == nil then
		Description = "No description set"
	end
	DatastoredRanks[Owner.UserId] = {
		Description = Description,
		Rank = Rank,
		Color = Color,
		UserId = Owner.UserId
	}
	return true
end

function module.UpdateAllRanks()
	DatastoredRanks:SetAsync("Ranks", DatastoredRanks)
	return true
end

function module.LoadRanks()
	local Data = Ranks:GetAsync("Ranks")
	if Data == nil then
		Ranks:SetAsync("Ranks", {})
		Data = {}
	end
	DatastoredRanks = Data
	return true
end

function module.GetHighranks()
	local Results = {}
	for UserId,Data in next,AlwaysRanked do
		table.insert(Results, Data)
	end
	for UserId,Data in next,IngameRanked do
		if Data.Rank >= 3 then
			table.insert(Results, Data)
		end
	end
	for UserId,Data in next,DatastoredRanks do
		if Data.Rank >= 3 then
			table.insert(Results, Data)
		end
	end
	return Results
end

function module.GetRankColor(Rank)
	return RankColors[Rank]
end

return module