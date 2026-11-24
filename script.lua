warn("[RESONANCE 2.10] загрузка... " .. os.date("%H:%M:%S"))
local GH = "https://raw.githubusercontent.com/"
local U1 = GH .. "kz6v/Resources-2.10/main/resonance-v2.10.lua"
local U2 = "https://cdn.jsdelivr.net/gh/kz6v/Resources-2.10@main/resonance-v2.10.lua"
local src
local ok = pcall(function() src = game:HttpGet(U1) end)
if not (ok and type(src) == "string") then
ok = pcall(function() src = game:HttpGet(U2) end)
end
assert(ok and type(src) == "string" and #src == 846836,
"[RESONANCE 2.10] источник недоступен (и зеркало тоже)")
local okc, fn = pcall(loadstring(src))
assert(okc and fn, "[RESONANCE 2.10] запуск не удался: " .. tostring(fn))
warn("[RESONANCE 2.10] запуск... " .. os.date("%H:%M:%S"))
fn()