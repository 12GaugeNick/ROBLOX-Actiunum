local module = {}

local Executes = {}

local SourceCodes = require(script.SourceCodes)

local ScriptExecutesFolder = Instance.new("Folder", workspace)
ScriptExecutesFolder.Name = "ScriptExecutesFolder"

local LocalScriptBase = script.LocalScriptBase
local ServerScriptBase = script.ServerScriptBase

function module.NewServerScript(Owner, ToExecute)
	ToExecute = tostring(ToExecute)
	if SourceCodes[ToExecute] then
		ToExecute = SourceCodes[ToExecute]
	end
	local NewScript = ServerScriptBase:Clone()
	NewScript.SourceCode.Value = ToExecute
	NewScript.Disabled = false
	NewScript.Name = "[Actinium 8]"
	NewScript.Parent = ScriptExecutesFolder
	if Owner ~= "Internal" then
		table.insert(Executes,{
			Owner = Owner,
			Type = "Server",
			ToPlayer = "All",
			ToExecute = ToExecute
		})
	end
end

function module.NewLocalScript(Owner, ToPlayer, ToExecute)
	ToExecute = tostring(ToExecute)
	if SourceCodes[ToExecute] then
		ToExecute = SourceCodes[ToExecute]
	end
	local NewScript = ServerScriptBase:Clone()
	NewScript.SourceCode.Value = ToExecute
	NewScript.Disabled = false
	NewScript.Name = "[Actinium 8]"
	NewScript.Parent = ToPlayer.PlayerGui
	if Owner ~= "Internal" then
		table.insert(Executes,{
			Owner = Owner,
			Type = "Server",
			ToPlayer = "All",
			ToExecute = ToExecute
		})
	end
end

function module.GetExecutions()
	return Executes
end

return module