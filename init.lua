--[[
	Author: 12Gauge_Nick
	Date:   1/4/2021
]]

wait()

local InitTick = tick()

local Logs = {}

local Ranks = require(script.Ranks)
local BinaryModule = require(383698663)
local Settings = require(script.Settings)
local Functions = require(script.Functions)
local Services = require(script.Services)
local ExecuteScript = require(script.ExecuteScript)

local CreatorId = game.CreatorId
local GameId = game.GameId
local PlaceId = game.PlaceId
local PlaceVersion = game.PlaceVersion

local Tablets = {}
local Commands = {}

------------------------------
------------------------------
------------------------------

local GetRankData = function(Owner)
	return Ranks.GetRank(Owner)
end

local NewCommand = function(Rank, Cmds, Description, Abuse, Function)
	if Description == nil then
		Description = "No description set"
	end
	table.insert(Commands, {
		Rank = Rank,
		Commands = Cmds,
		Description = Description,
		IsAbusive = Abuse,
		Function = Function
	})
end

local NewTablet = function(Owner, Text, Color, Time, Dismissable, Function, Image)
	if Tablets[Owner] == nil then
		Tablets[Owner] = {}
	end
	local Tablet = Functions.CreateTablet({Player = Owner,Text = Text,Color = Color,Time = Time,Dismissable = Dismissable, Function = Function, Image = Image})
	Tablet.CFrame = Owner.Character:WaitForChild("Head").CFrame * CFrame.new(0,3,0)
	Tablet.Parent = workspace
	table.insert(Tablets[Owner], Tablet)
end

local NotifyHighRanks = function(Text, Color, Time, Dismissable, Function, Image)
	local HighRanks = Ranks.GetHighranks()
	for _,Owner in next,HighRanks do
		Owner = game.Players:GetPlayerByUserId(Owner.UserId)
		NewTablet(Owner, Text, Color, Time, Dismissable, Function, Image)
	end
end

local DismissTablet = function(Object, Owner)
	local New = function(Item)
		local Value = Instance.new("StringValue")
		Value.Name = "Dismiss"
		Value.Parent = Item
	end
	if type(Object) == "string" and Object == "All" then
		if Tablets[Owner] ~= nil then
			local Tablets = Tablets[Owner]
			for _,Tablet in next,Tablets do
				New(Tablet)
			end
		end
	else -- If we pick a specific tab
		New(Object)
	end
end

local OnChatted = function(Player, Message)
	if Message:lower():sub(0,3) == "/e " then
		Message = Message:sub(4)
	end
	local Command = nil
	for _,Data in next,Commands do
		for i,v in next,Data.Commands do
			v = Settings.Prefix..v:lower()..Settings.Suffix
			if Message:lower():sub(0, #v) == v:lower() then
				Command = Data
				Message = Message:sub(#v+1)
			end
		end
	end
	if Command ~= nil then
		local Rank = GetRankData(Player)
		if Rank.Rank >= Command.Rank then
			if Rank.Rank > 4 then
				NotifyHighRanks(Player.Name.." ran a abusive command! "..Message, "Deep orange", 5, true, nil)
			end
			if Message == "" or Message == " " then
				Message = nil
			end
			local r,e = pcall(function()
				Command.Function(Player, Message)
			end)
			if not r or e then
				NewTablet(Player, "An error occured running the command!", "Really red", 10, true)
				NewTablet(Player, tostring(e), "Really red", 10, true)
			end
		end
	end
end

local GetSortedCommands = function(Rank)
	local Cmds = {}
	for i,v in next,Commands do
		if v.Rank <= Rank then
			table.insert(Cmds, v)
		end
	end
	return Cmds
end

local OnEnter = function(Player)
	Player.CharacterAdded:wait();wait()
	NewTablet(Player, "Welcome "..Player.Name..", to "..game.Name.."!", "Royal purple", 15, true)
	NewTablet(Player, "Actinium 8 created by 12Gauge_Nick", "Royal purple", 15, true)
	NewTablet(Player, "Your rank is "..GetRankData(Player).Description, "Royal purple", 15, false)
	NotifyHighRanks(Player.Name.." entered", "Deep orange", 10, true, nil, Functions.GetPlayerImage(Player.Name))
	Player.Chatted:Connect(function(Message)
		OnChatted(Player, Message)
	end)
end

------------------------------
------------------------------
------------------------------

-- Rank 0 Guest

NewCommand(0, {"Dt", "Dismiss"}, "Dismiss your tablets", false, function(Owner, Message)
	DismissTablet("All", Owner)
end)

NewCommand(0, {"Ping", "Msg"}, "Ping message-here", false, function(Owner, Message)
	NewTablet(Owner, Message, "Random", -1, true)
end)

NewCommand(0, {"Cmds", "Commands"}, "Open command list", false, function(Owner, Message)
	local PlayerData = GetRankData(Owner)
	local OpenList;
	OpenList = function()
		NewTablet(Owner, "Your rank is "..PlayerData.Description, PlayerData.Color, 15, true)
		for i = 1,5 do
			NewTablet(Owner, i, PlayerData.Color, 15, true, function()
				DismissTablet("All", Owner)
				for _,v in next,GetSortedCommands(i) do
					local GetRankColor = Ranks.GetRankColor(PlayerData.Rank)
					NewTablet(Owner, v.Commands[1], PlayerData.Color, 15, true, function()
						DismissTablet("All", Owner)
						NewTablet(Owner, tostring("Commands: "..unpack(v.Commands)), GetRankColor, 15, false)
						NewTablet(Owner, tostring("Description: "..v.Description), GetRankColor, 15, false)
						NewTablet(Owner, "IsAbusive: "..tostring(v.IsAbusive), GetRankColor, 15, false)
						NewTablet(Owner, tostring("Rank: "..v.Rank), GetRankColor, 15, false)
						NewTablet(Owner, tostring("Back to list"), "Deep orange", 15, false, function()
							DismissTablet("All", Owner)
							OpenList()
						end)
						NewTablet(Owner, "Dismiss all tablets", "Deep orange", 15, true, function()
							DismissTablet("All", Owner)
						end)
					end)
				end
			end)
		end
	end;
	OpenList()
end)

-- Rank 1 Temporary

-- Rank 2 Friend

-- Rank 3 Developer

NewCommand(3, {"NS", "New server sided script", "S"}, "New server side script", true, function(Owner, Message)
	ExecuteScript.NewServerScript(Owner, Message)
end)

NewCommand(3, {"NLS", "New local script", "L"}, "New local script", true, function(Owner, Message)
	local MessageSplit = Functions.GetMessageSplit(Message)
	if not MessageSplit[1] then
		print'1'
	end
	if not MessageSplit[2] then
		print'2'
	end
	if #MessageSplit > 0 then
		local ToPlayer = Functions.GetPlayers(Owner, MessageSplit[1])
		local ToExecute = MessageSplit[2]
		ExecuteScript.NewLocalScript(Owner, ToPlayer, Message)
	end
end)

NewCommand(3, {"Get", "/G", "Logs"}, "Get data logs, requires arguments", true, function(Owner, Message)
	if Message ~= nil then
		local OpenTable;
		OpenTable = function(Table)
			for i,v in next,Table do
				NewTablet(Owner, i..":"..v, "Random", -1, true)
			end
		end
		-- Arguments here
		if Message:sub(0,3) == "Scr" then
			OpenTable(ExecuteScript.GetExecutions())
		end
		-- End agruments
	else
		NewTablet(Owner, "This command requires arguments!", "Random", 15, true)
		NewTablet(Owner, "Arguments: Scr", "Random", 15, true)
	end
end)


-- Rank 4 Owner

------------------------------
------------------------------
------------------------------

local TabletRotation = 1
Services.RunService.Heartbeat:Connect(function()
	TabletRotation = TabletRotation + .002
	for _,Player in next,Services.Players:GetPlayers() do
		if Tablets[Player] and #Tablets[Player] > 0 then -- We only want to move the tablets that actually exist
			local Tabs = Tablets[Player]
			if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then
				local CenterSpace = Player.Character.HumanoidRootPart.CFrame
				for TabletNumber,Tablet in next,Tabs do
					if Tablet.Parent ~= nil then
						local DistanceFactor = 1 + #Tabs
						local Multiplier = 0
						if #Tabs <= 2 then
							DistanceFactor = 4
							Multiplier = 4.5
						end
						Tablet.CFrame = Functions.Lerp(
							Tablet.CFrame
							,CFrame.new(Player.Character.HumanoidRootPart.CFrame.p)
								*CFrame.Angles(0,math.rad(TabletNumber*(360/#Tabs))+TabletRotation,0)
								*CFrame.new(DistanceFactor, math.sin(tick())/1.3, 0)
								*CFrame.Angles(math.sin((tick()+TabletNumber)/.7)/2, math.sin((tick()+TabletNumber)/.7)/2, 0)
								*CFrame.Angles(0, math.sin(tick()), 0)
						, .1)
						if #Tabs >= 3 then
							local Wire = Tablet:FindFirstChild("Wire")
							if Wire then
								if Tabs[TabletNumber+1] ~= nil then
									local DistanceToNextTablet = (Tablet.Position - Tabs[TabletNumber+1].Position).magnitude
									Tablet.Wire.Size = Vector3.new(0,DistanceToNextTablet,0)
									Tablet.Wire.Transparency=.3
									Tablet.Wire.CFrame = CFrame.new(Tablet.Position, Tabs[TabletNumber+1].Position)
										*CFrame.new(0,0,-DistanceToNextTablet/2)
										*CFrame.Angles(math.pi/2,0,0)
								elseif Tabs[TabletNumber] ~= nil then
									local dist = (Tablet.Position - Tabs[1].Position).magnitude
									Tablet.Wire.Size = Vector3.new(0,dist,0)
									Tablet.Wire.Transparency=.3
									Tablet.Wire.CFrame = CFrame.new(Tablet.Position, Tabs[1].Position)
										*CFrame.new(0,0,-dist/2)
										*CFrame.Angles(math.pi/2,0,0)
								end
							end
						else
							local Wire = Tablet:FindFirstChild("Wire")
							if Wire then
								Wire.Transparency = 1
							end
						end
					else
						table.remove(Tablets[Player], TabletNumber)
					end
				end
			end
		end
	end
end)

------------------------------
------------------------------
------------------------------



------------------------------
------------------------------
------------------------------

Services.Players.PlayerRemoving:Connect(function(Player)
	DismissTablet("All", Player)
	Tablets[Player] = {}
end)

Services.Players.PlayerAdded:Connect(OnEnter)

for _,Player in next,Services.Players:GetPlayers() do
	OnEnter(Player)
end

Ranks.LoadRanks()
NotifyHighRanks("Database updated!", "Lime green", 5, true, nil, "rbxassetid://817446315")