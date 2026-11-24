warn("[RESONANCE 4.8] самопис — загрузка " .. os.date("%H:%M:%S"))
local function dl(u)
local ok, b = pcall(function() return game:HttpGet(u) end)
assert(ok and type(b) == "string" and #b > 1000,
"[RESONANCE 4.8] не скачался: " .. u)
return b
end
local src = dl("https://paste.c-net.org/RemarryBlister")
local ok, err = pcall(loadstring(src))
if not ok then
error("[RESONANCE 4.8] ошибка запуска: " .. tostring(err))
end