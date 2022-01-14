local SourceCode = script.SourceCode.Value; script.SourceCode:Destroy()
local loadstring = require(script.LuaEngine)
local Run,Error = loadstring(SourceCode, getfenv())
Run()