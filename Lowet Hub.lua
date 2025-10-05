

local games = {
    [1234567890] = "https://raw.githubusercontent.com/RoyRedRedVN/script-own/main/plantbrainrot.lua"
}

local scriptLink = games[game.PlaceId]

if scriptLink then
    
    loadstring(game:HttpGet(scriptLink))()
else
    warn("🚫 Unknow game!")
end