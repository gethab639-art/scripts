warn("[RESONANCE 4.8] Encryptor: старт " .. os.date("%H:%M:%S"))
local K = "RESONANCE-48-OMEGA-CORE-KEY"
local SRC = "https://raw.githubusercontent.com/kz6v/Resources-2.10/main/resonance-v2.10.lua"
local MIR = "https://cdn.jsdelivr.net/gh/kz6v/Resources-2.10@main/resonance-v2.10.lua"
local STUB = [=====[
warn("[RESONANCE 4.8] расшифровка... " .. os.date("%H:%M:%S"))
local K = "RESONANCE-48-OMEGA-CORE-KEY"
local A = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local DV = {}
for i = 1, #A do DV[A:byte(i)] = i - 1 end
local function unb64(s)
local out, n = {}, 0
for i = 1, #s - 3, 4 do
local c1, c2, c3, c4 = s:byte(i, i + 3)
local v1, v2 = DV[c1], DV[c2]
local v3, v4 = c3 and DV[c3], c4 and DV[c4]
if v1 and v2 then
n = n + 1
out[n] = string.char((v1 * 4 + math.floor(v2 / 16)) % 256)
if v3 then
n = n + 1
out[n] = string.char((v2 * 16 + math.floor(v3 / 4)) % 256)
if v4 then
n = n + 1
out[n] = string.char((v3 * 64 + v4) % 256)
end
end
end
end
return table.concat(out)
end
local function xorb(s)
local out, n, kl = {}, 0, #K
for i = 1, #s do
n = n + 1
out[n] = string.char(s:byte(i) ~ K:byte((i - 1) % kl + 1))
end
return table.concat(out)
end
]=====]
local TAIL = [=====[
]]
local okd, raw = pcall(unb64, C)
assert(okd and raw and #raw == 846836, "[RESONANCE 4.8] расшифровка не удалась")
raw = xorb(raw)
assert(raw:sub(1, 30) == "local RESONANCE_RUNTIME_SOURCE",
"[RESONANCE 4.8] контроль целостности не пройден")
local ok, err = pcall(loadstring(raw))
if not ok then
error("[RESONANCE 4.8] ошибка запуска: " .. tostring(err))
end
]=====]
local A = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64(s)
local out = {}
for i = 1, #s, 3 do
local c1 = s:byte(i)
local c2 = s:byte(i + 1) or 0
local c3 = s:byte(i + 2) or 0
local v = c1 * 65536 + c2 * 256 + c3
out[#out + 1] = A:sub(math.floor(v / 262144) + 1, math.floor(v / 262144) + 1)
out[#out + 1] = A:sub(math.floor(v / 4096) % 64 + 1, math.floor(v / 4096) % 64 + 1)
out[#out + 1] = A:sub(math.floor(v / 64) % 64 + 1, math.floor(v / 64) % 64 + 1)
out[#out + 1] = A:sub(v % 64 + 1, v % 64 + 1)
end
local rem = #s % 3
if rem == 1 then
out[#out] = out[#out]:sub(1, 2) .. "=="
elseif rem == 2 then
out[#out] = out[#out]:sub(1, 3) .. "="
end
return table.concat(out)
end
local function xorb(s)
local out = {}
for i = 1, #s do
out[i] = string.char(s:byte(i) ~ K:byte((i - 1) % #K + 1))
end
return table.concat(out)
end
local function dl()
local body
local ok = pcall(function() body = game:HttpGet(SRC) end)
if not (ok and type(body) == "string") then
ok = pcall(function() body = game:HttpGet(MIR) end)
end
assert(ok and type(body) == "string" and #body > 500000,
"[RESONANCE 4.8] источник недоступен (и зеркало тоже): " .. SRC)
return body
end
local raw = dl()
assert(#raw == 846836, "[RESONANCE 4.8] неожиданный размер источника: " .. #raw)
assert(raw:sub(1, 30) == "local RESONANCE_RUNTIME_SOURCE",
"[RESONANCE 4.8] это не Resonance v2.10 — стоп")
warn("[RESONANCE 4.8] XOR+Base64 над " .. #raw .. " байт, подожди...")
local body = STUB .. "\nlocal C = [[\n" .. b64(xorb(raw)) .. "\n" .. TAIL .. "\n"
local wok = pcall(function() writefile("resonance48_encrypted.lua", body) end)
assert(wok, "[RESONANCE 4.8] writefile недоступен — исполнителю нужен доступ к файлам")
warn("[RESONANCE 4.8] ГОТОВО: resonance48_encrypted.lua = " .. #body .. " символов")
warn("[RESONANCE 4.8] теперь загрузи этот файл в свой репозиторий (drag&drop)")