local module = {}

local Players = game.Players
local Lighting = game.Lighting
local ReplicatedFirst = game.ReplicatedFirst
local ReplicatedStorage = game.ReplicatedStorage
local ServerScriptService = game.ServerScriptService
local StarterGui = game.StarterGui
local StarterPack = game.StarterPack
local AssetService = game:GetService("AssetService")
local BadgeService = game:GetService("BadgeService")
local Debris = game:GetService("Debris")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local GameStats = game:GetService("Stats")
local RunService = game:GetService("RunService")

local HttpService = require(script.Parent.HttpService)
local ExecuteScript = require(script.Parent.ExecuteScript)
local Create = require(script.Parent.Create)

function module.GetAssetIdsForPackage(Id)
	return AssetService:GetAssetIdsForPackage(Id)
end

function module.AwardBadge(Player, id)
	BadgeService:AwardBadge(Player.UserId, id)
	return true
end

function module.GetBadgeInfoAsync(Id)
	return BadgeService:GetBadgeInfoAsync(Id)
end

function module.CheckForBadge(Player, Id)
	return BadgeService:UserHasBadgeAsync(Player, Id)
end

function module.AddDebrisItem(Object, Time)
	Debris:AddItem(Object, Time)
	return true
end

function module.GetFreeDecals(SearchText, PageNum)
	return InsertService:GetFreeDecals(SearchText, PageNum)
end

function module.GetFreeModels(SearchText, PageNum)
	return InsertService:GetFreeModels(SearchText, PageNum)
end

function module.LoadAsset(Id)
	return InsertService:LoadAsset(Id)
end

function module.FindAssetVersion(Id)
	return InsertService:GetLatestAssetVersionAsync(Id)
end

function module.GetDeveloperProducts()
	return MarketplaceService:GetDeveloperProductsAsync()
end

function module.GetProductInfo(Id)
	return MarketplaceService:GetProductInfo(Id)
end

function module.DoesPlayerOwnAsset(Player, Id)
	return MarketplaceService:PlayerOwnsAsset(Player, Id)
end

function module.PurchaseGamepass(Player, Id)
	return MarketplaceService:PromptGamePassPurchase(Player, Id)
end

function module.PurchaseProduct(Player, Id)
	MarketplaceService:PromptProductPurchase(Player, Id)
	return true
end

function module.PurchasePremium(Player)
	MarketplaceService:PromptPremiumPurchase(Player)
	return true
end

function module.GetNetworkReceive()
	return GameStats.DataReceiveKbps
end

function module.GetNetworkSend()
	return GameStats.DataSendKbps
end

function module.GetHeartbeatMS()
	return GameStats.HeartbeatTimeMs
end

function module.GetPhysicsReceive()
	return GameStats.PhysicsReceiveKbps
end

function module.GetPhsyicsSend()
	return GameStats.PhysicsSendKbps
end

function module.GetPhsyicsMS()
	return GameStats.PhysicsStepTimeMs
end
 -- fuck my hand is tired
function module.GetGameMemoryUsage()
	return GameStats:GetTotalMemoryUsageMb()
end

local SoundService = game:GetService("SoundService")
-- AmbientReverb
-- GetListener
-- PlayLocalSound
-- SetListener listenertype tuple
local TeleportService = game:GetService("TeleportService")
-- GetLocalPlayerTeleportData
-- GetTeleportSettings settings
-- ReserverServer placeid
-- SetTeleportGui gui
-- SetTelportSettings string value
-- Teleport placeid player data
-- TeleportPartyAsync placeid players data
-- TeleportToPrivateServer placeid reservedserveraccesscode player
-- r LocalPlayerArrivedFromTeleport loadinggui data
-- r TeleportInitFailed player result errormsg
local TweenService = game:GetService("TweenService")
-- Create
-- GetValue alpha style direction
local UserInputService = game:GetService("UserInputService")
-- AccelerometerEnabled
-- GamepadEnabled
-- GyroscopeEnabled
-- KeyboardEnabled
-- MouseEnabled
-- MouseIconEnabled
-- TouchEnabled
-- VREnabled
-- GamepadSupports gamepadnum gamepadkeycode
-- GetFocusedTextBox
-- GetKeysPressed
-- GetLastInputType
-- GetMouseButtonsPressed
-- IsKeyDown
-- IsMouseButtonPressed
-- e InputBegan input gameprocessevent
-- e InputEnded
-- e JumpRequest
-- e TextBoxFocusReleased
-- e TextBoxFocused

local HapticService = game:GetService("HapticService")
-- GetMotor inputtype motor
-- IsMotorSupported inputtype motor
-- IsVibrationSupported inputtype
-- SetMotor inputtype motor values

function module.Lerp(p1, p2, percent)
	local p1x,p1y,p1z,p1R00,p1R01,p1R02,p1R10,p1R11,p1R12,p1R20,p1R21,p1R22 = p1:components()
	local p2x,p2y,p2z,p2R00,p2R01,p2R02,p2R10,p2R11,p2R12,p2R20,p2R21,p2R22 = p2:components()
	return 
		CFrame.new(p1x+percent*(p2x-p1x), p1y+percent*(p2y-p1y) ,p1z+percent*(p2z-p1z),
			(p1R00+percent*(p2R00-p1R00)), (p1R01+percent*(p2R01-p1R01)) ,(p1R02+percent*(p2R02-p1R02)),
			(p1R10+percent*(p2R10-p1R10)), (p1R11+percent*(p2R11-p1R11)) , (p1R12+percent*(p2R12-p1R12)),
			(p1R20+percent*(p2R20-p1R20)), (p1R21+percent*(p2R21-p1R21)) ,(p1R22+percent*(p2R22-p1R22)))
end

function module.GetPlayerImage(PlayerName)
	return 'http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username='..tostring(PlayerName) 
end

function module.GetMessageSplit(Message)
	local Table = {}
	for c in Message:gmatch('([^/]+)') do
		c[#Table + 1] = c
	end
	return Table
end

function module.GetPlayers(plr, msg)
	local Table = {}
	msg = msg:lower()
	if msg == 'me' or msg == '' then
		table.insert(Table,plr)
	elseif msg == 'others' then
		for i,v in pairs(game.Players:GetPlayers()) do
			if v.userId ~= plr.userId then
				table.insert(Table,v)
			end
		end
	elseif msg == 'all' then
		for i,v in pairs(game.Players:GetPlayers()) do
			table.insert(Table,v)
		end
	else
		for i,v in pairs(game.Players:GetPlayers()) do
			if v.Name:lower():sub(1,5):find(msg:lower()) then
				table.insert(Table,v)
			end
		end
	end
	return Table
end

function module.CreateTablet(Table)
	--[[
		{
			Text = "djsidj",
			Player = Player,
			Color = BrickColor,
			Function = Function,
			Time = 5
		}
	]]
	local Connections = {}
	local UI_Frames = {}
	local UI_Faces = {"Back","Bottom","Front","Left","Right","Top"}
	local Part_Faces = {"BackSurface","BottomSurface","FrontSurface","LeftSurface","RightSurface","TopSurface"}
	if not Table.Text then 
		Table.Text = "" 
	end
	if not Table.Time then
		Table.Time = 5
	end
	if type(Table.Color) == "string" then
		if Table.Color ~= "Random" then
			Table.Color = BrickColor.new(Table.Color)
		else
			Table.Color = BrickColor.Random()
		end
	end
	local Tab = Create"Part"{
		Name=tostring(Table.Player)..":Tablet"
		,Parent=workspace
		,CFrame=CFrame.new(workspace:WaitForChild(Table.Player.Name):WaitForChild("Head").CFrame.p)*CFrame.new(0,3,0)
		,BrickColor=(Table).Color
		,Material="Glass"
		,Transparency=0.9
		,Anchored=true
		,CanCollide=false
		,Locked=true
		,FormFactor="Custom"
		,Size=Vector3.new(1,1,1)
	} 
	local Wire = Create"Part"{
		Name="Wire"
		,Parent=Tab
		,CFrame=Tab.CFrame
		,BrickColor=(Table).Color
		,Material="Neon"
		,Transparency=0.9
		,Anchored=true
		,CanCollide=false
		,Locked=true
		,FormFactor="Custom"
		,Size=Vector3.new(.2,.2,.2)
	} 
	local Click = Create"ClickDetector"{
		Parent=Tab,
		MaxActivationDistance=math.huge
	}
	local Sound = Create"Sound"{
		Parent=Tab
		,Volume=.3
		,Pitch=1
	}
	local PointLight = Create"PointLight"{
		Parent=Tab
		,Brightness=1
		,Color=((Table).Color).Color
		,Range=2
	}
	local BillboardGui = Create"BillboardGui"{
		Parent=Tab
		,Size=UDim2.new(3,0,3,0)
		,StudsOffset=Vector3.new(0,0.7,0)
	}  
	local TextLabel = Create"TextLabel"{
		Parent=BillboardGui
		,BackgroundTransparency=1 
		,Size=UDim2.new(1,0,.5,0) 
		,Font="SourceSansBold"
		,FontSize="Size18"
		,Text=Table.Text
		,TextColor3=BrickColor.White().Color
		,TextStrokeColor3=(Table.Color).Color
		,TextStrokeTransparency=0.2
	}
	if Table.Image~=nil then
		local ImageLabel = Create"ImageLabel"{
			Parent=BillboardGui
			,BackgroundTransparency=1
			,Position=UDim2.new(0.3,0,-0.3,0)
			,Size=UDim2.new(0.4,0,0.5,0)
			,Image=Table.Image
		}  
	end 
	for _,v in next,Part_Faces do 
		Tab[v]=10 
	end
	for _,v in next,UI_Faces do 
		local Frames = Create"SurfaceGui"{
			Parent=Tab
			,Face=v
			,Name = "Frame"
		} 
		--[[
		local Frame = Create"Frame"{
			Name="Frame"
			,Parent = Frames
			,BackgroundColor3 = ((Table).Color).Color
			,BackgroundTransparency=.3
			,BorderSizePixel=0
			,Position=UDim2.new(.03,0,.03,0)
			,Size=UDim2.new(.94,0,.94,0)
		} ]]
		local Frame = Create"ImageLabel"{
			Name="Frame"
			,Parent = Frames
			,BackgroundColor3 = (Table.Color).Color
			,BackgroundTransparency = 1
			,BorderSizePixel = 0
			,Position = UDim2.new(.03,0,.03,0)
			,Size = UDim2.new(.94,0,.94,0)
			,Image = "rbxassetid://4904453973"
			,ImageColor3 = (Table.Color).Color
			,ImageTransparency = 0.3
		}
		table.insert(UI_Frames, Frame) 
	end
	local HoverEnter;
	local HoverLeave;
	local MouseClick;
	local ObjectAdded;
	local function DismissTab()
		repeat
			RunService.Heartbeat:wait() 
			Tab.Size=Vector3.new(Tab.Size.X-0.05,Tab.Size.Y-0.05,Tab.Size.Z-0.05)
			Tab.Transparency=Tab.Transparency-.05 
			PointLight.Range=PointLight.Range+.8
			for i,v in next,UI_Frames do 
				if (v~=nil) then 
					v.ImageTransparency = v.ImageTransparency + .02
				end 
			end
		until Tab.Size.X<0.3 Tab:Destroy()
		HoverEnter:Disconnect()
		HoverLeave:Disconnect()
		MouseClick:Disconnect()
		ObjectAdded:Disconnect()
	end 
	HoverEnter = Click.MouseHoverEnter:connect(function(Player_Hover) 
		if(Player_Hover.Name==Table.Player.Name)then 
			Sound.SoundId="rbxassetid://332353919" 
			Sound:Play() 
			for i=1,4 do 
				RunService.Heartbeat:wait()
				Tab.Size=Vector3.new(Tab.Size.X+0.05,Tab.Size.Y+0.05,Tab.Size.Z+0.05) 
				Tab.Transparency = Tab.Transparency - .1
				PointLight.Range = PointLight.Range + .95 
				for i,v in next,UI_Frames do 
					if (v~=nil) then 
						v.ImageTransparency = v.ImageTransparency - .1
					end 
				end 
			end 
		end 
	end) 
	HoverLeave = Click.MouseHoverLeave:connect(function(Player_Hover) 
		if(Player_Hover.Name==Table.Player.Name)then 
			for i=1,4 do 
				RunService.Heartbeat:wait() 
				Tab.Size=Vector3.new(Tab.Size.X-0.05,Tab.Size.Y-0.05,Tab.Size.Z-0.05) 
				Tab.Transparency = Tab.Transparency + .1
				PointLight.Range = PointLight.Range - .95 
				for i,v in next,UI_Frames do 
					if(v~=nil)then 
						v.ImageTransparency=v.ImageTransparency + .1
					end 
				end 
			end
		end 
	end) 
	MouseClick = Click.MouseClick:connect(function(Player_Clicked)
		if(Player_Clicked.Name==Table.Player.Name)then
			Sound.SoundId="rbxassetid://332623133" 
			if(type(Table.Function)=="function")then
				DismissTab()
				local r,e = pcall(function()
					Table.Function()
				end) 
				if not r then 
					warn("[PartModule]: ", e) 
				end
				Sound:Play()
			elseif(Table.Dismissable==true)then 
				DismissTab()
				Sound:Play()
			elseif(Table.Dismissable==false)then 
			end 
		end 
	end) 
	ObjectAdded = Tab.DescendantAdded:connect(function(Obj) 
		if(Obj.ClassName=="StringValue")then 
			if(Obj.Name=="Dismiss")then
				DismissTab() 
			end 
		end 
	end)
	if Table.Time ~= -1 then
		delay(Table.Time, DismissTab)
	end
	return(Tab) 
end

module.PromptPurchaseEvent = MarketplaceService.PromptPurchaseFinished

return module