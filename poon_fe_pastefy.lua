--!nocheck
--[[
MacLib by biggaboy212 / Proton Utilities - https://github.com/biggaboy212/Maclib - MIT License
Copyright (c) 2024 Proton Utilities
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of
the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
IBM Plex fonts (downloaded at runtime): SIL Open Font License 1.1
]]
local HUB_NAME = "DUKE HUB"

local DATA_DIR = "DukeHub/PoonFE"
pcall(function()
if not (isfolder and makefolder) then return end
for _, dir in ipairs({"DukeHub", DATA_DIR, DATA_DIR .. "/settings"}) do
if not isfolder(dir) then makefolder(dir) end
end
end)

pcall(function()
if not (isfolder and isfile and readfile and writefile) then return end
for _, old in ipairs({"DukeHub/LineagePiece", "BlackchinHub"}) do
if isfolder(old) then
for _, f in ipairs({"lang.txt", "vfx_original.json", "settings/LineagePiece.json"}) do
if isfile(old .. "/" .. f) and not isfile(DATA_DIR .. "/" .. f) then writefile(DATA_DIR .. "/" .. f, readfile(old .. "/" .. f)) end
end
end
end
end)
local LANG = "th"
pcall(function()
if isfile and isfile(DATA_DIR .. "/lang.txt") and readfile(DATA_DIR .. "/lang.txt") == "en" then LANG = "en" end
end)
local function L(th, en) return LANG == "en" and en or th end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local LogService = game:GetService("LogService")
local VERSION = "2.6.23"
local GAME_ID = 9382839773
if game.GameId ~= GAME_ID then
pcall(function()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = HUB_NAME, Text = "สคริปต์นี้รองรับเฉพาะ Lineage Piece", Duration = 6})
end)
return
end
if not game:IsLoaded() then game.Loaded:Wait() end
local player = Players.LocalPlayer
local env = type(getgenv) == "function" and getgenv() or _G
if env.__LineageBooting and os.clock() - env.__LineageBooting < 90 then
return
end
env.__LineageBooting = os.clock()
if env.LineageHubInstance and type(env.LineageHubInstance.Destroy) == "function" then
pcall(env.LineageHubInstance.Destroy)
end
if env.LineageAdvantage and type(env.LineageAdvantage.Destroy) == "function" then
pcall(env.LineageAdvantage.Destroy)
end
local trash = {}
local function track(x)
table.insert(trash, x)
return x
end
local function new(cls, props, parent)
local obj = Instance.new(cls)
for k, v in pairs(props or {}) do obj[k] = v end
if parent then obj.Parent = parent end
return obj
end
local RL = {}
do
local DIR = DATA_DIR
local CUR = DIR .. "/report.dat"
local PREV = DIR .. "/report.prev.dat"
local MAX_BYTES = 1500000
local MAX_LINE = 2000
local canFile = type(writefile) == "function" and type(appendfile) == "function" and type(readfile) == "function" and type(isfile) == "function"
local bxor, lrot = bit32.bxor, bit32.lrotate
local KM = {254, 209, 123, 161, 8, 137, 159, 4, 218, 12, 227, 113, 156, 206, 225, 145, 76, 206, 13, 19, 191, 56, 33, 26, 76, 226, 96, 94, 224, 103, 44, 232}
local KX = {216, 129, 143, 142, 87, 41, 223, 41, 199, 240, 152, 93, 105, 130, 226, 127, 148, 238, 173, 131, 160, 74, 165, 168, 31, 224, 138, 184, 73, 195, 179, 240}
local function word(bytes, i)
return bytes[i] + bytes[i + 1] * 256 + bytes[i + 2] * 65536 + bytes[i + 3] * 16777216
end
local K = {}
do
local kb = {}
for i = 1, 32 do kb[i] = bxor(KM[i], KX[i]) end
for i = 0, 7 do K[i + 1] = word(kb, i * 4 + 1) end
end
local nonceBytes = {}
do
local guid = HttpService:GenerateGUID(false):gsub("-", "")
for i = 1, 12 do nonceBytes[i] = tonumber(guid:sub(i * 2 - 1, i * 2), 16) end
end
local N = {word(nonceBytes, 1), word(nonceBytes, 5), word(nonceBytes, 9)}
local function qr(x, a, b, c, d)
x[a] = (x[a] + x[b]) % 4294967296; x[d] = lrot(bxor(x[d], x[a]), 16)
x[c] = (x[c] + x[d]) % 4294967296; x[b] = lrot(bxor(x[b], x[c]), 12)
x[a] = (x[a] + x[b]) % 4294967296; x[d] = lrot(bxor(x[d], x[a]), 8)
x[c] = (x[c] + x[d]) % 4294967296; x[b] = lrot(bxor(x[b], x[c]), 7)
end
local function keystream(counter)
local s = {0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
K[1], K[2], K[3], K[4], K[5], K[6], K[7], K[8], counter, N[1], N[2], N[3]}
local x = table.clone(s)
for _ = 1, 10 do
qr(x, 1, 5, 9, 13) qr(x, 2, 6, 10, 14) qr(x, 3, 7, 11, 15) qr(x, 4, 8, 12, 16)
qr(x, 1, 6, 11, 16) qr(x, 2, 7, 12, 13) qr(x, 3, 8, 9, 14) qr(x, 4, 5, 10, 15)
end
local out = {}
for i = 1, 16 do
local v = (x[i] + s[i]) % 4294967296
out[#out + 1] = v % 256
out[#out + 1] = math.floor(v / 256) % 256
out[#out + 1] = math.floor(v / 65536) % 256
out[#out + 1] = math.floor(v / 16777216) % 256
end
return out
end
local function crypt(data, counter)
local out = {}
for blockStart = 1, #data, 64 do
local ks = keystream(counter + (blockStart - 1) // 64)
local bytes = {string.byte(data, blockStart, math.min(blockStart + 63, #data))}
for j = 1, #bytes do bytes[j] = bxor(bytes[j], ks[j]) end
out[#out + 1] = string.char(table.unpack(bytes))
end
return table.concat(out)
end
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64(s)
local out = {}
for i = 1, #s, 3 do
local a, b, c = string.byte(s, i, i + 2)
local n = a * 65536 + (b or 0) * 256 + (c or 0)
local c1 = n // 262144 % 64 + 1
local c2 = n // 4096 % 64 + 1
local c3 = n // 64 % 64 + 1
local c4 = n % 64 + 1
out[#out + 1] = B64:sub(c1, c1) .. B64:sub(c2, c2)
.. (b and B64:sub(c3, c3) or "=") .. (c and B64:sub(c4, c4) or "=")
end
return table.concat(out)
end
local recordIndex = 0
local queue = {}
local bytesInFile = 0
local header = "LPR1 " .. b64(string.char(table.unpack(nonceBytes))) .. "\n"
local function encodeRecord(line)
local idx = recordIndex
recordIndex = recordIndex + 1
local prefix = string.char(idx % 256, idx // 256 % 256, idx // 65536 % 256, idx // 16777216 % 256)
return b64(prefix .. crypt(line, idx * 64)) .. "\n"
end
function RL.Write(tag, msg)
local now = DateTime.now()
local line = string.format("[%s.%03d][%s] %s", now:FormatLocalTime("HH:mm:ss", "en-us"), now.UnixTimestampMillis % 1000, tostring(tag), tostring(msg))
if #line > MAX_LINE then line = line:sub(1, MAX_LINE) .. " ...(cut)" end
table.insert(queue, line)
if #queue > 500 then table.remove(queue, 1) end
end
function RL.Flush()
if not canFile or #queue == 0 then return end
local chunk = {}
for i, line in ipairs(queue) do chunk[i] = encodeRecord(line) end
table.clear(queue)
local data = table.concat(chunk)
pcall(function()
if bytesInFile + #data > MAX_BYTES then
if isfile(CUR) then writefile(PREV, readfile(CUR)) end
writefile(CUR, header)
bytesInFile = #header
end
appendfile(CUR, data)
bytesInFile = bytesInFile + #data
end)
end
function RL.Export(snapshotLines)
for _, l in ipairs(snapshotLines or {}) do RL.Write("REPORT", l) end
RL.Flush()
if not canFile then return nil end
local path = DIR .. "/bugreport_" .. os.date("%Y%m%d_%H%M%S") .. ".dat"
local ok = pcall(function()
local body = (isfile(PREV) and readfile(PREV) or "") .. (isfile(CUR) and readfile(CUR) or "")
writefile(path, body)
end)
if not ok then return nil end
if type(setclipboard) == "function" then pcall(setclipboard, path) end
return path
end
if canFile then
pcall(function()
if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(DIR) then makefolder(DIR) end
if isfile(CUR) then bytesInFile = #readfile(CUR) end
appendfile(CUR, header)
bytesInFile = bytesInFile + #header
end)
end
local seen = {}
local seenCount = 0
track(LogService.MessageOut:Connect(function(msg, msgType)
if msgType ~= Enum.MessageType.MessageError and msgType ~= Enum.MessageType.MessageWarning then return end
local key = tostring(msg):sub(1, 200):gsub("%b()", "()"):gsub("%d+", "#")
local n = (seen[key] or 0) + 1
if not seen[key] then
seenCount = seenCount + 1
if seenCount > 2000 then table.clear(seen) seenCount = 1 end
end
seen[key] = n
if n <= 3 or n % 100 == 0 then
RL.Write(msgType == Enum.MessageType.MessageError and "CONSOLE:ERR" or "CONSOLE:WARN", (n > 1 and "(x" .. n .. ") " or "") .. tostring(msg))
end
end))
local flushing = true
task.spawn(function()
while flushing do
task.wait(2)
RL.Flush()
end
end)
track(function() flushing = false RL.Flush() end)
track(player.OnTeleport:Connect(function(teleportState)
if teleportState == Enum.TeleportState.Started then
RL.Write("SESSION", "teleport")
RL.Flush()
end
end))
end
local function logLine(category, msg)
RL.Write(category, msg)
end
local execName = "unknown"
pcall(function() execName = identifyexecutor and tostring((identifyexecutor())) or execName end)
logLine("SESSION", string.format("v=%s place=%d job=%s exec=%s player=%s", VERSION, game.PlaceId, game.JobId, execName, player.Name))
local errCounts, errKeys = {}, 0
local function logError(tag, err)
local key = tag .. "|" .. tostring(err):sub(1, 150):gsub("%b()", "()"):gsub("%d+", "#")
if not errCounts[key] then
errKeys = errKeys + 1
if errKeys > 2000 then table.clear(errCounts); errKeys = 1 end
end
local n = (errCounts[key] or 0) + 1
errCounts[key] = n
if n <= 3 or n % 100 == 0 then
logLine("ERROR:" .. tag, (n > 1 and "(x" .. n .. ") " or "") .. tostring(err))
end
end
local errHandler = function(e) return tostring(e) end
local function safe(tag, fn, ...)
local ok, err = xpcall(fn, errHandler, ...)
if not ok then logError(tag, err) end
return ok, err
end
local consoleWarn = warn
local function warn(...)
local parts = table.pack(...)
for i = 1, parts.n do parts[i] = tostring(parts[i]) end
logError("WARN", table.concat(parts, " ", 1, parts.n))
consoleWarn(...)
end
local W = nil
local function showNotification(title, text, dur)
logLine("NOTIFY", tostring(title) .. " | " .. tostring(text))
if W then
pcall(W.Notify, W, {Title = tostring(title), Description = tostring(text), Lifetime = dur or 3})
return
end
pcall(function()
StarterGui:SetCore("SendNotification", {
Title = title,
Text = text,
Duration = dur or 3
})
end)
end
local Net = nil
pcall(function() Net = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")) end)
local remoteIndex = nil
local function findRemote(prefix, name, class)
if not remoteIndex then
remoteIndex = {}
for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then remoteIndex[desc.Name] = desc end
end
end
local r = remoteIndex[prefix .. name] or remoteIndex[name]
return r and r:IsA(class) and r or nil
end
local function getRE(name) return findRemote("RE/", name, "RemoteEvent") end
local function getRF(name) return findRemote("RF/", name, "RemoteFunction") end
local questRemote         = getRE("QuestEvent")
local questlineRemote     = getRE("QuestlineEvent")
local sellerRF            = getRF("SellerRF")
local sellerEvent         = getRE("SellerEvent")
local settingEvent        = getRE("ChangedSettingEvent")
local teleportRemote      = getRE("TeleportRequest")
local actionRemote        = getRE("ActionRemote")
local portalEvent         = getRE("PortalEvent")
local towerRemote         = getRE("TowerEvent")
local seaRemote           = getRE("SimulatedRE")
local statsRemote         = getRE("StatsAllocateEvent")
local skillEvent          = getRE("SkillRemote")
local toolUiEvent         = getRE("ToolUIEvent")
local bannerEvent         = getRE("BannerEvent")
local summonEvent         = getRE("SummonEvent")

local Rank = {event = getRE("RankEvent"), materialEvent = getRE("MaterialEvent"), data = {}}
local toolConfigs = nil
pcall(function() toolConfigs = ReplicatedStorage.Shared:WaitForChild("ToolsConfig", 5) end)
local questData, islandData, bossesData, portalsData, simulatedData = {}, {}, {}, {}, {}
pcall(function() questData = require(ReplicatedStorage.Shared.Data.Quests) end)
pcall(function() islandData = require(ReplicatedStorage.Shared.Data.Islands) end)
pcall(function() bossesData = require(ReplicatedStorage.Shared.Data.Bosses) end)
pcall(function() portalsData = require(ReplicatedStorage.Shared.Data.Portals) end)
pcall(function() simulatedData = require(ReplicatedStorage.Shared.Data.Simulated_Info) end)
local PROG = {
{100, 1, "Bandit", 1, "Bandit (Lv. 1 - 100)"},
{250, 2, "Bandit Leader", 1, "Bandit Leader (Lv. 101 - 250)"},
{400, 3, "Monkey", 2, "Monkey (Lv. 251 - 400)"},
{600, 4, "Shank", 2, "Shank (Lv. 401 - 600)"},
{800, 8, "Snow Bandit", 3, "Snow Bandit (Lv. 601 - 800)"},
{1000, 7, "Mihawk", 3, "Mihawk (Lv. 801 - 1000)"},
{1300, 9, "National Level Hunter", 4, "National Level Hunter (Lv. 1001 - 1300)"},
{1600, 5, "Sorcerer Student", 5, "Sorcerer Student (Lv. 1301 - 1600)"},
{2000, 6, "Miwa", 5, "Miwa (Lv. 1601 - 2000)"},
{3000, 10, "Hollow", 10, "Hollow (Lv. 2001 - 3000)"},
{4000, 12, "Ichigo ( Bankai )", 10, "Ichigo ( Bankai ) (Lv. 3001 - 4000)"},
{5000, 13, "Mahito", 11, "Mahito (Lv. 4001 - 5000)"},
{5500, 14, "Quincy", 10, "Quincy (Lv. 5001 - 5500)"},
{99999, 15, "Mage", 12, "Mage (Lv. 5501+)"}
}
local ALL_MOBS = {"Bandit", "Bandit Leader", "Monkey", "Shank", "Snow Bandit", "Mihawk", "National Level Hunter", "Sorcerer Student", "Miwa", "Hollow", "Arrancar", "Ichigo ( Bankai )", "Mahito", "Quincy", "Mage", "SoulReaper", "Mimic"}
local BOSSES = {}
for name, data in pairs(bossesData) do
if type(data) == "table" and (data.Type == "Summon" or data.Type == "Time") then
table.insert(BOSSES, name)
end
end
if #BOSSES == 0 then
BOSSES = {"Verdant Hero", "Saber", "Gojo", "Yuji", "Sukuna", "Sung Jinwoo", "Rimuru", "Aizen", "Gilgamesh", "Gojo Shinjuku", "Sukuna Shinjuku", "Kokushibo", "Ulquiorra", "Frieren", "Yuta", "Clone of Monarch"}
end

for _, name in ipairs({"Stone", "Castorice"}) do
if not table.find(BOSSES, name) then table.insert(BOSSES, name) end
end
table.sort(BOSSES)
local DUNGEONS = {}
local DNG_MAP = {}
for id, data in pairs(portalsData) do
if type(data) == "table" and data.Name then
table.insert(DUNGEONS, data.Name)
DNG_MAP[data.Name] = id
end
end
table.sort(DUNGEONS)
if #DUNGEONS == 0 then
DUNGEONS = {"Sovereign Trial", "Abyss Trial", "Jura Forest Trial", "Cid's Castle", "Plane of Euthymia", "Cartenon Temple"}
DNG_MAP = {["Sovereign Trial"]="ARTIFACT_01", ["Abyss Trial"]="ARTIFACT_02", ["Jura Forest Trial"]="ARTIFACT_03", ["Cid's Castle"]="SHADOW", ["Plane of Euthymia"]="RAIDEN", ["Cartenon Temple"]="SUNG"}
end
local ISLANDS = {
{"Dawnwind Village", 1}, {"Deeproot Jungle", 2}, {"Frostborn Island", 3}, {"Scorched Ruins", 4},
{"Jujutsu Highschool", 5}, {"Legend's Arena", 6}, {"Fossil Island", 7}, {"Monument Isle", 8},
{"Lineage Town", 9}, {"Hueco Mundo", 10}, {"Shinjuku Showdown", 11}, {"Elysian Island", 12}
}
local MERCHANT_CATEGORIES = {
{
category = "⚔️ หมวดดาบ & อาวุธ (Swords & Weapons)",
items = {
{name = "Katana (ดาบคาทาน่า)", req = "2,500 Coins", path = {"NPC", "Seller", "KatanaSellNPC"}},
{name = "Dual Katana (ดาบคู่)", req = "30,000 Coins", path = {"NPC", "Seller", "DualKatanaSellNPC"}},
{name = "Gryphon (ดาบกริฟฟอน)", req = "75,000 Coins + 100 Gems", path = {"NPC", "Seller", "GryphonSeller"}},
{name = "Dark Blade / Yoru (ดาบดำ โยรุ)", req = "200,000 Coins + 500 Gems", path = {"NPC", "Seller", "DarkBladeNPC"}},
{name = "Zangetsu (ดาบซันเก็ตสึ)", req = "500,000 Coins + 1,000 Gems", path = {"NPC", "Seller", "ZangetsuSeller"}},
{name = "Excalibur (ดาบเอ็กซ์คาลิเบอร์)", req = "650k Coins + 3.5k Gems + Avalon, Goblet x5", path = {"NPC", "Seller", "SaberNPC"}},
{name = "Excalibur Morgan (เซเบอร์มืด)", req = "20M Coins + 2k Gems + Corrupted Sword, Mud x750", path = {"NPC", "Seller", "SaberAlterNPC"}},
{name = "Player's Dagger (กริชซงจินอู V1)", req = "1M Coins + 7.5k Gems + Knight Killer, Venom Fang", path = {"NPC", "Seller", "SungNPC"}},
{name = "Shadow's Dagger (กริชเงาซงจินอู V2)", req = "Quest 70 + 10M Coins + 10k Gems + Player's Dagger", path = {"NPC", "QuestlineAndSeller", "SungV2"}},
{name = "Stylish Bandit Slayer", req = "Quest 17 + 150,000 Coins + 600 Gems", path = {"NPC", "QuestlineAndSeller", "StylishBanditNPC"}},
{name = "Shadow / Cid (ดาบชาโดว์)", req = "Quest 19 + 7.5M Coins + 15k Gems + Atomic Core x2", path = {"NPC", "QuestlineAndSeller", "ShadowNPC"}},
{name = "Tensa Zangetsu (ดาบเท็นซะ ซันเก็ตสึ)", req = "Quest 34 + 600k Coins + 2,000 Gems + Hollow Mask", path = {"NPC", "QuestlineAndSeller", "TensaSeller"}},
{name = "Raiden (ดาบไรเดน)", req = "Race: Archon + 7.5M Coins + 7.5k Gems + Puppet Core", path = {"NPC", "Seller", "RaidenNPC"}},
{name = "Kokushibo (ดาบโคคุชิโบ)", req = "Race: Demon + 10M Coins + 10k Gems + Nichirin", path = {"NPC", "Seller", "KokuSeller"}},
{name = "Solemn Lament (ปืนคู่ผีเสื้อ)", req = "30M Coins + 45k Gems + Grief, Lament, Fusion Core", path = {"NPC", "Seller", "SolemnSeller"}},
{name = "Vasto Lorde (ดาบวาสโต้ลอร์ด)", req = "30M Coins + 45k Gems + Vasto Lorde Soul x2", path = {"NPC", "Seller", "VastoLordeSeller"}},
{name = "Frieren (คทาเวทมนตร์ฟรีเรน)", req = "Race: Elf + 35M Coins + 25k Gems + Journey Book x2", path = {"NPC", "Seller", "FrierenSeller"}},
{name = "Elysia (ธนูเอลิเซีย)", req = "Race: Pink Elf + Trait: Flawless + 37.5M Coins", path = {"NPC", "Seller", "ElysiaNPC"}},
{name = "Yuta (ดาบยูตะ)", req = "37.5M Coins + 40k Gems + Cursed Katana, Pure Love", path = {"NPC", "Seller", "YutaNPC"}}
}
},
{
category = "🥋 หมวดเควสปลดล็อกตัวละคร & สไตล์ต่อสู้ (Character Styles & Specs)",
items = {
{name = "Deku / Verdant Hero (สไตล์เดกุ)", req = "250,000 Coins + 2,500 Gems + OFA Cell x9", path = {"NPC", "Seller", "DekuNPC"}},
{name = "Sukuna Style (สไตล์สุคุนะ V1)", req = "950k Coins + 6.5k Gems + Sukuna Finger x20", path = {"NPC", "Seller", "SukunaNPC"}},
{name = "Gojo Style (สไตล์โกโจ V1)", req = "850k Coins + 6.5k Gems + Six Eye x2, Infinity x8", path = {"NPC", "Seller", "GojoNPC"}},
{name = "Yuji Style (สไตล์ยูจิ)", req = "1M Coins + 6.5k Gems + Black Flash Spark x3", path = {"NPC", "Seller", "YujiNPC"}},
{name = "Rimuru Style (สไตล์ริมุรุ)", req = "Race: Slime + 5M Coins + 10k Gems + Shizu Mask", path = {"NPC", "Seller", "RimuruSeller"}},
{name = "Gilgamesh Style (สไตล์กิลกาเมช)", req = "Title: King of Heroes + 10M Coins + 10k Gems", path = {"NPC", "Seller", "GilgaNPC"}},
{name = "Gojo Shinjuku (โกโจ ชินจูกุ)", req = "Race: Enlightened + Style: Gojo + 10M Coins", path = {"NPC", "Seller", "GojoShinjukuNPC"}},
{name = "Sukuna Shinjuku (สุคุนะ ชินจูกุ)", req = "Race: Vessel + Style: Sukuna + 10M Coins", path = {"NPC", "Seller", "SukunaShinjukuNPC"}},
{name = "Aizen Style (สไตล์ไอเซ็น)", req = "Race: True Shinigami + 15M Coins + 20k Gems", path = {"NPC", "Seller", "AizenNPC"}},
{name = "Yhwach Style (สไตล์ยูฮาบัคห์)", req = "Race: Quincy + 15M Coins + 15k Gems + Almighty Eye", path = {"NPC", "Seller", "YhwachNPC"}},
{name = "Firefly / SAM (สไตล์หิ่งห้อย)", req = "Race: Glamoth + 27.5M Coins + 30k Gems + Shaper x3", path = {"NPC", "Seller", "FireflyNPC"}},
{name = "Ulquiorra Style (สไตล์อุลคิโอร่า)", req = "30M Coins + 45k Gems + Arrancar Soul x10, Spear", path = {"NPC", "Seller", "UlqNPC"}},
{name = "Naruto Style (สไตล์นารูโตะ)", req = "Race: Jinchuriki + 40M Coins + 30k Gems + Sun Seal x2, Sage Scroll x6, Tailed Beast Fragment x14, Shinobi Badge x30", path = {"NPC", "Seller", "NarutoNPC"}},
{name = "Castorice Style (สไตล์แคสตอริซ)", req = "Race: True Demi God + 40M Coins + 30k Gems + Coreflame Ember x3, Netherwing Bone x6, Soul Thread x10, Asphodel Petal x20, Soul Chrysalis x50", path = {"NPC", "Seller", "CastoriceNPC"}}
}
},
{
category = "⚡ หมวดมาสเตอรี่ & อเวคตัวละคร (Mastery & Awakenings)",
items = {
{name = "Limitless Scroll (อเวคโกโจ ชินจูกุ)", req = "Quest 54 + Style: Gojo Shinjuku + Infinity Core x2", path = {"NPC", "QuestlineAndSeller", "GojoShinjukuMasNPC"}},
{name = "Shrine Scroll (อเวคสุคุนะ ชินจูกุ)", req = "Quest 58 + Style: Sukuna Shinjuku + Slash Core x2", path = {"NPC", "QuestlineAndSeller", "SukunaShinjukuMasNPC"}},
{name = "Inner Hueco Mundo (ปลดโลกฮอลโลว์)", req = "Quest 105 + Hollow's Instinct x35, Vizard Mask x3", path = {"NPC", "QuestlineAndSeller", "InnerHuecoMundo"}},
{name = "Ulquiorra Mastery (อเวคอุลคิโอร่า)", req = "Quest 111 + Empty Heart x1, Resurrection Core", path = {"NPC", "Seller", "UlqMastery"}},
{name = "Yuta Mastery (อเวคยูตะ ก๊อปปี้วิชา)", req = "Quest 172 + Weapon: Yuta + 6 Types of CT x6", path = {"NPC", "QuestlineAndSeller", "YutaMasteryNPC"}},
{name = "Naruto Mastery (อเวคโหมดสัตว์หางสมบูรณ์)", req = "Quest 200 + Style: Naruto + Tailed Orbs 1-9", path = {"NPC", "QuestlineAndSeller", "NarutoMasteryNPC"}}
}
},
{
category = "🧬 หมวดเปลี่ยนเผ่าพิเศษ (Special Race Quests)",
items = {
{name = "Enlightened Race (เผ่าตื่นรู้ / โกโจ)", req = "True Six Eye x2 (ปลดเผ่าโกโจไร้ขีดจำกัด)", path = {"NPC", "Seller", "EnlightenedNPC"}},
{name = "Vessel Race (เผ่าภาชนะ / สุคุนะ)", req = "True Sukuna Finger x20 (ปลดเผ่าภาชนะสุคุนะ)", path = {"NPC", "Seller", "VesselNPC"}},
{name = "Demon Race (เผ่าอสูร / โคคุชิโบ)", req = "Blue Spider Lily x10 (ปลดเผ่าอสูรจันทรา)", path = {"NPC", "Seller", "DemonNPC"}},
{name = "Pink Elf Race (เผ่าเอลฟ์ชมพู / เอลิเซีย)", req = "Quest 177 + Petal Veil x4, Prism Lens x8", path = {"NPC", "QuestlineAndSeller", "PinkElfNPC"}},
{name = "Jinchuriki Race (เผ่าพลังสถิตร่าง 9 หาง)", req = "Quest 193 + Darkness Fragment x2 (ปลดเผ่านารูโตะ)", path = {"NPC", "QuestlineAndSeller", "BeastTailNPC"}},
{name = "True Demi God Race (เผ่ากึ่งเทพแท้ / แคสตอริซ)", req = "Quest 223 + Reason Fragment x30, Crown of Uruk x1 (ต้องเป็นเผ่า Demi God เพื่อเริ่มเควสต์)", path = {"NPC", "QuestlineAndSeller", "TrueDemiGodNPC"}},
{name = "Polyxia (ไป Nether Realm / เควสต์ Soul Chrysalis)", req = "พาไป The Nether Realm (บอส Castorice) · เควสต์ 218 เก็บ Soul Chrysalis x50", path = {"NPC", "Questline", "PolyxiaNPC"}}
}
},
{
category = "🎲 หมวดกาชา, สุ่มสเตตัส, ฮาคิ & พ่อค้าพเนจร (Gacha, Rerolls & Haki)",
items = {
{name = "Travelling Merchant (พ่อค้าพเนจร)", req = "สุ่มขายตั๋ว/แกน/รีโรล (รีสต็อกทุก 20 นาที)", path = {"NPC", "Merchant", "MerchantNPC"}},
{name = "Dreamscape Merchant (พ่อค้ามิติฝัน)", req = "พ่อค้าพิเศษในโลกฝัน Dreamscape (รีสต็อกทุก 20 น.)", path = {"NPC", "Dreamscape", "MerchantNPC"}},
{name = "Gacha Banner (ตู้สุ่มแบนเนอร์ตัวละคร)", req = "ตู้สุ่มตัวละครการันตี (ใช้ Ticket หรือ Gems)", path = {"NPC", "Banner", "BannerNPC"}},
{name = "Random Fruit (สุ่มผลปีศาจ - เหรียญ)", req = "สุ่มผลปีศาจด้วยเงินเหรียญ Coins", path = {"NPC", "Fruit", "RandomFruitNPC"}},
{name = "Random Fruit (สุ่มผลปีศาจ - เพชร)", req = "สุ่มผลปีศาจด้วยเพชร Gems", path = {"NPC", "Fruit", "RandomFruitGemNPC"}},
{name = "Race Reroll NPC (สุ่มเผ่าทั่วไป)", req = "สุ่มเผ่าทั่วไป (Human, Skypiea, Elf, Shinigami)", path = {"NPC", "RaceNPC", "RaceNPC"}},
{name = "Trait Reroll NPC (สุ่มพลังแฝง)", req = "สุ่มพลังแฝง Trait ของตัวละคร", path = {"NPC", "Trait", "TraitNPC"}},
{name = "Stats Potential (สุ่มศักยภาพสเตตัส)", req = "สุ่มค่าศักยภาพสเตตัส Stats Potential", path = {"NPC", "StatsPotential", "StatsRerollNPC"}},
{name = "Buso Haki (ฮาคิเกราะ - Hakibuso)", req = "1,250 Gems + Haki Book x1", path = {"NPC", "Seller", "HakibusoNPC"}},
{name = "Obs Haki (ฮาคิสังเกต)", req = "Quest 40 + 2.5M Coins + Obs Haki Book x1", path = {"NPC", "QuestlineAndSeller", "ObsHakiNPC"}},
{name = "Blacksmith NPC (ช่างตีบวกอาวุธ)", req = "ตีบวกและอัปเกรดความสามารถอาวุธ", path = {"NPC", "Blacksmith", "BlacksmithNPC"}},
{name = "Artifact NPC (ปลดล็อก/ใส่ Artifact)", req = "ปลดล็อก: Lv. 1000 + 250k Coins + 1,000 Gems · ใส่/อัปเกรด Artifact (Scorched Ruins)", path = {"NPC", "Artifact", "ArtifactNPC"}}
}
},
{
category = "🏛️ หมวดร้านค้าแลกเปลี่ยน & คราฟต์ไอเทม (Exchanges & Crafting)",
items = {
{name = "Boss Soul Exchange (แลกของบอส)", req = "แลก Excalibur, Verdant Hero ด้วย Boss's Soul", path = {"NPC", "Exchange", "BossExchangeNPC"}},
{name = "Portal Key Seller (ขายกุญแจดันเจี้ยน)", req = "แลก Trial's Key ด้วย Coins/Gems + Boss Soul", path = {"NPC", "Exchange", "PortalKeySellerNPC"}},
{name = "Book Exchange (แลกเปลี่ยนตำรา)", req = "แลก Slime Orb ด้วย Haki/Sword Book", path = {"NPC", "Exchange", "BookExchangeNPC"}},
{name = "Slime Exchange (แลกของสไลม์ริมุรุ)", req = "แลก Slime Coins ด้วย Mask/Core/Essence", path = {"NPC", "Exchange", "SlimeExchangeNPC"}},
{name = "Holy Grail Shop (จอกศักดิ์สิทธิ์)", req = "แลก Holy Grail ด้วย Golden Dust x5", path = {"NPC", "Exchange", "GrailNPC"}},
{name = "Sam Exchange (ร้านแลกหุ่นแซม)", req = "แลก Dreamscape, Reroll ด้วย Armor Scrap", path = {"NPC", "Exchange", "SamNPC"}},
{name = "Ticket Exchange (ร้านแลกตั๋ว)", req = "แลก Reroll, Cid's Key, Shrine Key ด้วย Ticket", path = {"NPC", "Exchange", "TicketExchangeNPC"}},
{name = "Tower Exchange (ร้านค้าหอคอย)", req = "แลก Shrine Key, Planet Key ด้วย Tower Shard", path = {"NPC", "Tower", "TowerExchangeNPC"}},
{name = "Byte Shop (ร้านค้า Simulated)", req = "แลก Key, Reroll, Reforger ด้วย Byte Points", path = {"NPC", "Simulated", "ByteShopNPC"}},
{name = "Solemn Crafting (แองเจล่าคราฟต์ปืน)", req = "คราฟต์ Coffin, Grief, Lament, Fusion Core", path = {"NPC", "Crafting", "AngelaExchange"}}
}
}
}
local QUESTLINE_GROUPS = {"Boulder", "Carpet", "Crowbar", "MoonBloom", "Orihime", "ReishiCrystal", "RikkaTrace", "Talismans", "Torchs"}

local QUEST_RECIPES = {

["Deku / Verdant Hero"] = {category = "Style", seller = "DekuNPC", materials = {
{item = "One For All's Cell", amount = 9, mob = "Verdant Hero"},
}},
["Sukuna Style"] = {category = "Style", seller = "SukunaNPC", materials = {
{item = "Sukuna's Finger", amount = 20, mob = "Sukuna"},
{item = "Cursed Shard", amount = 15, mob = "Sukuna"},
}},
["Gojo Style"] = {category = "Style", seller = "GojoNPC", materials = {
{item = "Six Eye", amount = 2, mob = "Gojo"},
{item = "Infinity Essence", amount = 8, mob = "Gojo"},
{item = "Cursed Shard", amount = 15, mob = "Gojo"},
}},
["Yuji Style"] = {category = "Style", seller = "YujiNPC", materials = {
{item = "Black Flash Spark", amount = 3, mob = "Yuji"},
{item = "Divergent Energy", amount = 8, mob = "Yuji"},
{item = "Cursed Shard", amount = 25, mob = "Yuji"},
}},
["Rimuru Style"] = {category = "Style", seller = "RimuruSeller", needs = "Race: Slime", materials = {
{item = "Shizu Mask", amount = 1, mob = "Rimuru"},
{item = "Slime Core", amount = 7, mob = "Rimuru"},
{item = "Slime Essence", amount = 10, mob = "Rimuru"},
}},
["Aizen Style"] = {category = "Style", seller = "AizenNPC", needs = "Race: True Shinigami", materials = {
{item = "Hogyoku", amount = 1, mob = "Aizen"},
{item = "Shattered Soul", amount = 5, mob = "Aizen"},
{item = "Formless Mirror", amount = 8, mob = "Aizen"},
{item = "Reishi Core", amount = 20, mob = "Aizen"},
{item = "Void Silk", amount = 25, mob = "Aizen"},
}},
["Gilgamesh"] = {category = "Style", seller = "GilgaNPC", needs = "Title: King of Heroes", materials = {
{item = "Genesis Core", amount = 1, mob = "Gilgamesh"},
{item = "Babylon Fragment", amount = 4, mob = "Gilgamesh"},
{item = "Tyrant Crest", amount = 7, mob = "Gilgamesh"},
{item = "Golden Essence", amount = 20, mob = "Gilgamesh"},
}},
["Gojo Shinjuku Style"] = {category = "Style", seller = "GojoShinjukuNPC", needs = "Race: Enlightened + Style: Gojo", materials = {
{item = "True Six Eye", amount = 1, mob = "Gojo Shinjuku"},
{item = "Infinity Core", amount = 1, mob = "Gojo Shinjuku"},
{item = "Limitless Shard", amount = 5, mob = "Gojo Shinjuku"},
{item = "Cursed Shard", amount = 100, mob = "Gojo"},
}},
["Sukuna Shinjuku Style"] = {category = "Style", seller = "SukunaShinjukuNPC", needs = "Race: Vessel + Style: Sukuna", materials = {
{item = "Slash Core", amount = 1, mob = "Sukuna Shinjuku"},
{item = "Shrine Shard", amount = 5, mob = "Sukuna Shinjuku"},
{item = "True Sukuna Finger", amount = 5, mob = "Sukuna Shinjuku"},
{item = "Cursed Shard", amount = 100, mob = "Sukuna"},
}},
["Ulquiorra Style"] = {category = "Style", seller = "UlqNPC", materials = {
{item = "Cero Spear", amount = 1, mob = "Ulquiorra"},
{item = "Arrancar Soul", amount = 10, mob = "Ulquiorra"},
{item = "Soul of Emptiness", amount = 6, mob = "Ulquiorra"},
{item = "Hueco Mundo Badge", amount = 25, mob = "Ulquiorra"},
}},
["Yhwach Style"] = {category = "Style", seller = "YhwachNPC", needs = "Race: Quincy", materials = {
{item = "Eye of the Almighty", amount = 3, dungeon = "Wandenreich"},
{item = "Quincy Cross", amount = 10, dungeon = "Wandenreich"},
{item = "Angel Halo", amount = 5, dungeon = "Wandenreich"},
{item = "Bomb Core", amount = 5, dungeon = "Wandenreich"},
{item = "Miracle Core", amount = 5, dungeon = "Wandenreich"},
{item = "Poison Vial", amount = 5, dungeon = "Wandenreich"},
{item = "Silver Shield", amount = 5, dungeon = "Wandenreich"},
{item = "Blue Soul", amount = 500, dungeon = "Wandenreich"},
}},
["Firefly Style"] = {category = "Style", seller = "FireflyNPC", needs = "Race: Glamoth", materials = {
{item = "Molten Core", amount = 1, dungeon = "Glamoth Planet"},
{item = "Shaper", amount = 3, dungeon = "Glamoth Planet"},
{item = "Firefly's Will", amount = 6, dungeon = "Glamoth Planet"},
{item = "Ignition Valve", amount = 9, dungeon = "Glamoth Planet"},
{item = "Armor Scrap", amount = 250, dungeon = "Glamoth Planet"},
}},
["Naruto Style"] = {category = "Style", seller = "NarutoNPC", needs = "Race: Jinchuriki", materials = {
{item = "Sun Seal", amount = 2, dungeon = "The Valley of the End"},
{item = "Sage Scroll", amount = 6, dungeon = "The Valley of the End"},
{item = "Tailed Beast Fragment", amount = 14, dungeon = "The Valley of the End"},
{item = "Shinobi Badge", amount = 30, dungeon = "The Valley of the End"},
}},
["Castorice Style"] = {category = "Style", seller = "CastoriceNPC", needs = "Race: True Demi God", materials = {
{item = "Coreflame Ember", amount = 3, mob = "Castorice"},
{item = "Netherwing Bone", amount = 6, mob = "Castorice"},
{item = "Soul Thread", amount = 10, mob = "Castorice"},
{item = "Asphodel Petal", amount = 20, mob = "Castorice"},
{item = "Soul Chrysalis", amount = 50, anyMob = true, quest = 218},
}},

["Sung Jinwoo (Player's Dagger)"] = {category = "Weapon", seller = "SungNPC", materials = {
{item = "Knight Killer", amount = 1, mob = "Sung Jinwoo"},
{item = "Venom Fang", amount = 1, mob = "Sung Jinwoo"},
{item = "Sword Technique Book", amount = 1, mob = "Sung Jinwoo"},
{item = "System Core", amount = 5, mob = "Sung Jinwoo"},
}},
["Sung Jinwoo V2 (Shadow's Dagger)"] = {category = "Weapon", seller = "SungV2", needs = "Quest 70 + Weapon: Player's Dagger", materials = {
{item = "Gate Fragment", amount = 10, mob = "Sung Jinwoo"},
{item = "Core of Shadow", amount = 2, dungeon = "Cartenon Temple"},
{item = "Monarch's Soul", amount = 1, dungeon = "Cartenon Temple"},
}},
["Excalibur (Saber)"] = {category = "Weapon", seller = "SaberNPC", materials = {
{item = "Avalon", amount = 1, mob = "Saber"},
{item = "Goblet", amount = 5, mob = "Saber"},
{item = "Sword Technique Book", amount = 1, mob = "Saber"},
}},
["Tensa Zangetsu"] = {category = "Weapon", seller = "TensaSeller", needs = "Quest 34", materials = {
{item = "Hollow Mask", amount = 1, mob = "Ichigo ( Bankai )"},
}},
["Kokushibo (Koku)"] = {category = "Weapon", seller = "KokuSeller", needs = "Race: Demon", materials = {
{item = "Nichirin blue print", amount = 1, mob = "Kokushibo"},
{item = "Broken Flute", amount = 4, mob = "Kokushibo"},
{item = "Upper One Eye", amount = 6, mob = "Kokushibo"},
}},
["Frieren"] = {category = "Weapon", seller = "FrierenSeller", needs = "Race: Elf", materials = {
{item = "Great Mage's Journey Book", amount = 2, mob = "Frieren"},
{item = "Broken Staff", amount = 5, mob = "Frieren"},
{item = "Mana Stone", amount = 20, mob = "Frieren"},
}},
["Yuta"] = {category = "Weapon", seller = "YutaNPC", materials = {
{item = "Cursed Katana", amount = 1, mob = "Yuta"},
{item = "Ring of Pure Love", amount = 4, mob = "Yuta"},
{item = "Essence of Pure Love", amount = 6, mob = "Yuta"},
{item = "Cursed Spirit Fragment", amount = 15, mob = "Yuta"},
{item = "Cursed Shard", amount = 30, mob = "Gojo"},
{item = "Jujutsu ID Card", amount = 1, how = "เควสต์ของ NPC Jujutsu ID Card"},
}},
["Shadow"] = {category = "Weapon", seller = "ShadowNPC", needs = "Quest 19", materials = {
{item = "Atomic Core", amount = 2, dungeon = "Cid's Castle"},
{item = "Shadow Fragment", amount = 6, dungeon = "Cid's Castle"},
{item = "Shadow Orb", amount = 12, dungeon = "Cid's Castle"},
{item = "Black Slime", amount = 100, dungeon = "Cid's Castle"},
}},
["Raiden"] = {category = "Weapon", seller = "RaidenNPC", needs = "Race: Archon", materials = {
{item = "Electro Vision", amount = 1, dungeon = "Plane of Euthymia"},
{item = "Puppet Core", amount = 2, dungeon = "Plane of Euthymia"},
{item = "Shard of Calamity", amount = 5, dungeon = "Plane of Euthymia"},
{item = "Tear of Eternity", amount = 5, dungeon = "Plane of Euthymia"},
{item = "Celestial Steel", amount = 40, dungeon = "Plane of Euthymia"},
}},
["Excalibur Morgan"] = {category = "Weapon", seller = "SaberAlterNPC", materials = {
{item = "Corrupted Holy Sword", amount = 1, dungeon = "Ryuudo Cave"},
{item = "Dark Mana Core", amount = 3, dungeon = "Ryuudo Cave"},
{item = "Servant Covenant", amount = 5, dungeon = "Ryuudo Cave"},
{item = "Dragon Blood", amount = 10, dungeon = "Ryuudo Cave"},
{item = "Grail Mud", amount = 750, dungeon = "Ryuudo Cave"},
}},
["Solemn Lament"] = {category = "Weapon", seller = "SolemnSeller", materials = {
{item = "Boss's Soul", amount = 250, mob = "Verdant Hero"},
{item = "Grief for the dead", amount = 1, how = "คราฟต์ที่ Angela (Frostborn Island)"},
{item = "Lament for the living", amount = 1, how = "คราฟต์ที่ Angela (Frostborn Island)"},
{item = "Fusion Core", amount = 5, how = "คราฟต์ที่ Angela (Frostborn Island)"},
{item = "Soulweaver Butterfly", amount = 100, dungeon = "The Butterfly Grave"},
}},
["Vasto Lorde"] = {category = "Weapon", seller = "VastoLordeSeller", materials = {
{item = "Vasto Lorde's Soul", amount = 2, how = "Ulquiorra ใน Inner Hueco Mundo (เริ่มเควสต์ที่ Urahara)"},
}},
["Elysia"] = {category = "Weapon", seller = "ElysiaNPC", needs = "Race: Pink Elf + Trait: The Flawless Human", materials = {
{item = "Ego Core", amount = 3, dungeon = "Elysian Realm"},
{item = "Flawless Soul", amount = 12, dungeon = "Elysian Realm"},
{item = "Crystal Flower", amount = 24, dungeon = "Elysian Realm"},
{item = "Realm Badge", amount = 450, dungeon = "Elysian Realm"},
}},

["Enlightened Race"] = {category = "Race", seller = "EnlightenedNPC", materials = {
{item = "True Six Eye", amount = 2, mob = "Gojo Shinjuku"},
}},
["Vessel Race"] = {category = "Race", seller = "VesselNPC", materials = {
{item = "True Sukuna Finger", amount = 20, mob = "Sukuna Shinjuku"},
}},
["Pink Elf Race"] = {category = "Race", seller = "PinkElfNPC", needs = "Quest 177", materials = {
{item = "Petal Veil", amount = 4, mob = "Pink Elf Soul"},
{item = "Prism Lens", amount = 8, mob = "Pink Elf Soul"},
{item = "Fairy Pendant", amount = 18, mob = "Pink Elf Soul"},
}},
["True Demi God Race"] = {category = "Race", seller = "TrueDemiGodNPC", needs = "Race: Demi God (quests 220-223)", materials = {
{item = "Reason Fragment", amount = 30, how = "บอส Hard/Extreme ตัวไหนก็ได้ ระหว่างถือเควสต์ 221 (หน้าบอส → อัญเชิญ Hard/Extreme)"},
{item = "Crown of Uruk", amount = 1, mob = "Gilgamesh", quest = 223, minDiff = "Hard"},
}},
["Jinchuriki Race"] = {category = "Race", seller = "BeastTailNPC", needs = "Quest 193", materials = {
{item = "Darkness Fragment", amount = 2, how = "ชนะ Yourself ที่น้ำตก (หมัดอย่างเดียว 5M HP ใน 5 นาที)"},
}},
["Demon Race"] = {category = "Race", seller = "DemonNPC", materials = {
{item = "Blue Spider Lily", amount = 10, how = "เกิดบนแมพตอนกลางคืน"},
}},

["Goku"] = {category = "Power", seller = "GokuNPC", needs = "Race: Saiyan", materials = {
{item = "Warrior's Spirit", amount = 2, mob = "Goku"},
{item = "Saiyan's Spirit", amount = 3, mob = "Goku"},
{item = "Kaioken Energy", amount = 8, mob = "Goku"},
{item = "Ascension Shard", amount = 15, mob = "Goku"},
{item = "Ki Shard", amount = 30, mob = "Mimic", quest = 209},
}},
}
local QUEST_TARGET_NAMES = {}
for qName, _ in pairs(QUEST_RECIPES) do
table.insert(QUEST_TARGET_NAMES, qName)
end
table.sort(QUEST_TARGET_NAMES)

local ITEM_DROP_MAP = {
["Cursed Shard"] = {mob = "Gojo", isBoss = true, targetQuest = "Gojo Style"},
["Sword Technique Book"] = {mob = "Sung Jinwoo", isBoss = true, targetQuest = "Sung Jinwoo (Player's Dagger)"},
["Slime Orb"] = {mob = "Hollow", targetQuest = "Rank Redstone / Rimuru summon"},
["Golden Dust"] = {mob = "Gilgamesh", isBoss = true, targetQuest = "Holy Grail"},
["Soul-Unweaving Loom"] = {mob = "Castorice", isBoss = true, quest = 227, targetQuest = "Castorice Mastery"},
}
for _, qName in ipairs(QUEST_TARGET_NAMES) do
for _, mat in ipairs(QUEST_RECIPES[qName].materials) do
if mat.mob and not ITEM_DROP_MAP[mat.item] then
ITEM_DROP_MAP[mat.item] = {mob = mat.mob, isBoss = mat.mob ~= "Ichigo ( Bankai )" and mat.mob ~= "Mimic",
quest = mat.quest, minDiff = mat.minDiff, targetQuest = qName}
end
end
end
local SPECIFIC_ITEM_NAMES = {}
for itemName, _ in pairs(ITEM_DROP_MAP) do
table.insert(SPECIFIC_ITEM_NAMES, itemName)
end
table.sort(SPECIFIC_ITEM_NAMES)
local STAT_NAMES = {"Power", "Strength", "Defense", "Weapon"}
local config = {
espPlayer = false, infinityJump = false, speedHack = false, hideVfx = false, lowRamAudio = false,
selectedPvPPlayer = "", autoPvP = false,
autoHaki = true, autoObsHaki = true,
autoChests = false, chestDelay = 7.0, autoSeeds = false,
autoStats = false,
statTargets = {Power = false, Strength = false, Defense = false, Weapon = false},
instantNpcWarp = true,
farmMovement = "Teleport", tweenSpeed = 150, farmHeight = 16,
selectedMonster = "[Auto Level Progression]", autoFarm = false, autoRetreat = true, stopOnDeaths = true,
questSkip = 0,
selectedMonsterNoQuest = ALL_MOBS[1], autoFarmNoQuest = false,
worldBosses = {"[All Spawned Bosses]"}, autoFarmWorldBoss = false,
pitySelectBoss = BOSSES[1], pitySelectPityBoss = BOSSES[2], autoFarmPityBoss = false,
attackInterval = 0.1,
goalTarget = "TensaSeller", autoGoal = false, goalNoBuy = false,
autoNarutoQuest = false,
autoRank = false,
selectedSpecificItem = "Sukuna's Finger",
autoFarmSpecificItem = false,
specificItemTarget = "25",
autoCollectQuestline = false,
autoSummonForItems = false,
itemSummonDifficulty = "Easy",
autoSkill = true,
skillKeys = {Z = true, X = true, C = true, V = true, R = true},
skillInterval = 0.35,
selectedBoss = BOSSES[1], bossDifficulty = "Easy",
autoSummonBoss = false, autoFarmSummonedBoss = false,
autoRollBanner = false,
selectDungeon = DUNGEONS[1], selectDifficulty = "Easy", autoCreateDungeon = false, autoStartDungeon = false,
autoKillAllDungeon = false, autoClearYhwachPillars = false, autoLeaveDungeon = false,
autoStartTower = false, autoKillAllTower = false, autoLeaveTower = false,
selectSeaTier = "1", autoPlaySea = false, autoStartSea = false, autoLeaveSea = false, autoKillMobsSea = false, autoPickBestCard = false, seaDoor = "Combat",
questlineAuto = {Boulder = false, Carpet = false, Crowbar = false, MoonBloom = false, Orihime = false, ReishiCrystal = false, RikkaTrace = false, Talismans = false, Torchs = false},
antiAfk = true,
autoRejoin = true,
autoReexecute = true,
autoHopBoss = false,
discordWebhookUrl = "",
discordNotifyDrop = true,
discordNotifyBoss = true,
discordNotifyLevel = false,
discordNotifyHop = true
}
local state = {
alive = true, lastAttack = 0, lastQuest = 0, lastTeleport = 0, lastHaki = 0,
lastObsHaki = 0, lastESP = 0, lastDungeon = 0, lastTower = 0, lastSea = 0,
lastReroll = 0, currentIsland = 1, activeTween = nil, safeSpot = nil, collectingChests = false,
autoSummonActive = nil, autoSummonPending = false, autoSummonBoss = nil, autoSummonOwned = false, lastSummonSend = 0,
currency = {}, profile = {},
skillCursor = 1, lastSkillAttempt = 0, skillReadyAt = {}, skillRequests = 0, lastSkillUsed = nil,
questlineAttempts = 0, token = 0, effectOriginal = nil,
inventory = {}, lastInventorySync = 0, lastQuestSummon = 0, lastItemSummon = 0,
lastStatusUiUpdate = 0,
lastBossSeenTime = nil, lastHopAttempt = 0,
lastNotifiedLevel = nil, lastLevelCheck = 0, trackingBossModel = nil, inventoryInit = false,
lastPvPWarp = 0, pvpHistory = {}, pvpHistoryIndex = 0, pvpSelectionFromButtons = false,
lastNarutoStart = -math.huge, lastNarutoPickup = -math.huge, lastNarutoMeditate = -math.huge,
narutoNoMobSince = nil, narutoLastProgress = nil, narutoLastProgressAt = 0,
narutoHopPending = false, narutoVisitedServers = {},
rank = nil, rankTask = nil, lastRankSync = 0, lastRankUp = 0, lastRankKeyUse = 0, lastRankPortal = 0,
rankSyncedAt = 0, rankRunEndAt = 0, rankRunActive = false, lastRankSummon = 0,
retreat = nil, avoidTargets = setmetatable({}, {__mode = "k"}), deathTimes = {}
}

Rank.FARM_MODE_FLAGS = {"autoPvP", "autoFarm", "autoFarmNoQuest", "autoFarmWorldBoss", "autoFarmPityBoss", "autoFarmSummonedBoss", "autoFarmSpecificItem",
"autoSummonBoss", "autoCreateDungeon", "autoStartDungeon", "autoStartTower", "autoPlaySea", "autoStartSea", "autoChests", "autoSeeds", "autoCollectQuestline",
"autoKillAllDungeon", "autoClearYhwachPillars", "autoKillAllTower", "autoKillMobsSea", "autoNarutoQuest", "autoRank", "autoGoal"}
local destroyHub
local function emergencyStop()
state.alive = false
if W then pcall(W.Unload, W) end
for i = #trash, 1, -1 do
local x = trash[i]
pcall(function()
if typeof(x) == "RBXScriptConnection" then x:Disconnect()
elseif typeof(x) == "Instance" then x:Destroy()
elseif type(x) == "function" then x() end
end)
end
table.clear(trash)
end
env.LineageHubInstance = { Destroy = function() if destroyHub then destroyHub() else emergencyStop() end end }
local function getCharParts()
local c = player.Character
if not c then return nil, nil, nil end
return c, c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
end
local function getPlayerLevel()
local lvl = state.profile.Level or player:GetAttribute("Level")
if lvl and type(lvl) == "number" and lvl > 0 then return lvl end
local ls = player:FindFirstChild("leaderstats")
if ls and ls:FindFirstChild("Level") and ls.Level.Value > 0 then return ls.Level.Value end
local pGui = player:FindFirstChild("PlayerGui")
if pGui then
local hud = pGui:FindFirstChild("ScreenGui") and pGui.ScreenGui:FindFirstChild("HUD")
if hud then
local l = hud:FindFirstChild("Level") or hud:FindFirstChild("Level", true)
if l and l:IsA("TextLabel") then
local n = tonumber(l.Text:match("%d+"))
if n and n > 0 then return n end
end
end
end
return 1
end

local Farm = {tiers = nil, tiersAt = -math.huge, locked = {}, lockFails = {}, penalty = 0, penaltyBase = nil, inUse = 0, STONE_PERIOD = 1200}

function Farm.questTiers()
if Farm.tiers and os.clock() - Farm.tiersAt < 60 then return Farm.tiers end
local progIndex = {}
for i, t in ipairs(PROG) do progIndex[t[2]] = i end
local found = {}
local folder = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("Quest")
for _, npc in ipairs(folder and folder:GetChildren() or {}) do
local id = npc:GetAttribute("QuestId")
local q = id and questData[id]
local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
local text = prompt and prompt.ActionText or ""
local lo = tonumber(text:match("[Ll]evel%s*(%d+)"))
if type(q) == "table" and q.Target and lo then
local hi = tonumber(text:match("%d+%s*%-%s*(%d+)"))
found[#found + 1] = {hi or math.huge, id, q.Target, nil, string.format("%s (Lv. %d%s)", q.Target, lo, hi and (" - " .. hi) or "+"), min = lo, prog = progIndex[id]}
end
end
local fromNpc = #found >= #PROG / 2
if not fromNpc then
found = {}
local lo = 0
for i, t in ipairs(PROG) do
found[#found + 1] = {t[1], t[2], t[3], t[4], t[5], min = lo, prog = i}
lo = t[1] + 1
end
end
table.sort(found, function(a, b)
if a.min ~= b.min then return a.min < b.min end
return (a.prog or 99) < (b.prog or 99)
end)
local tiers = {}
for _, t in ipairs(found) do
if not (tiers[#tiers] and tiers[#tiers].min == t.min) then tiers[#tiers + 1] = t end
end
Farm.tiers = tiers

Farm.tiersAt = fromNpc and os.clock() or os.clock() - 50
return tiers
end
function Farm.baseIndex(tiers, level)
local base = 1
for i, t in ipairs(tiers) do
if t.min <= level then base = i end
end
return base
end

function Farm.levelTier()
if tonumber(config.questSkip) == Farm.BEST then return Farm.bestTier() end
local tiers = Farm.questTiers()
local base = Farm.baseIndex(tiers, getPlayerLevel())
if Farm.penaltyBase ~= base then Farm.penaltyBase, Farm.penalty = base, 0 end
local top = math.min(#tiers, base + (tonumber(config.questSkip) or 0))
local now = os.clock()
local pick = base
for i = top, base + 1, -1 do
if (Farm.locked[tiers[i][2]] or 0) <= now then pick = i break end
end
pick = math.max(base, pick - Farm.penalty)
Farm.inUse = pick - base
return tiers[pick]
end

function Farm.selectedTier()
if config.selectedMonster == "[Auto Level Progression]" then return Farm.levelTier() end
Farm.inUse = 0
local name = Farm.mobName(config.selectedMonster)
for _, t in ipairs(Farm.questTiers()) do if t[3] == name then return t end end
for _, t in ipairs(PROG) do if t[3] == name then return t end end
return nil
end
function Farm.mobName(label)
return (tostring(label or ""):gsub("%s*%(Lv%..-%)%s*$", ""))
end

Farm.BEST = 100
Farm.best = {rate = {}, n = {}, bad = {}, cur = nil, since = 0, mark = nil, got = 0, dps = nil, enemies = nil}
function Farm.short(n)
n = tonumber(n) or 0
for _, u in ipairs({{1e12, "T"}, {1e9, "B"}, {1e6, "M"}, {1e3, "K"}}) do
if n >= u[1] then return string.format("%.1f%s", n / u[1], u[2]) end
end
return tostring(math.floor(n))
end
function Farm.bestCandidates()
local B = Farm.best
if not B.enemies then
B.enemies = {}
pcall(function() B.enemies = require(ReplicatedStorage.Shared.Data.Enemies) end)
end
local out = {}
local folder = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("Quest")
for _, npc in ipairs(folder and folder:GetChildren() or {}) do
local id = npc:GetAttribute("QuestId")
local q = id and questData[id]
local e = type(q) == "table" and B.enemies[q.Target]
if type(q) == "table" and type(q.Reward) == "table" and tonumber(q.Reward.EXP) and type(e) == "table" and tonumber(e.Health) then
out[#out + 1] = {id = id, target = q.Target, exp = q.Reward.EXP, amount = q.Amount or 1, hp = e.Health}
end
end
return out
end

function Farm.bestScore(c, now)
local B = Farm.best
if (B.bad[c.id] or 0) > now then return -1 end
if B.rate[c.id] then return B.rate[c.id] end
local secs = c.amount * (c.hp / (B.dps or 1500) + (c.amount == 1 and 10 or 3))
if secs > 600 then return -1 end
return c.exp * (B.gain or 1) / secs * 0.8
end
function Farm.bestTier()
local B = Farm.best
local now = os.clock()
local cands = Farm.bestCandidates()
if #cands == 0 then
local tiers = Farm.questTiers()
Farm.inUse = 0
return tiers[Farm.baseIndex(tiers, getPlayerLevel())]
end

local active = config.autoFarm and not (state.worldBossUp and config.autoFarmWorldBoss)
if active then
if B.lastTick and now - B.lastTick > 5 then
B.since = B.since + (now - B.lastTick)
if B.mark then B.mark = B.mark + (now - B.lastTick) end
end
B.lastTick = now
end
for _, c in ipairs(cands) do

if active and c.id == B.cur and B.got == 0 and now - B.since >= 240 and not B.rate[c.id] then
B.rate[c.id] = c.exp / (now - B.since) * 0.5
B.dps = math.min(B.dps or math.huge, c.amount * c.hp / (now - B.since) * 0.5)
logLine("QUEST", string.format("best EXP: %s paid nothing in %.0fs", c.target, now - B.since))
end
end
local cur, pick, pickScore = nil, nil, -math.huge
for _, c in ipairs(cands) do
if c.id == B.cur then cur = c end
local s = Farm.bestScore(c, now)
if s > pickScore then pick, pickScore = c, s end
end
if pickScore < 0 then
local tiers = Farm.questTiers()
Farm.inUse = 0
return tiers[Farm.baseIndex(tiers, getPlayerLevel())]
end

if cur and Farm.bestScore(cur, now) >= 0 and ((B.got < 3 and now - B.since < 240) or not active) then pick = cur end
if pick.id ~= B.cur then
logLine("QUEST", string.format("best EXP: %s -> %s (%s EXP/min%s)", tostring(cur and cur.target), pick.target,
Farm.short(pickScore * 60), B.rate[pick.id] and "" or " est"))
B.cur, B.since, B.mark, B.got = pick.id, now, now, 0
end
Farm.inUse = 0
local rate = B.rate[pick.id]
local label = string.format(L("%s · EXP คุ้มสุด %s/นาที%s", "%s · best EXP %s/min%s"), pick.target,
Farm.short((rate or math.max(pickScore, 0)) * 60), rate and "" or L(" (ประมาณ)", " (est.)"))
return {0, pick.id, pick.target, nil, label, min = 0}
end
function Farm.bestEarned(amount)
local B = Farm.best
if tonumber(config.questSkip) ~= Farm.BEST or not B.cur or not amount then return end
local q = questData[B.cur]
local expected = type(q) == "table" and type(q.Reward) == "table" and tonumber(q.Reward.EXP)
if not expected or amount < expected * 0.5 or amount > expected * 5 then return end
local now = os.clock()
local dt = now - (B.mark or now)
B.mark = now
B.got = B.got + 1
B.gain = amount / expected

if B.got == 1 or dt < 2 or dt > 600 then return end
local sample = amount / dt
B.rate[B.cur] = B.rate[B.cur] and (B.rate[B.cur] * 0.5 + sample * 0.5) or sample
B.n[B.cur] = (B.n[B.cur] or 0) + 1
local enemy = B.enemies and B.enemies[q.Target]
if type(enemy) == "table" and tonumber(enemy.Health) then
local dps = (q.Amount or 1) * enemy.Health / dt
B.dps = B.dps and (B.dps * 0.5 + dps * 0.5) or dps
end
logLine("QUEST", string.format("best EXP: %s paid %s in %.0fs -> %s EXP/min", q.Target, Farm.short(amount), dt, Farm.short(B.rate[B.cur] * 60)))
end
function Farm.dropTier(reason)
if not config.autoFarm or config.selectedMonster ~= "[Auto Level Progression]" then return end
if tonumber(config.questSkip) == Farm.BEST then
local B = Farm.best
if not B.cur then return end
B.bad[B.cur] = os.clock() + 600
logLine("QUEST", string.format("%s on best-EXP quest %s -> skip it 10 min", reason, tostring(B.cur)))
showNotification(HUB_NAME, L("เควสต์นี้สู้ไม่ไหว · ใช้เควสต์อื่น 10 นาที", "Too strong · using another quest for 10 min"), 6)
return
end
if Farm.inUse <= 0 then return end
Farm.penalty = Farm.penalty + 1
logLine("QUEST", string.format("%s on a skipped tier -> down one tier (penalty %d)", reason, Farm.penalty))
showNotification(HUB_NAME, L("ข้ามเวลแล้วสู้ไม่ไหว · ลดลง 1 ช่วง", "Too strong when skipping levels · down one tier"), 6)
end
pcall(function()
local notify = getRE("Notify")
if notify then
track(notify.OnClientEvent:Connect(function(kind, data)
if kind == "EXPEarn" and type(data) == "table" then Farm.bestEarned(tonumber(data[1])) end
end))
end
end)

function Farm.bossTimes()
local out = {}
local folder = workspace:FindFirstChild("Boss")
for _, spawner in ipairs(folder and folder:GetChildren() or {}) do
local up = false
for _, m in ipairs(spawner:GetChildren()) do
local h = m:IsA("Model") and m:FindFirstChildOfClass("Humanoid")
if h and h.Health > 0 then out[m.Name] = {alive = true} up = true end
end
local gui = spawner:FindFirstChild("TimerGui")
local nameLabel, timerLabel = gui and gui:FindFirstChild("BossName"), gui and gui:FindFirstChild("Timer")
if not up and gui and gui.Enabled and nameLabel and timerLabel and nameLabel.Text ~= "" then
local secs, any = 0, false
for n in timerLabel.Text:gmatch("%d+") do secs, any = secs * 60 + tonumber(n), true end
if any and not out[nameLabel.Text] then out[nameLabel.Text] = {eta = secs} end
end
end
if not (out.Stone and out.Stone.alive) then
local now = workspace:GetServerTimeNow()
out.Stone = {eta = math.ceil(Farm.STONE_PERIOD - now % Farm.STONE_PERIOD), approx = true}
end
return out
end
function Farm.clock(secs)
secs = math.max(0, math.floor(secs))
return string.format("%d:%02d", math.floor(secs / 60), secs % 60)
end
local function getCurrentTier()
local tiers = Farm.questTiers()
return tiers[Farm.baseIndex(tiers, getPlayerLevel())]
end
local function getActiveTool()
local char, hum, _ = getCharParts()
if not char then return nil end
local tool = char:FindFirstChildOfClass("Tool")
if tool then return tool end
local backpack = player:FindFirstChild("Backpack")
if backpack then

local bestScore = -1
for _, t in ipairs(backpack:GetChildren()) do
if t:IsA("Tool") then
local score = 0
local mod = toolConfigs and toolConfigs:FindFirstChild(t.Name)
local ok, cfg = pcall(function() return mod and require(mod) end)
if ok and type(cfg) == "table" and type(cfg.Skill) == "table" then
for _ in pairs(cfg.Skill) do score = score + 1 end
end
if t.Name == "Combat" then score = -0.5 end
if score > bestScore then tool, bestScore = t, score end
end
end
if tool and hum then
pcall(function() hum:EquipTool(tool) end)
return tool
end
end
return nil
end
local function getFruitTools()
local fruits = {}
for _, container in ipairs({player:FindFirstChild("Backpack") or false, player.Character or false}) do
if container then
for _, item in ipairs(container:GetChildren()) do
if item:IsA("Tool") and item.ToolTip == "Devil Fruit" and item.CanBeDropped then
fruits[#fruits + 1] = item
end
end
end
end
return fruits
end
local function dropFruitTools(fruits)
local char, hum = getCharParts()
local backpack = player:FindFirstChild("Backpack")
if not char or not hum or hum.Health <= 0 or not backpack then return 0, #fruits, "Character unavailable" end
local vim
pcall(function() vim = game:GetService("VirtualInputManager") end)
if not vim and not (type(keypress) == "function" and type(keyrelease) == "function") then
return 0, #fruits, "Backspace input unavailable"
end
local originalTool = char:FindFirstChildOfClass("Tool")
local dropped, failed = 0, 0
state.droppingFruits = true
local ok, err = pcall(function()
for _, fruit in ipairs(fruits) do
if hum.Health <= 0 or player.Character ~= char then break end
if fruit.Parent ~= backpack and fruit.Parent ~= char then
failed = failed + 1
else
if fruit.Parent ~= char then pcall(function() hum:EquipTool(fruit) end) end
task.wait(0.1)
if fruit.Parent == char then
local pressed = false
if vim then
pressed = pcall(function()
vim:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
vim:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
end)
end
if not pressed and type(keypress) == "function" and type(keyrelease) == "function" then
pressed = pcall(function() keypress(0x08) keyrelease(0x08) end)
end
if pressed then task.wait(0.3) end
if pressed and fruit.Parent ~= char and fruit.Parent ~= backpack then
dropped = dropped + 1
else
failed = failed + 1
end
else
failed = failed + 1
end
end
end
end)
state.droppingFruits = false
if originalTool and originalTool.Parent == backpack and hum.Health > 0 then
pcall(function() hum:EquipTool(originalTool) end)
end
return dropped, failed, if ok then nil else tostring(err)
end
local function cancelMotion()
if state.activeTween then
state.activeTween:Cancel()
state.activeTween = nil
end
end
local INSTANT_RANGE = 60
local MAX_SPEED = 150
local function needsTravel(modeOverride)
return (modeOverride or config.farmMovement) == "Tween"
end

function Farm.islandHop(root, hum, destination)
if not teleportRemote or os.clock() - (state.lastIslandHop or -math.huge) < 6 then return end
local dist = (root.Position - destination.Position).Magnitude
if dist < 900 then return end
local points = workspace:FindFirstChild("TeleportPoint")
local best, bestDist = nil, dist - 600
for _, p in ipairs(points and points:GetChildren() or {}) do
local pos = p:IsA("BasePart") and p.Position or (p:IsA("Model") and p:GetPivot().Position) or nil
if pos and (pos - destination.Position).Magnitude < bestDist then best, bestDist = p, (pos - destination.Position).Magnitude end
end
if not best then return end
state.lastIslandHop = os.clock()
local before = root.Position
cancelMotion()
teleportRemote:FireServer(tonumber(best.Name) or best.Name)
local t0 = os.clock()
while os.clock() - t0 < 4 and (root.Position - before).Magnitude < 50 and hum.Health > 0 and root.Parent do task.wait(0.1) end
logLine("MOVE", string.format("island hop to %s: %d -> %d studs left", best.Name, dist, (root.Position - destination.Position).Magnitude))
task.wait(0.3)
end
local function moveTo(destination, token, modeOverride)
local _, hum, root = getCharParts()
if not hum or hum.Health <= 0 or not root then return false end
Farm.islandHop(root, hum, destination)
if token and state.token ~= token then return false end
if hum.Health <= 0 or not root.Parent then return false end
local dist = (root.Position - destination.Position).Magnitude
if not needsTravel(modeOverride) then
cancelMotion()
root.CFrame = destination
root.AssemblyLinearVelocity = Vector3.zero
return true
end
if dist < 2 then return true end
cancelMotion()
local speed = math.clamp(tonumber(config.tweenSpeed) or MAX_SPEED, 50, MAX_SPEED)
local duration = math.max(0.08, dist / speed)
local tw = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = destination})
state.activeTween = tw
local finished = false
local settled = false
local noclipConn = RunService.Stepped:Connect(function()
if player.Character then
for _, part in ipairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end)
local compConn = tw.Completed:Connect(function(playbackState)
settled = true
finished = playbackState == Enum.PlaybackState.Completed
end)
tw:Play()
while not settled and state.alive and needsTravel(modeOverride) and hum.Health > 0 and root.Parent do
if token and state.token ~= token then break end
task.wait(0.04)
end
if not finished then tw:Cancel() end
if compConn then compConn:Disconnect() end
if noclipConn then noclipConn:Disconnect() end
if state.activeTween == tw then state.activeTween = nil end
if not modeOverride and config.farmMovement == "Teleport" and state.alive and hum.Health > 0 and root.Parent
and (not token or state.token == token) then
root.CFrame = destination
root.AssemblyLinearVelocity = Vector3.zero
return true
end
return finished and (root.Position - destination.Position).Magnitude < 10
end
local function moveToFarm(destination)
if not needsTravel() then return moveTo(destination) end
if state.farmTraveling then return false end
state.farmTraveling = true
local ok, result = pcall(function()
local _, hum, root = getCharParts()
if not hum or hum.Health <= 0 or not root then return false end
local flatDistance = (Vector3.new(root.Position.X, 0, root.Position.Z)
- Vector3.new(destination.Position.X, 0, destination.Position.Z)).Magnitude
if (flatDistance > INSTANT_RANGE or root.Position.Y < destination.Position.Y - 4)
and root.Position.Y < destination.Position.Y + 12 then
local safeY = destination.Position.Y + 25
if not moveTo(CFrame.new(root.Position.X, safeY, root.Position.Z)) then return false end
if not moveTo(CFrame.new(destination.Position.X, safeY, destination.Position.Z)) then return false end
end
return moveTo(destination)
end)
state.farmTraveling = false
if not ok then logLine("FARM_MOVE", tostring(result)) return false end
return result
end
local skillOrder = {"Z", "X", "C", "V", "R"}
local skillConfigCache = {}
local nativeAutoKeys = {}
local nativePending = {}
local nativeTouched = {}
local nativeLastAttempt = {}
local function getToolSkills(tool)
if not tool or not tool:IsA("Tool") or not toolConfigs then return nil end
local module = toolConfigs:FindFirstChild(tool.Name)
if not module or not module:IsA("ModuleScript") then return nil end
local cached = skillConfigCache[tool.Name]
if cached and cached.module == module then return cached.skills end
local ok, toolConf = pcall(require, module)
if not ok or type(toolConf) ~= "table" then return nil end
local skills = type(toolConf.Skill) == "table" and toolConf.Skill or nil
skillConfigCache[tool.Name] = {module = module, skills = skills}
return skills
end
local function skillIsUsable(key, data)
return type(data) == "table"
and config.skillKeys[key] == true
and not (key == "F" and data.FlyType)
end
local function nativeAutoEnabled(key)
if type(nativeAutoKeys[key]) == "boolean" then return nativeAutoKeys[key] end
local pg = player:FindFirstChild("PlayerGui")
local screen = pg and pg:FindFirstChild("ScreenGui")
local toolFrame = screen and screen:FindFirstChild("Tool")
local toolUi = toolFrame and toolFrame:FindFirstChild("ToolUI")
local keyFrame = toolUi and toolUi:FindFirstChild(key)
local auto = keyFrame and keyFrame:FindFirstChild("Auto")
local icon = auto and auto:FindFirstChild("Icon")
if not icon then return nil end
return icon.Rotation >= 90
end
local function requestNativeAutoKey(key, desired)
if not toolUiEvent then return false end
local current = nativeAutoEnabled(key)
if current == nil or current == desired then return false end
local now = os.clock()
if nativePending[key] and now - nativePending[key].time < 4 then return false end
if now - (nativeLastAttempt[key] or -math.huge) < 3 then return false end
nativePending[key] = {desired = desired, time = now}
nativeLastAttempt[key] = now
local ok = pcall(function()
toolUiEvent:FireServer("AutoKey", {Key = key})
end)
if not ok then nativePending[key] = nil end
return ok
end
local function syncNativeAutoSkills()
if not config.autoSkill then
for key in pairs(nativeTouched) do requestNativeAutoKey(key, false) end
return
end
local character = player.Character
local tool = character and character:FindFirstChildOfClass("Tool")
local skills = getToolSkills(tool)
if not skills then return end
for _, key in ipairs(skillOrder) do
local desired = skillIsUsable(key, skills[key])
requestNativeAutoKey(key, desired)
end
end
if toolUiEvent then
pcall(function()
track(toolUiEvent.OnClientEvent:Connect(function(kind, payload)
if kind ~= "AutoKey" or type(payload) ~= "table"
or type(payload.Key) ~= "string" or type(payload.Value) ~= "boolean" then return end
nativeAutoKeys[payload.Key] = payload.Value
local pending = nativePending[payload.Key]
nativePending[payload.Key] = nil
if pending and pending.desired == payload.Value then
nativeTouched[payload.Key] = payload.Value or nil
end
if pending or config.autoSkill then task.defer(syncNativeAutoSkills) end
end))
end)
end
local function requestAutoSkill(tool, force)
if not (config.autoSkill or force) or not tool or tool.Parent ~= player.Character then return false end
local skills = getToolSkills(tool)
if not skills then return false end
local now = os.clock()
local gameCooldown = tonumber(player:GetAttribute("Cooldown")) or 0.85
if now - state.lastSkillAttempt < math.max(config.skillInterval, gameCooldown) then
return false
end
for offset = 1, #skillOrder do
local index = (state.skillCursor + offset - 1) % #skillOrder + 1
local key = skillOrder[index]
local data = skills[key]
local cooldownId = tool.Name .. ":" .. key
if skillIsUsable(key, data) and (config.autoNarutoQuest or nativeAutoEnabled(key) ~= true)
and now >= (state.skillReadyAt[cooldownId] or 0) then
local ok = false
if skillEvent then
ok = pcall(function() skillEvent:FireServer(tool.Name, key) end)
end
if not ok then return false end
state.lastSkillAttempt = now
state.skillReadyAt[cooldownId] = now + math.max(0.5, tonumber(data.Cooldown) or config.skillInterval)
state.skillCursor = index
state.skillRequests = state.skillRequests + 1
state.lastSkillUsed = tool.Name .. " [" .. key .. "]"
return true
end
end
return false
end
local function bossRequirements(data, bossName)
if bossName == "[All Spawned Bosses]" or bossName == "All" then
return "🌐 โหมดล่าบอสทุกตัว: สแกนและวาร์ปไปตีบอสทุกตัวที่กำลังเกิดในเซิร์ฟเวอร์อัตโนมัติ"
end
if not data or data.Type == "Time" then
return "⏳ บอสเวลา (Time Spawn): เกิดตามรอบเวลาในเซิร์ฟเวอร์ ไม่ต้องใช้ของอัญเชิญ"
end
local req = data.Req or {}
local details = {}
if req.Gems then table.insert(details, tostring(req.Gems) .. " Gems") end
if req.Coins then table.insert(details, tostring(req.Coins) .. " Coins") end
if req.HollowKill then table.insert(details, tostring(req.HollowKill) .. " Hollow kills") end
for item, count in pairs(req.Materials or {}) do
table.insert(details, tostring(count) .. "x " .. tostring(item))
end
for item, count in pairs(req.Items or {}) do
table.insert(details, tostring(count) .. "x " .. tostring(item))
end
if #details > 0 then
return "👑 บอสอัญเชิญ (Summon Cost): " .. table.concat(details, ", ")
end
return "👑 บอสอัญเชิญ (Summon Boss): ไม่ต้องใช้วัตถุดิบในการเรียก"
end
local told = {}
local function tellPlayer(key, text)
local now = os.clock()
if told[key] and now - told[key] < 300 then return end
told[key] = now
showNotification(HUB_NAME, text, 6)
end
local function canAffordSummon(bossName)
local data = bossesData[bossName]
local req = data and data.Req or {}
local missing = {}
local function need(name, have, want)
if (tonumber(have) or 0) < want then missing[#missing + 1] = string.format("%s %s/%s", name, tostring(have or 0), tostring(want)) end
end
if req.Gems then need("Gems", state.currency.Gems, req.Gems) end
if req.Coins then need("Coins", state.currency.Coins, req.Coins) end
for item, count in pairs(req.Materials or {}) do need(item, state.inventory[item], count) end
for item, count in pairs(req.Items or {}) do need(item, state.inventory[item], count) end
return #missing == 0, table.concat(missing, ", ")
end
local function costText(bossName)
local parts = {string.format("Gems=%s Coins=%s", tostring(state.currency.Gems), tostring(state.currency.Coins))}
local data = bossName and bossesData[bossName]
for item in pairs(data and data.Req and data.Req.Materials or {}) do
parts[#parts + 1] = item .. "=" .. tostring(state.inventory[item] or 0)
end
return table.concat(parts, " ")
end
local function onSummonEvent(action, payload)
if (action == "Auto" or action == "AutoSummon") and type(payload) == "table" then
state.autoSummonPending = false
state.summonNoReply = 0
state.autoSummonActive = payload.Activated == true
state.autoSummonBoss = payload.Boss
logLine("SUMMON", string.format("game auto summon = %s boss=%s | %s", tostring(state.autoSummonActive), tostring(payload.Boss), costText(payload.Boss)))
state.lastInventorySync = 0
task.delay(3, function() logLine("SUMMON", "balance after | " .. costText(payload.Boss)) end)
end
end
if summonEvent then
pcall(function() track(summonEvent.OnClientEvent:Connect(onSummonEvent)) end)
end
local function requestSummonBoss(bossName, diff, isAuto)
if not summonEvent then return end
local data = bossesData[bossName]
local options = {Boss = bossName}
if data and data.Difficulty then options.Difficult = diff or "Easy" end
if isAuto then
state.autoSummonPending = true
state.lastSummonSend = os.clock()
summonEvent:FireServer("AutoSummon", options)
task.delay(5, function()
if state.autoSummonPending then
state.autoSummonPending = false
state.summonNoReply = (state.summonNoReply or 0) + 1
logLine("SUMMON", "no reply from game after AutoSummon " .. tostring(bossName))
tellPlayer("summon:noreply", L("เกมไม่ตอบการอัญเชิญอัตโนมัติ · สคริปต์หยุดส่งซ้ำ (เปิด/ปิดที่หน้าอัญเชิญของเกมได้)", "The game did not answer auto summon · the script stopped sending (use the game's summon menu)"))
end
end)
else
summonEvent:FireServer("Summon", options)
end
end
local function setAutoSummon(bossName, want, reason, diff)
if not summonEvent or state.autoSummonPending then return end
if want then
local data = bossesData[bossName]
if not data or data.Type ~= "Summon" then return end
if state.autoSummonActive == true and state.autoSummonBoss == bossName then return end
if (state.summonNoReply or 0) > 0 and state.autoSummonActive == nil then return end
if os.clock() - state.lastSummonSend < 20 then return end
if not state.inventoryInit then return end
local affordable, missing = canAffordSummon(bossName)
if not affordable then
state.summonBlocked = {boss = bossName, missing = missing}
tellPlayer("summon:" .. bossName, string.format(L("อัญเชิญ %s ไม่ได้: ขาด %s", "Can't summon %s: missing %s"), bossName, missing))
return
end
state.summonBlocked = nil
if state.autoSummonActive == true and state.autoSummonBoss and state.autoSummonBoss ~= bossName then
logLine("SPEND", string.format("auto summon OFF %s (switch to %s)", tostring(state.autoSummonBoss), tostring(bossName)))
requestSummonBoss(state.autoSummonBoss, "Easy", true)
return
end
logLine("SPEND", string.format("auto summon ON %s %s (%s) | %s", tostring(bossName), tostring(diff or "Easy"), tostring(reason), costText(bossName)))
state.autoSummonOwned = true
requestSummonBoss(bossName, diff or "Easy", true)
else
if state.autoSummonActive ~= true or not state.autoSummonBoss then
state.autoSummonOwned = false
return
end
logLine("SPEND", string.format("auto summon OFF %s (%s) | %s", tostring(state.autoSummonBoss), tostring(reason), costText(state.autoSummonBoss)))
state.autoSummonOwned = false
requestSummonBoss(state.autoSummonBoss, "Easy", true)
end
end
local function ensureAutoSummon(bossName, reason, diff)
setAutoSummon(bossName, true, reason, diff)
end
local function releaseAutoSummon(reason)
if state.autoSummonOwned and not config.autoSummonBoss then setAutoSummon(nil, false, reason) end
end
local function dungeonKey(mapId)
local d = portalsData[mapId]
return type(d) == "table" and d.Used or "?"
end
if portalEvent then
pcall(function()
track(portalEvent.OnClientEvent:Connect(function(action, payload)
if action == "Selector" then
state.portalSelector = type(payload) == "table" and payload.Type or true
logLine("DUNGEON", "game opened portal selector type=" .. tostring(state.portalSelector))
elseif action == "CloseSelector" then
state.portalSelector = nil
elseif action == "Hosting" or action == "Entered" then
state.portalSelector = nil
if action == "Hosting" then state.portalHostedAt = os.clock() end
logLine("DUNGEON", "portal " .. tostring(action) .. " " .. tostring(type(payload) == "table" and payload.Portal or ""))
end
end))
end)
end
local function createPortal(reason)
if not portalEvent then return false end
local mapId = DNG_MAP[config.selectDungeon] or "ARTIFACT_01"
local key = dungeonKey(mapId)
if state.inventoryInit and (state.inventory[key] or 0) <= 0 then
tellPlayer("portal:" .. key, string.format(L("สร้างพอร์ทัลไม่ได้: ไม่มี %s", "Can't create the portal: no %s"), key))
return false
end
if not state.portalSelector then
tellPlayer("portal:selector", L("เดินไปที่ประตูพอร์ทัลของเกมก่อน (หน้าเลือกพอร์ทัลต้องเปิดอยู่) แล้วสคริปต์จะเลือกดันเจี้ยนให้", "Walk to the game's portal first (its selector must be open); the script then picks the dungeon"))
return false
end
local wantType = type(portalsData[mapId]) == "table" and portalsData[mapId].Type
if wantType and state.portalSelector ~= true and state.portalSelector ~= wantType then
tellPlayer("portal:type", string.format(L("ประตูนี้เป็นของดันเจี้ยนแบบ %s แต่เลือก %s ไว้", "This portal is for %s dungeons but %s is selected"), tostring(state.portalSelector), tostring(config.selectDungeon)))
return false
end

if config.selectDifficulty == "Nightmare" then config.selectDifficulty = "Extreme" end
if not table.find({"Easy", "Medium", "Hard", "Extreme"}, config.selectDifficulty) then
tellPlayer("portal:difficulty", L("เลือกความยากของดันเจี้ยนใหม่ก่อน (Easy / Medium / Hard / Extreme)", "Pick the dungeon difficulty again (Easy / Medium / Hard / Extreme)"))
return false
end
state.portalSelector = nil
state.lastInventorySync = 0
task.delay(3, function() logLine("SPEND", string.format("portal balance after | %s=%s", key, tostring(state.inventory[key]))) end)
logLine("SPEND", string.format("create portal %s (%s) %s | %s=%s", tostring(mapId), tostring(config.selectDifficulty), tostring(reason), key, tostring(state.inventory[key])))
portalEvent:FireServer("Select", {Difficulty = config.selectDifficulty, Portal = mapId, FriendOnly = false})
return true
end
local SEA_PLACE = 121357213553162
local IN_SEA = game.PlaceId == SEA_PLACE
pcall(function() Rank.data = require(ReplicatedStorage.Shared.Data.Ranks) end)
Rank.REQ_ORDER = {"ClearPortals", "KillBosses", "KillNPCs", "TotalDamage", "Level", "SimulatedPassed"}
Rank.REQ_TEXT = {
ClearPortals = {"เคลียร์พอร์ทัล", "Clear portals"}, KillBosses = {"ฆ่าบอส", "Kill bosses"}, KillNPCs = {"ฆ่า NPC", "Kill NPCs"},
TotalDamage = {"ดาเมจรวม", "Total damage"}, Level = {"เลเวล", "Level"}, SimulatedPassed = {"ผ่านทะเล Simulated", "Simulated sea passed"}
}
if Rank.event then
pcall(function()
track(Rank.event.OnClientEvent:Connect(function(action, payload)
if (action ~= "Update" and action ~= "RankUp") or type(payload) ~= "table" or type(payload.Recieve) ~= "table" then return end
state.rank = payload.Recieve
state.rankSyncedAt = os.clock()
if action == "RankUp" then
local newRank = tostring(payload.Recieve.Stats and payload.Recieve.Stats.Rank)
logLine("RANK", "rank up -> " .. newRank)
showNotification("Rank", L("อัป Rank เป็น ", "Ranked up to ") .. newRank, 5)
end
end))
end)
end
function Rank.needs()
local r, data = state.rank, Rank.data
if type(r) ~= "table" or type(r.Stats) ~= "table" or type(data.Rank) ~= "table" then return nil end
local cur = r.Stats.Rank
local nextName = data.NumToRank[(data.RankToNum[cur] or 0) + 1]
if not nextName then return cur, nil, {} end
local req = data.Rank[nextName].Req or {}
local needs = {}
for _, key in ipairs(Rank.REQ_ORDER) do
if req[key] then
local have
if key == "Level" then have = r.Stats.Level
elseif key == "SimulatedPassed" then have = r.Simulated and r.Simulated.Pass
else have = r.Record and r.Record[key] end
needs[#needs + 1] = {key = key, have = tonumber(have) or 0, need = req[key]}
end
end
local mats = r.Storage and r.Storage.Material or {}
local items = {}
for item in pairs(req.Materials or {}) do items[#items + 1] = item end
table.sort(items)
for _, item in ipairs(items) do
needs[#needs + 1] = {key = item, have = tonumber(mats[item]) or 0, need = req.Materials[item], item = true}
end
return cur, nextName, needs
end

function Rank.portalChoice()
local mats = state.rank and state.rank.Storage and state.rank.Storage.Material or {}
local bestId, bestCount = nil, 0
for id, data in pairs(portalsData) do
if type(data) == "table" and data.Used then
local count = tonumber(mats[data.Used]) or 0
if count > 0 and (data.Used == "Cartenon Key" and count + 1e6 or count) > bestCount then
bestId, bestCount = id, data.Used == "Cartenon Key" and count + 1e6 or count
end
end
end
return bestId, bestId and portalsData[bestId].Used
end

function Rank.pickTask()
local cur, nextName, needs = Rank.needs()
if not cur then return {kind = "sync"} end
if not nextName then return {kind = "max", rank = cur} end
local blocked
for _, n in ipairs(needs) do
if n.have < n.need then
if n.item then
local info = ITEM_DROP_MAP[n.key]
if info and not info.dungeon then return {kind = "item", need = n, info = info, rank = nextName} end
blocked = blocked or n
elseif n.key == "ClearPortals" then
local portalId, key = Rank.portalChoice()
if portalId then return {kind = "portal", need = n, portal = portalId, key = key, rank = nextName} end
blocked = blocked or n
elseif n.key == "KillBosses" then
return {kind = "boss", need = n, rank = nextName}
elseif n.key == "SimulatedPassed" then
blocked = blocked or n
else
return {kind = "mob", need = n, rank = nextName}
end
end
end
if blocked then return {kind = "blocked", need = blocked, rank = nextName} end
return {kind = "rankup", rank = nextName}
end

Rank.SUMMONERS = {
Rimuru = {orb = "Slime Orb", orbMob = "Hollow", npc = {"NPC", "FossilSummon", "SlimeSummonNPC"}, remote = "SlimeRE", action = "SummonSlime", spawner = "ServerTimeBossSpawner"}
}
function Rank.summonerFill(summoner)
local node = workspace
for _, name in ipairs(summoner.npc) do node = node and node:FindFirstChild(name) end
local prompt = node and node:FindFirstChildWhichIsA("ProximityPrompt", true)
if not prompt then return nil end
local have, cost = prompt.ActionText:match("(%d+)%s*/%s*(%d+)")
return tonumber(have), tonumber(cost), node, prompt
end
function Rank.spawnerBoss(summoner, except)
local spawner = workspace:FindFirstChild("Boss") and workspace.Boss:FindFirstChild(summoner.spawner)
for _, m in ipairs(spawner and spawner:GetChildren() or {}) do
local h = m:IsA("Model") and m.Name ~= except and m:FindFirstChildOfClass("Humanoid")
if h and h.Health > 0 then return m end
end
return nil
end

function Rank.spareOrbs(orb)
local _, _, needs = Rank.needs()
local keep = 0
for _, n in ipairs(needs or {}) do
if n.item and n.key == orb then keep = n.need end
end
local mats = state.rank and state.rank.Storage and state.rank.Storage.Material or {}
return (tonumber(mats[orb]) or 0) - keep
end
function Rank.hostedPortal()
local folder = ReplicatedStorage:FindFirstChild("Game")
folder = folder and folder:FindFirstChild("Portal")
local host = folder and folder:FindFirstChild("Host")
return IN_SEA and host and host.Value == player.Name and folder or nil
end
local TOWER_COST = 500000
pcall(function() TOWER_COST = require(ReplicatedStorage.Shared.Data.Tower_Info).REQ.Coins or TOWER_COST end)
local seaCardRemote = getRE("SimulatedCardRE")
local CARD_RANK = {Gold = 3, Silver = 2, Bronze = 1}
local cardsInfo = {}
pcall(function() cardsInfo = require(ReplicatedStorage.Shared.Data.Cards_Info) end)
local function seaStart(reason)
if not (IN_SEA and seaRemote and config.autoStartSea) then return end
logLine("SEA", "Start (" .. reason .. ")")
safe("SEA", function() seaRemote:FireServer("Start") end)
end
if IN_SEA and seaRemote then
track(seaRemote.OnClientEvent:Connect(function(action)
if action == "Initialize" then
task.delay(1, seaStart, "initialize")
elseif action == "End" then
task.delay(2, function()
if not state.alive then return end
if config.autoLeaveSea then
logLine("SEA", "run ended -> Leave")
safe("SEA", function() seaRemote:FireServer("Leave") end)
elseif config.autoPlaySea then
logLine("SEA", "run ended -> Replay")
safe("SEA", function() seaRemote:FireServer("Replay") end)
end
end)
end
end))
task.delay(3, function()
local ok, visible = pcall(function() return player.PlayerGui.SimulatedGui.StartCanvas.Visible end)
if ok and visible then seaStart("start button visible") end
end)
end
if IN_SEA and seaCardRemote then
track(seaCardRemote.OnClientEvent:Connect(function(action, payload)
if action ~= "Select" or not config.autoPickBestCard or type(payload) ~= "table" or type(payload.Cards) ~= "table" then return end
local list = {}
for _, name in ipairs(payload.Cards) do list[#list + 1] = name end
table.sort(list, function(a, b)
local ra = CARD_RANK[type(cardsInfo[a]) == "table" and cardsInfo[a].Tier or ""] or 0
local rb = CARD_RANK[type(cardsInfo[b]) == "table" and cardsInfo[b].Tier or ""] or 0
return ra > rb
end)
local amount = math.max(1, tonumber(payload.Amount) or 1)
task.spawn(function()
task.wait(1)
for i = 1, math.min(amount, #list) do
logLine("SEA", string.format("pick card %s (%s)", list[i], tostring(type(cardsInfo[list[i]]) == "table" and cardsInfo[list[i]].Tier)))
safe("SEA", function() seaCardRemote:FireServer("Select", {Card = list[i]}) end)
task.wait(0.5)
end
end)
end))
end
local pityInfo = {tickets = 0, bannerPity = 0, bossPity = 0}
local function updatePityLabels()
local pg = player:FindFirstChild("PlayerGui")
local bannerFrame = pg and pg:FindFirstChild("ScreenGui") and pg.ScreenGui:FindFirstChild("Banner") and pg.ScreenGui.Banner:FindFirstChild("BannerFrame")
local main = bannerFrame and bannerFrame:FindFirstChild("Main")
if main then
local rem = main:FindFirstChild("Remaining")
local pity = main:FindFirstChild("Pity")
if rem and rem:IsA("TextLabel") then
local t = tonumber(rem.Text:match("%d+"))
if t then pityInfo.tickets = t end
end
if pity and pity:IsA("TextLabel") then
local p = tonumber(pity.Text:match("(%d+)%s*/%s*80")) or tonumber(pity.Text:match("%d+"))
if p then pityInfo.bannerPity = p end
end
end
pityInfo.bossPity = player:GetAttribute("BossPity") or 0
end
if bannerEvent then
pcall(function()
track(bannerEvent.OnClientEvent:Connect(function(action, payload)
if action == "Update" and type(payload) == "table" then
if payload.Ticket then pityInfo.tickets = tonumber(payload.Ticket) or pityInfo.tickets end
if payload.Pity then pityInfo.bannerPity = tonumber(payload.Pity) or pityInfo.bannerPity end
end
end))
end)
end
local questlineLastPrompt = {}
local function hasActiveQuestline()
if not config.autoCollectQuestline then return false end
for _, g in ipairs(QUESTLINE_GROUPS) do
if config.questlineAuto[g] then return true end
end
return false
end
local function promptBasePart(prompt)
local current = prompt.Parent
while current and current ~= workspace do
if current:IsA("BasePart") then return current end
current = current.Parent
end
return nil
end
local visualKeys = {
"Disabled_Particles", "Disabled_Other_VFX",
"Disabled_ColorCorrection", "Disabled_Shake", "Disable_Cutscene"
}
local VFX_FILE = DATA_DIR .. "/vfx_original.json"
local function readVfxOriginal()
local ok, t = pcall(function() return HttpService:JSONDecode(readfile(VFX_FILE)) end)
return ok and type(t) == "table" and t or nil
end
local restoreVisualSettings, toggleHideVfx
do

local function applyVisualSettings(want)
env.__LineageVfxGen = (env.__LineageVfxGen or 0) + 1
local gen = env.__LineageVfxGen
task.spawn(function()
for _ = 1, 3 do
local sent = 0
for _, key in ipairs(visualKeys) do
if gen ~= env.__LineageVfxGen then return end
if player:GetAttribute(key) ~= want[key] then
sent = sent + 1
pcall(function() settingEvent:FireServer(key, want[key]) end)
task.wait(0.25)
end
end
if sent == 0 then return end
task.wait(1.5)
end
logLine("SETTING", "visual settings did not all apply")
end)
end
function restoreVisualSettings()
if not settingEvent then return end
local original = readVfxOriginal() or state.effectOriginal
if not original then return end

local allOff = true
for _, key in ipairs(visualKeys) do
if original[key] ~= true then allOff = false end
end
local want = {}
for _, key in ipairs(visualKeys) do want[key] = not allOff and original[key] == true end
applyVisualSettings(want)
pcall(function() if delfile then delfile(VFX_FILE) end end)
state.effectOriginal = nil
config.hideVfx = false
end
function toggleHideVfx()
if not settingEvent then return end
if config.hideVfx then
restoreVisualSettings()
else
state.effectOriginal = readVfxOriginal()
if not state.effectOriginal then
state.effectOriginal = {}
for _, key in ipairs(visualKeys) do state.effectOriginal[key] = player:GetAttribute(key) == true end
pcall(writefile, VFX_FILE, HttpService:JSONEncode(state.effectOriginal))
end
local want = {}
for _, key in ipairs(visualKeys) do want[key] = true end
applyVisualSettings(want)
config.hideVfx = true
end
end
end
local lowRamSoundCache = {}
local lowRamSoundConnection
local lowRamSoundGeneration = 0
local function muteAssetSound(item)
if not item:IsA("Sound") or lowRamSoundCache[item] then return end
local soundId = item.SoundId
if soundId == "" then return end
lowRamSoundCache[item] = soundId
item.SoundId = ""
end
local function restoreLowRamAudio()
lowRamSoundGeneration = lowRamSoundGeneration + 1
if lowRamSoundConnection then lowRamSoundConnection:Disconnect() lowRamSoundConnection = nil end
local restored = 0
for sound, soundId in pairs(lowRamSoundCache) do
if sound.Parent then
local ok = pcall(function() sound.SoundId = soundId end)
if ok then restored = restored + 1 end
end
lowRamSoundCache[sound] = nil
end
config.lowRamAudio = false
logLine("LOW_RAM", "restored sound IDs: " .. restored)
end
local function setLowRamAudio(enabled)
if not enabled then restoreLowRamAudio() return end
if config.lowRamAudio then return end
local assets = ReplicatedStorage:FindFirstChild("Assets")
if not assets then logLine("LOW_RAM", "Assets folder missing") return end
config.lowRamAudio = true
lowRamSoundGeneration = lowRamSoundGeneration + 1
local generation = lowRamSoundGeneration
lowRamSoundConnection = assets.DescendantAdded:Connect(function(item)
if config.lowRamAudio then pcall(muteAssetSound, item) end
end)
task.spawn(function()
local muted = 0
for index, item in ipairs(assets:GetDescendants()) do
if not state.alive or not config.lowRamAudio or generation ~= lowRamSoundGeneration then return end
if item:IsA("Sound") then
local ok = pcall(muteAssetSound, item)
if ok and lowRamSoundCache[item] then muted = muted + 1 end
end
if index % 500 == 0 then task.wait() end
end
logLine("LOW_RAM", "muted asset sounds: " .. muted)
end)
end
local MOB_FOLDERS = {"Boss", "Bosses", "Enemies", "Live"}
local mobIndex = {}
local indexedFolders = {}
local function indexHumanoid(d, folderName)
if d:IsA("Humanoid") and d.Parent and d.Parent:IsA("Model") then mobIndex[d.Parent] = folderName end
end
local function refreshMobIndex()
for _, folderName in ipairs(MOB_FOLDERS) do
local f = workspace:FindFirstChild(folderName)
if f and not indexedFolders[f] then
indexedFolders[f] = true
for _, d in ipairs(f:GetDescendants()) do indexHumanoid(d, folderName) end
track(f.DescendantAdded:Connect(function(d) indexHumanoid(d, folderName) end))
track(f.DescendantRemoving:Connect(function(d) if mobIndex[d] then mobIndex[d] = nil end end))
track(f.AncestryChanged:Connect(function(_, parent) if not parent then indexedFolders[f] = nil end end))
end
end
end
local KNOWN_NAMES, BOSS_LOWER = {}, {}
for _, n in ipairs(BOSSES) do KNOWN_NAMES[string.lower(n)] = true BOSS_LOWER[string.lower(n)] = true end
for _, n in ipairs(ALL_MOBS) do KNOWN_NAMES[string.lower(n)] = true end
for _, t in ipairs(PROG) do KNOWN_NAMES[string.lower(t[3])] = true end
local function isShopName(n)
return n:find("npc", 1, true) or n:find("seller", 1, true) or n:find("merchant", 1, true)
end
local function liveMobRoot(m)
if not m:IsDescendantOf(workspace) then mobIndex[m] = nil return nil end
if m == player.Character then return nil end
local hum = m:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return nil end
return m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("Torso") or m.PrimaryPart
end
local function findMob(name, opts)
local _, _, root = getCharParts()
if not root or not name or name == "" then return nil end
refreshMobIndex()
local lname = string.lower(name)
local best, bestScore, bestDist = nil, math.huge, math.huge
local now = os.clock()
for m, folder in pairs(mobIndex) do
local r = liveMobRoot(m)

if r and opts.all and (state.avoidTargets[m] or 0) > now then r = nil end
if r then
local n = string.lower(m.Name)
if not isShopName(n) then
local inBossFolder = folder == "Boss" or folder == "Bosses"
local score
if opts.all then
if inBossFolder or BOSS_LOWER[n] or m:GetAttribute("IsBoss") or m:FindFirstChild("BossTag") then
score = 1
elseif not KNOWN_NAMES[n] then
for b in pairs(BOSS_LOWER) do
if n:find(b, 1, true) then score = 2 break end
end
end
elseif n == lname then
score = 1
elseif not KNOWN_NAMES[n] and n:find(lname, 1, true) then
score = 2
end
if score then
if opts.bossFirst and inBossFolder then score = score - 0.5 end
local d = (root.Position - r.Position).Magnitude
if score < bestScore or (score == bestScore and d < bestDist) then
best, bestScore, bestDist = m, score, d
end
end
end
end
end
return best
end
local function findBossTarget(bossName)
local isAll = bossName == "[All Spawned Bosses]" or bossName == "All"
return findMob(bossName, {all = isAll, bossFirst = true})
end
local function findTargetMob(targetName)
return findMob(targetName, {bossFirst = table.find(BOSSES, targetName) ~= nil})
end
local function findChakraFlowMob()
local function hasChakraFlow(value)
return string.find(string.lower(tostring(value)):gsub("[%s_%-]", ""), "chakraflow", 1, true) ~= nil
end
local _, _, root = getCharParts()
if not root then return nil end
refreshMobIndex()
local best, bestDistance = nil, math.huge
for mob, folder in pairs(mobIndex) do
if folder ~= "Boss" and folder ~= "Bosses" then
local mobRoot = liveMobRoot(mob)
if mobRoot then
local tagged = mob:FindFirstChild("ChakraFlow", true) ~= nil or mob:FindFirstChild("Chakra Flow", true) ~= nil
for _, instance in ipairs({mob, mob:FindFirstChildOfClass("Humanoid"), mobRoot}) do
if instance then
for key, value in pairs(instance:GetAttributes()) do
if hasChakraFlow(key) or hasChakraFlow(value) then
tagged = true
break
end
end
end
end
local mutationValue = mob:FindFirstChild("Mutation", true)
if mutationValue and mutationValue:IsA("ValueBase")
and hasChakraFlow(mutationValue.Value) then
tagged = true
end
if tagged then
local distance = (root.Position - mobRoot.Position).Magnitude
if distance < bestDistance then best, bestDistance = mob, distance end
end
end
end
end
return best
end
local function findPvPPlayer()
local wanted = tostring(config.selectedPvPPlayer or ""):match("^%s*(.-)%s*$"):gsub("^@", "")
if wanted == "" then return nil end
local userId = tonumber(wanted)
wanted = string.lower(wanted)
for _, other in ipairs(Players:GetPlayers()) do
if other ~= player and (string.lower(other.Name) == wanted or (userId and other.UserId == userId)) then
return other
end
end
return nil
end
local function livePvPCharacter(other)
local char = other and other.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
if not hum or hum.Health <= 0 or not root then return nil end
return char, root
end
local function eligiblePvPPlayers()
local available = {}
if player:GetAttribute("Disable_PVP") == true then return available end
for _, other in ipairs(Players:GetPlayers()) do
if other ~= player and other:GetAttribute("Disable_PVP") ~= true
and other.Character and other.Character:GetAttribute("SafeZone") ~= true
and livePvPCharacter(other) then
available[#available + 1] = other
end
end
return available
end
local function pvpDestination(targetRoot)
local forward = targetRoot.CFrame.LookVector
local flat = Vector3.new(forward.X, 0, forward.Z)
flat = flat.Magnitude > 0.01 and flat.Unit or Vector3.new(0, 0, -1)
local aim = targetRoot.Position + Vector3.new(0, 1, 0)
return CFrame.lookAt(aim - flat * 3, aim)
end
local function findMerchantTarget(mInfo)
local target = workspace
for _, part in ipairs(mInfo.path) do
target = target:FindFirstChild(part)
if not target then break end
end
if target then return target end
local modelName = mInfo.path[#mInfo.path]
local npcFolder = workspace:FindFirstChild("NPC")
if npcFolder then
local found = npcFolder:FindFirstChild(modelName, true)
if found then return found end
end
for _, desc in ipairs(workspace:GetChildren()) do
if desc.Name == modelName and desc:IsA("Model") then
return desc
end
end
return nil
end
local function warpToMerchant(mInfo)
local _, _, root = getCharParts()
if not root then return end
local npc = findMerchantTarget(mInfo)
if not npc then
showNotification("NPC Alert", "ไม่พบ " .. mInfo.name .. " ในแมพขณะนี้", 3)
return
end
local targetPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
if targetPart then
local dest = targetPart.CFrame + targetPart.CFrame.LookVector * 4 + Vector3.new(0, 1.2, 0)
local wait = 10 - (os.clock() - (state.lastInstantWarp or -math.huge))
if config.instantNpcWarp and wait > 0 then
showNotification("NPC", string.format(L("รออีก %d วิ แล้วกดใหม่ (กันเกมเตะ)", "Wait %d s and press again (anti-kick)"), math.ceil(wait)), 3)
return
end
if config.instantNpcWarp then
state.lastInstantWarp = os.clock()
local from = (targetPart.Position - root.Position).Magnitude
cancelMotion()
root.CFrame = dest
root.AssemblyLinearVelocity = Vector3.zero
logLine("TRAVEL", string.format("instant warp to %s (%.0f studs)", tostring(mInfo.name), from))
else
moveTo(dest, nil, "Tween")
end
showNotification("Warped", "วาร์ปไปหา " .. mInfo.name .. " สำเร็จ!", 2)
end
end
local function sendDiscordWebhook(title, description, color, fields)
local webhookUrl = config.discordWebhookUrl
if not webhookUrl or webhookUrl == "" or not string.find(webhookUrl, "discord") then
return
end
local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not req then return end
local embed = {
title = title or HUB_NAME,
description = description or "",
color = color or 2796287,
fields = fields or {},
footer = {
text = HUB_NAME .. " • " .. os.date("%X")
},
timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
}
local payload = HttpService:JSONEncode({
username = HUB_NAME,
avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png",
embeds = {embed}
})
task.spawn(function()
pcall(function()
req({
Url = webhookUrl,
Method = "POST",
Headers = {["Content-Type"] = "application/json"},
Body = payload
})
end)
end)
end

local LOADER_URL = type(env.POON_FE_URL) == "string" and env.POON_FE_URL:match("^https?://") and env.POON_FE_URL or ""
local AUTOLOAD_FILE = DATA_DIR .. "/autoload.lua"
local REEXEC_OFF_FILE = DATA_DIR .. "/reexec_off.flag"
local KICKED_FILE = DATA_DIR .. "/kicked.flag"
local NARUTO_HOP_FILE = DATA_DIR .. "/naruto_hop_resume.json"
local queueTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport or queueonteleport
local function clearNarutoHopResume()
pcall(function()
if type(isfile) == "function" and isfile(NARUTO_HOP_FILE) and type(delfile) == "function" then
delfile(NARUTO_HOP_FILE)
end
end)
end
local function readNarutoHopResume()
if type(isfile) ~= "function" or type(readfile) ~= "function" or not isfile(NARUTO_HOP_FILE) then return nil end
local ok, data = pcall(function() return HttpService:JSONDecode(readfile(NARUTO_HOP_FILE)) end)
if not ok or type(data) ~= "table" or data.userId ~= player.UserId
or type(data.time) ~= "number" or math.abs(os.time() - data.time) > 600 then
clearNarutoHopResume()
return nil
end
return data
end
local function saveNarutoHopResume()
if type(writefile) ~= "function" then return false end
local visited = state.narutoVisitedServers
if not table.find(visited, game.JobId) then table.insert(visited, game.JobId) end
while #visited > 20 do table.remove(visited, 1) end
return pcall(function()
writefile(NARUTO_HOP_FILE, HttpService:JSONEncode({userId = player.UserId, time = os.time(), visited = visited}))
end)
end
local function reexecuteCode()
local guard = string.format("if game.GameId ~= %d then return end if isfile and (isfile(%q) or isfile(%q)) then return end ", GAME_ID, REEXEC_OFF_FILE, KICKED_FILE)
if LOADER_URL ~= "" then
return guard .. string.format("pcall(function() (getgenv and getgenv() or _G).POON_FE_URL = %q loadstring(game:HttpGet(%q))() end)", LOADER_URL, LOADER_URL)
end
if type(isfile) == "function" and isfile(AUTOLOAD_FILE) then
return guard .. string.format("if isfile(%q) then loadstring(readfile(%q))() end", AUTOLOAD_FILE, AUTOLOAD_FILE)
end
return nil
end
local function setFlagFile(path, on)
pcall(function()
if on then writefile(path, tostring(os.time())) elseif isfile(path) and delfile then delfile(path) end
end)
end
setFlagFile(KICKED_FILE, false)
local function queueReexecute(reason)
if not config.autoReexecute or state.teleportQueued then return end
local code = reexecuteCode()
if not queueTeleport or not code then
logLine("SESSION", "re-execute unavailable: queue=" .. tostring(queueTeleport ~= nil) .. " code=" .. tostring(code ~= nil))
return
end
state.teleportQueued = true
local ok, err = pcall(queueTeleport, code)
if not ok then state.teleportQueued = false end
logLine("SESSION", (ok and "queued re-execute" or ("queue failed: " .. tostring(err))) .. " (" .. tostring(reason) .. ")")
RL.Flush()
end
local function serverHop(excludedServers)
showNotification("Server Hop", "กำลังค้นหาเซิร์ฟเวอร์ใหม่...", 3)
queueReexecute("server hop")
local placeId = game.PlaceId
local jobId = game.JobId
local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"
if config.discordNotifyHop then
sendDiscordWebhook("🔄 ย้ายเซิร์ฟเวอร์ (Server Hop)",
string.format("ผู้เล่น **%s** กำลังย้ายเซิร์ฟเวอร์เพื่อค้นหาห้องใหม่...", player.Name),
3447003,
{
{name = "👤 ผู้เล่น", value = player.Name, inline = true},
{name = "📈 เลเวล", value = "Lv. " .. tostring(getPlayerLevel()), inline = true},
{name = "🎮 Place ID", value = tostring(placeId), inline = true}
}
)
end
task.spawn(function()
local success, result = pcall(function()
if req then
local res = req({Url = url, Method = "GET"})
return HttpService:JSONDecode(res.Body)
else
return HttpService:JSONDecode(game:HttpGet(url))
end
end)
if success and result and result.data then
local candidates, freshCandidates = {}, {}
for _, s in ipairs(result.data) do
if type(s) == "table" and s.id and s.id ~= jobId and (s.playing or 0) < (s.maxPlayers or 16) and (s.playing or 0) > 0 then
table.insert(candidates, s.id)
if not excludedServers or not table.find(excludedServers, s.id) then
table.insert(freshCandidates, s.id)
end
end
end
if #freshCandidates > 0 then candidates = freshCandidates end
if #candidates > 0 then
local targetServer = candidates[math.random(1, #candidates)]
showNotification("Server Hop", "พบห้องใหม่แล้ว! กำลังวาร์ป...", 2)
safe("HOP", function() TeleportService:TeleportToPlaceInstance(placeId, targetServer, player) end)
return
end
else
logError("HOP", "server list failed: " .. tostring(result))
end
showNotification("Server Hop", "กำลังย้ายเซิร์ฟเวอร์แบบสุ่ม...", 2)
safe("HOP", function() TeleportService:Teleport(placeId, player) end)
end)
end
local function rejoinServer()
showNotification("Rejoin", "กำลังเชื่อมต่อเข้าห้องเดิมใหม่...", 3)
queueReexecute("rejoin")
pcall(function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)
end
local function onIdled()
if config.antiAfk then
logLine("AFK", "Idled fired -> ส่ง input จำลอง")
pcall(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.zero)
end)
end
end
pcall(function() track(player.Idled:Connect(onIdled)) end)
local function disableGameIdled()
if not config.antiAfk or type(getconnections) ~= "function" then return 0 end
local disabled = 0
pcall(function()
for _, c in ipairs(getconnections(player.Idled)) do
if c.Function ~= onIdled and c.Enabled ~= false then
c:Disable()
table.insert(state.disabledIdled, c)
disabled = disabled + 1
logLine("AFK", "disabled Idled connection #" .. disabled)
end
end
end)
return disabled
end
state.disabledIdled = {}
track(function()
if env.__LineageBooting then return end
for _, c in ipairs(state.disabledIdled) do pcall(function() c:Enable() end) end
end)
task.spawn(function()
while state.alive do
disableGameIdled()
task.wait(60)
end
end)
local deathTrace = {}
task.spawn(function()
while state.alive do
local c = player.Character
local hum = c and c:FindFirstChildOfClass("Humanoid")
local root = c and c:FindFirstChild("HumanoidRootPart")
if hum and root and hum.Health > 0 then
local target = state.farmTarget
local tRoot = target and target.Parent and (target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart)
table.insert(deathTrace, string.format("%.1f hp=%.0f/%.0f target=%s dist=%s pos=%.0f,%.0f,%.0f tween=%s collecting=%s",
os.clock(), hum.Health, hum.MaxHealth, tostring(state.statusTarget),
tRoot and string.format("%.1f", (root.Position - tRoot.Position).Magnitude) or "-",
root.Position.X, root.Position.Y, root.Position.Z, tostring(state.activeTween ~= nil), tostring(state.collectingChests or state.questlineBusy)))
if #deathTrace > 16 then table.remove(deathTrace, 1) end
end
task.wait(0.5)
end
end)
local function hookDeathLog(char)
local hum = char and char:WaitForChild("Humanoid", 10)
if not hum then return end
track(hum.Died:Connect(function()
if not state.alive then return end
local root = char:FindFirstChild("HumanoidRootPart")
local pos = root and root.Position
logLine("DEATH", string.format("died | pos=%s | farm=%s boss=%s target=%s", pos and string.format("%.0f,%.0f,%.0f", pos.X, pos.Y, pos.Z) or "?", tostring(config.autoFarm), tostring(config.autoFarmWorldBoss), tostring(state.statusTarget)))
logLine("DEATH", "trace (last 8 s, every 0.5 s)")
for _, line in ipairs(deathTrace) do logLine("DEATH", line) end
table.clear(deathTrace)
end))
end
if player.Character then task.spawn(hookDeathLog, player.Character) end
state.deathLogConn = track(player.CharacterAdded:Connect(hookDeathLog))
local function isAntiCheatKick(reason)
local r = string.lower(reason or "")
return r:find("267", 1, true) ~= nil or r:find("suspicious", 1, true) ~= nil
end
pcall(function()
local robloxPromptGui = CoreGui:WaitForChild("RobloxPromptGui", 4)
local promptOverlay = robloxPromptGui and robloxPromptGui:WaitForChild("promptOverlay", 4)
if not promptOverlay then return end
track(promptOverlay.ChildAdded:Connect(function(child)
if child.Name ~= "ErrorPrompt" and not child:FindFirstChild("ErrorTitle") then return end
if state.disconnectHandled then return end
state.disconnectHandled = true
task.wait(0.5)
local reason = ""
pcall(function()
for _, d in ipairs(child:GetDescendants()) do
if d:IsA("TextLabel") and #d.Text > #reason then reason = d.Text end
end
end)
local kicked = isAntiCheatKick(reason)
logLine("DISCONNECT", "หลุดจากห้อง: " .. reason .. " | autoRejoin=" .. tostring(config.autoRejoin) .. " antiCheat=" .. tostring(kicked))
if kicked then
logLine("DISCONNECT", "anti-cheat kick → ไม่เข้าเกมใหม่ ไม่รันต่อ")
setFlagFile(KICKED_FILE, true)
RL.Flush()
if config.discordNotifyHop then
sendDiscordWebhook("⛔ โดนเตะ (Suspicious activity)", string.format("ผู้เล่น **%s** ถูกเกมเตะออก (267) ระบบหยุดเข้าเกมใหม่อัตโนมัติ", player.Name), 15158332, {})
end
return
end
queueReexecute("disconnect")
if not config.autoRejoin then return end
if config.discordNotifyHop then
sendDiscordWebhook("⚠️ หลุดการเชื่อมต่อ (Disconnected)",
string.format("ผู้เล่น **%s** หลุดจากห้อง ระบบกำลังเข้าเกมใหม่อัตโนมัติ...", player.Name),
15158332,
{
{name = "👤 ผู้เล่น", value = player.Name, inline = true},
{name = "⚠️ สาเหตุ", value = reason:sub(1, 200), inline = false}
}
)
end
task.wait(2)
safe("REJOIN", function() TeleportService:Teleport(game.PlaceId, player) end)
end))
end)
track(player.OnTeleport:Connect(function(teleportState)
if teleportState == Enum.TeleportState.Started then
queueReexecute("teleport")
elseif teleportState == Enum.TeleportState.Failed then
state.teleportQueued = false
end
end))
if config.autoReexecute and not (queueTeleport and reexecuteCode()) then
logLine("SESSION", "re-execute unavailable: queue=" .. tostring(queueTeleport ~= nil) .. " loader=" .. tostring(LOADER_URL ~= "") .. " file=" .. AUTOLOAD_FILE)
end
local DukeGUI = (function(...)
local S = ...
local DukeGUI = {
Options = {},
Folder = "DukeGUI",
GetService = function(service)
return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
end,
}
local TweenService = DukeGUI.GetService("TweenService")
local HttpService = DukeGUI.GetService("HttpService")
local UserInputService = DukeGUI.GetService("UserInputService")
local RunService = DukeGUI.GetService("RunService")
local Players = DukeGUI.GetService("Players")
local LocalPlayer = Players.LocalPlayer
local isStudio = RunService:IsStudio()
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local T = {
header = rgb(28, 34, 32), headerLine = rgb(57, 67, 60),
sidebar = rgb(21, 27, 25), sidebarLine = rgb(53, 64, 57),
content = rgb(12, 17, 15), windowStroke = rgb(69, 81, 71),
card = rgb(30, 37, 34), cardStroke = rgb(58, 69, 61),
nested = rgb(39, 48, 43),
danger = rgb(42, 28, 31), dangerLine = rgb(74, 44, 48), dangerText = rgb(245, 138, 128), dangerOn = rgb(208, 88, 76),
text = rgb(224, 229, 217), bright = rgb(247, 249, 243), white = rgb(255, 255, 255), ink = rgb(19, 26, 10),
sub = rgb(171, 186, 175), muted = rgb(133, 151, 137), value = rgb(222, 238, 209), log = rgb(191, 210, 192),
nav = rgb(201, 215, 204), navActive = rgb(191, 235, 57), navHover = rgb(44, 55, 48), group = rgb(160, 185, 147),
input = rgb(43, 52, 47), inputStroke = rgb(72, 85, 74),
search = rgb(34, 43, 38), searchStroke = rgb(65, 78, 68), placeholder = rgb(146, 165, 148),
accent = rgb(191, 235, 57), primary = rgb(191, 235, 57), off = rgb(61, 76, 64), knobOff = rgb(190, 207, 192),
bar = rgb(191, 235, 57), barStroke = rgb(211, 248, 103), sep = rgb(89, 106, 76),
warnBg = rgb(43, 38, 24), warnText = rgb(236, 208, 138),
tagBg = rgb(58, 76, 42), tagText = rgb(218, 249, 136),
icon = rgb(180, 207, 166), dotHollow = rgb(74, 94, 77),
avatarBg = rgb(49, 64, 54), avatarStroke = rgb(111, 145, 97),
scroll = rgb(103, 129, 95), chrome = rgb(50, 61, 54),
rail = rgb(57, 72, 61), railLine = rgb(93, 120, 87),
}
local TONES = { run = T.accent, wait = rgb(224, 181, 79), done = rgb(158, 205, 91), bad = rgb(240, 113, 103), off = rgb(127, 143, 111) }
local FONT_DIR = "DukeGUI/fonts"
local FONT_URL = "https://raw.githubusercontent.com/IBM/plex/master/packages/"
local function fontFamily(name, package, faces)
if not (getcustomasset and writefile and isfile) then return nil end
local ok, id = pcall(function()
if makefolder and isfolder then
if not isfolder("DukeGUI") then makefolder("DukeGUI") end
if not isfolder(FONT_DIR) then makefolder(FONT_DIR) end
end
local list = {}
for _, face in ipairs(faces) do
local file = name .. "-" .. face[1] .. ".ttf"
local path = FONT_DIR .. "/" .. file
if not isfile(path) then
local req = request or http_request
local res = req and req({ Url = FONT_URL .. package .. "/fonts/complete/ttf/" .. file, Method = "GET" })
local body = res and res.Body
if type(body) ~= "string" or #body < 50000 or body:sub(1, 4) ~= "\0\1\0\0" then error("font download failed: " .. file) end
writefile(path, body)
end
list[#list + 1] = { name = face[1], weight = face[2], style = "normal", assetId = getcustomasset(path) }
end
local json = FONT_DIR .. "/" .. name .. ".json"
writefile(json, HttpService:JSONEncode({ name = name, faces = list }))
return getcustomasset(json)
end)
if not ok then warn("[DukeGUI] " .. tostring(id) .. " (using the fallback font)") end
return ok and id or nil
end
local SANS = fontFamily("IBMPlexSans", "plex-sans", { { "Regular", 400 }, { "Medium", 500 }, { "SemiBold", 600 }, { "Bold", 700 } })
local MONO = fontFamily("IBMPlexMono", "plex-mono", { { "Regular", 400 }, { "Medium", 500 } })
local SANS_ID = SANS or "rbxassetid://12187365364"
local FONT = {
regular = Font.new(SANS_ID, Enum.FontWeight.Medium),
medium = Font.new(SANS_ID, Enum.FontWeight.SemiBold),
semibold = Font.new(SANS_ID, Enum.FontWeight.Bold),
mono = MONO and Font.new(MONO, Enum.FontWeight.Medium) or Font.new("rbxasset://fonts/families/RobotoMono.json"),
}
DukeGUI.Fonts = FONT
DukeGUI.FontSource = SANS and "IBM Plex (custom)" or "Inter (fallback)"
local FONT_K = SANS and 1.29 or 1.21
local function fontPx(css) return math.floor(css * FONT_K + 0.5) end
DukeGUI.FontPx = fontPx
local ASSET = {
globe = "rbxassetid://108952102602834",
search = "rbxassetid://86737463322606",
}
local ICON_PNG = {
winMinimize = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAAAh0lEQVR42u3YsQ3CMBRF0RumgWVhPDJFMoJp0iKlQMKKzpPcuXhH/vqFlzFGV86tiwcQEBAQEBAQEBAQEBAQEBAQEBAQEPB7ntVWjT+f7ehyKsvJr/t79Z7scR7VakRP3lurV7VP0Hk/uqy/HFFbFBAQEBAQEBAQEBAQEBAQEBAQEBAQcI58AJpOMunsYbFbAAAAAElFTkSuQmCC",
winClose = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAABQklEQVR42u2aQW4CMQxF/3A6xKpIXVCxmlaVaA+E2FS9E+zpTfq7oWpUDRSj/DA131KWsf1iTxI705FEZpkguRjQgAY0oAENaEAD3hbgDMAOwBbAQwMfl4W9aXg2ycjoSH7wRz5J9kEdkbE62PiWfVTHJREsy48OwBuAXhC5FYD1wUZpTxpBkFxwWJ4rRu7liI37qK5aqVMzXavqHo0jKp1jWm1JVmAkKSVLedV2HnFQ+T1DeWad46gUrjZg1GE5nALwXMebwKkA/wJoBqcEPAXZDE4NeAySDS/rcsBTkHK4S6uJ/yVOUW8yt3dMpD7oU1/VUl+2U5dLqQve1C2L1E2n1G3D1I3f328TylvIUCSbv00QwBOAd0EdsAHwOvAWIq8m5sWK9g3qycfC3l10fud/1QxoQAMa0IAGNKABDXgl+QK1NI23WRiqkgAAAABJRU5ErkJggg==",
expand = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAACdUlEQVR42u2aT0sVURTAf+8VKPo0pFqlOxVMBAmtFkX2EMxcCC2iD9CqjRs/QPoB3LTzQ+im0qBeZFlYC9u4KBGFjDbRIsQ0yuvi3QHROzN33hu55w5zYDZn7jvzfnPO3PNnpqCUIstSJOOSA/ouZwX9l3agswYHDQE/gFng//EFBSGbzBJws04bP4GLEkO0LwU4gAvAPYmAByna6pIIuAa8TsnWhtRNpmyxyTQDM0C3r7votj5Mcg6oWMAVfMyDJQ13JYuJvgS8DIHb8h0wgLtmOPcZeOwzYFMM3C3gj6+ATcCLGLjfvj6DAdyNNOCkAaYOJwmwMQLuU61wUhJ9I/AsAq4M7Pja8AZw5dOAcw1YBOZD4FYs4NYMutUTGqWUq+O+MstHpVTJ0kblyO8WTGtcPoMPDLpl4E6CsCwDHcA/PbZA0sjiti6iA3kPDNtWKLbieiZzF3io4Z4A+2lfoJBPtnPAHDCTgA3AJDAHjLgEPI1NJpihDB7RXdWllygPtgOXEtpr0Z344DH9hLQQXQK+UR3jPU/guVchnXjFWYwa6rc+Q33YFVMTlpRSH0Jqy6dKqaKrmtfkwR6Drj/iHrVqD103nFuk+kLkAE/fD7YCb0JuQAUYB/76mibi4MZcw9UDaAO352uij4J7JwmuFsC2GLgRSXBJN5k24C3QGwG362st2hwBtyIVLokHp/XswwQ3LBUuiQej4HYge+2SF3BhIRrXP30FpoCBiDXrwHdfP+XqtuwwFqhOzcSF6OWUbI9i+DBHAuBmmt2Ya8CwkcUvndjrkUXtRZGAZ4BHwHnd3Sft574Q8q4gC0OnfC6aA+aA9nIIB1LtGh6kNRAAAAAASUVORK5CYII=",
globe = "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",
search = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAADaklEQVR42u2aXYiNQRjH/0dLLHY7Wh9Ly8Vu0qa48llaLuQrcYO9UYpcScmNyB1JSm4obpRESVm2kM8SsUK+RS7QirSLDqfdk/bnZi6217zv+ZqZtdt5ai7mOe87z/zOPO/MPPNMCtBQlmEa4lIBrABWACuAXqXKcXs1kpZJWiGpWVJa0jhTMpK+m9Ip6Yqki5I+eCUEXJTZwGVKk1fAJkf9+KeU20ADcBroo3x5Diz6nwCXAr9xLweBlCvAVIlbtS2SjhfwXEbSV0lfzPc4UVJdAe+dk7RuoL7BPXlGoB3YCtTHvF8NrAaOAt0J7dwDRod20daEDrUBzUW2VwPsS3D1tpCA84CcpRNZYG2ZHWkEXsdA7g8BOBL4aDH+GZjpaEIYC1yJgZzvG3B3zMjNcDytjwAeWGw99glYZ/lG+oCVnhbnOuMZUdnoC/CkxdhJXzsPU9ZYbHYCo1wDVlt2KTlgimdAxbhqa7Ht5IsmWiSlIroLZrPsW45YdItdh0stFt35QJHOJUk534AzI/WcpLZAgBlJ1yK6JknDXQJOitTfSOoJGK8+sujqXQJOjNS7AgfkXQX86WUBTo7UuwMD2uyNdwn4I1KvDQw4xqLrcQn4NY/L+habO34ZSoD1vgGfReoTJDUEBJwbqX8rdqLLB3jVomsNBNcoaVZE1+56ob8p6U9Et83DeapNdhb4h5d9JnPLsund7nmjPQ34YwnRanyES+ssgBlguie4KqDDYvOMz4j+ocXgeyDtAfCUxVbOjKo3wIUxZyV3SnGbhLI3xs7hEKdqB2KMvzOnYuWexZyNaf+pCbyDnIuejunET2BHiZ1YZfIScfISGBcyN3E9oTOfDGhTnjbSwPqYGdomT4DakLmJE5I253nmraQOSS/MjmiqyRnOkTSvBJuPJS2R9DNUfnC7Za1yITcTXPZhsSNZ7qzXDFx0BPYW2GBSZ2njljZ5BIwJBdg/b3GjRLD3MRnemgTI+4VCul6kG4BdJi2dJF3AMbO+5ss+dZQDWeokU4hU97uEUCsp2+8Swo8io/qrkhZYfntgJp6s70sIvsso4G7MSB4aqBH04RHtlsPfXyYt3jvYLwJlJS2XdDuivxsHNxhvOvWai0aHJPUZ2K1JLwwmF41Kg6RP+R4azICVy3gVwApgBXDg5S+Q6L0buhUOygAAAABJRU5ErkJggg==",
chevronRight = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAABZElEQVR42u2ZsUoDQRCGvwv6AjaXOgipLFSSImI6myCk8jF8Gt/CF7C1SRBMZxcl9R0WvoB4Fm5hsSvCzcxmYaa6vYHj/25n9/6dq7quo+QYUHg4gAM4gAM4QK84EHjGIXATru+BT0uAqueXuAKegGkYvwBXQFtKCS1/iQc4AdZAXfIaGFlCSJTQBjiL5N6AS6DZ5xnogAWwi+SOgZX2TEiUUAvMEhDq5SS1BrJBSC7iLBDSu5A5hMY2agqh5YXMIDTNnAmEthttgQtgm4B4KMFON8A8MROnwHUp54H3xP2vnF7oPzEEHoFxJLcBJrkPNH9FHfzQKJLb9S0f7RKqw06TEj+TOPgMShavBWAmXgPAVLw0gLl4SYAs4qUAsomXAKiCn4mJ3wYf1O5zZ24Z/Ezszc8tGlwa26h62Uj3hZ6B8zB+DW++gTJ6owBHwC0/PaI74IOCmrv4/wEHcAAHcAAHyBnfzAdlx/aChz4AAAAASUVORK5CYII=",
chevronUpDown = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAABqElEQVR42u2Zv07DMBDGf6ngBViSGQYWnoAuLGwMLDwGT8Nb8AwMVKoq/pQOdGqjdCYTL4B0LB4sZIfGOYem+KQoje1cv88+2XdfMhFhyDZi4JYIJAId7SCi70Pgxvy+B75i/EkWaRfKgQfgzDwvgUugHgKBHJgBxz/aN8C5NolRT+AxbTMzZicJFMDUA94mMTVjdyqEmmbeZWrhNFICP/GAX5vLtRITlXASkS5XLiKVuK0y/duMCcYQG3zI2F4IhACKQqIv8NFItAWficjCA2AlIsUWPgoz1mWL2ASulWavaSWu2mDS2EZD9vTavLPpexvNRGRuzdZ6y7BpCqe15e+lrY+Qk/gIuAUEuAM+O85hJ39ZKuoTgUQgERicKqGtNnTzF3CQPVsHz3vHfD4XkaXl7+kvcqHQVNiXD/WeC4WoDW1raNUQevNkkWWLdLr0+HhNBc1/KCn3oqjfGVlFI50ugEfg1NFXmfuJo28FXAAfSVpUsBoYe2REl9w41pLZtSuy31ZC/RuBdjbapDYM4gOHHU6l1VZqhk1fRb22epFUiUQgEdhHAt+yIuQ7ybWdaAAAAABJRU5ErkJggg==",
warning = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEW0lEQVR42u2bX4hVdRDHP7uu13bZ4AqrbA+mtBJkyPogSoTmg70UIab0IPYPgrSHWERDixDS/q9ZYriL9VAo0VIPRlFgTwnBWrAliA9bggrrBaNcU9e21enBCS6HmXvPufecPfeePQM/uHd+c+b8Zu53Zn5nfue2iAgzmVqZ4ZQ7IHdA7oDcAWnRIqAPWJumA1pSKoNF4BdgoX7/GVgDXJspCHi7zHiA5cC+mYKAXv31vblTWUfAgRrnMuGAjcDqCvMPAY9nNQQKwChwdxW580APMJU1BGwPYTwqsyNrCLgL+A3oCCl/XVFQygoC3nSMPwB8aPA7gLeyggCv7P0F3KOfzwJzDZllwK/NjoBBh/8qcFnH7ojXxkcikuTYLDadFpHWMrlWERl1ZDclucYkQ6Ad+F0TYJBWAycCvLXAcUP2oj44TTZbCLzsGP+VYTzA98DXTgV5pdmS4ALd9MwJ8P/V8nbBua4HOAPMDvD/URSUmgUB+wzjAd6vYDwaMtbzwBxgf7MgYAUwbPAvadm7WuX6Ti2L84y5lcDJRkeAV7p2lRlfAPoV0iX9XNC5qxVifrDRy+BzTikbCcj1GTJ9AZnTjq5n41xznAjoBN5w5p43dnhU4W2p0E1qb8QQ2O3E7ZARtx3OvqGcTgBfGHLzKuwcUwuBHhGZNOB6Q0S6DfkhQ/ZzQ26B6gjSpM41TAjsN2o3wDt11u4LmiCDNDu29lkMXlzlJKsxEWl3rgmLAFTHmHOPVWkjoBUYcOZ2ABMx/EYTwE5nbiDtJPgCsMTgDwNHY0ywnzo9hSXA1rQcUAReC1n24iBP5+tagqfdAXucLs4nCXVxTjqomgvsne4keJ+ITBlJ6ZqIdIW4PkoSLB/deo8gTWkpnrYkOADMcuD4R4I9hpLTLJ0FHJquEHjMOd0579RsEjhYvWjwHwYeSdoBbcB7zty2pNpWAZrk9nsFFn0Q1aaoDugDFhv8H4AvI+gZc3p/YWnI6TksBl5MKgl2icgVIwHd0qQYRVeviIyX6RhXXlQdt4z1XBGRYlg9UW542NmODtRYSbpFZI2O+TXq+MhZ06G42+K9wAjQEuD/ze3DzMukQ13aPrszCGzgfm2wxpIDBg3j/+8BpGU8WnL3WL3O0M8JIWDyhAOzURFpqxG6BRHpF5GSjn7l1aKrTUTOOWtcX28OKFRQ/mgdj6FheoJRxjpnjeeq/UjVQuAl56WG48A3dUB3WUheWDqmpRjjZYvtteaAbm1lB+lmvY+gIXuCUWmLrg3jFLqrFge86yz0oJ7g1EPXsd8XqIfOOOcGHWpLpCS4wompP0WkM4Y22npD97oY9BZ1jRb1RtkHDOsRV5A+Bo7EVMIe0AcYgO9iPPJ6Bnja4P8IPBjmbPApbWpkkTYBn1VzwClgaUYdMArcW80BE8AdZJeKwHilKjCSYeNHyo33HPAk8C1wI2PG/wRsaJQ/TJD/ZSZ3QO6A3AG5A3IH5A5Inf4DynHWYl2NjCkAAAAASUVORK5CYII=",
check = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAACSUlEQVR42u2asWtVMRSHv1cFUcHBJ4LQoXQoKiqIgy5qH3aQUlBqwa1OFlFXZ8U/QEEdpI6CQ6kgbS1d2qIudXARBycHEVxEqFqfUuXnEkXFm9x7X66veZwfZLk5ycuXnCTnhFeTRCeriw6XARqgARqgARqgARqgARpgBO0GngHLwI28jWqJZBN7gUWg/tu3u8BoJwD2AU+A7f+oOwFMpeyiPcB8BhzAnpT34A4H1+2xWUgVcKsbfK/H5iqwlOIe3OL23D6PzR1gLMVTdKODO+CxyXV6rkUX3QDMBeAeAGdSvOjXATPAEY/NLDACKDXALmASGPDYPAZOAt9TDNXuucFnaQk4DqymGIuOA6c99c/dyjarDrbrbqY/AE+BQxHgrgFnPfUvgAaw0tKvSAqVzZJe6k+tShrM0TarXJFfryRta6H/XyWP0VjGIMpCXgjAvZbUHQNOUi4XrWd8Xw88BIYLOMw54Jan/p1zyzfRdnmOWeiRtByY9eEc/YwG+ngvaVeslSviokjqV1g+yFOBtp8k7Y8NVwQQSUclffEMMmtPHnN1WVqRdLAKuKKAZSAPS2p67JvOhqpKmWyi372P+DQEvHWZwaYMm28uQpmvMpIomy418mTTAY0A99fqs+GiW8mvZQ5uF55VDtdqLPoIGCzR7jwwkcrD70LBlbwI3P6v4Xyk06oh6XPgrrtc5WkZ65ooe4XcbAdcbMCfK/nxL7jr7YIrew+G1OtyvZ3AJWC6nRl1zf7KZYAGaIAGaIAGaIAGaIAGWI1+ANybq13+Dx3MAAAAAElFTkSuQmCC",
cross = "iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAYAAACohjseAAAB+klEQVR42u3aMUsDMRTA8X8LznotBSdxEIdCKfgFRPCDin6D04JQEQTXCq3gorjo5lB0ULDKc8lB0faa3OXlasmDLDVc7gcvNu+lNRFhlaPOikcERmAERmAERmAEuseOGaGi8HquwAbQA+7NODOfaUULSKfWS81n9iEiLuNS/sZIRJqOz7EZDREZzFiv7/IclwW3ZH6MRCTxiEvm4LLYtH2WS4p+5PytA1wBiYe0TIALYG9e0gHvGnvwBThRRi7CARwDb1p7cMOkY14Mzf7xnZYiIs+uW6Ho/liEdN2TNrhBkX1e5p+AL6QargzQF1IVVxZYFqmO8wEsigyC8wV0RQbDiQg1j23DxHwPdnLm3AEToJsz5wY4BMY+XqrmuS9qgyQUTqMeHAP7wO0y4LQK3iJIFZxGiv5O12ugvWDeEDjQwIVoWUws5qz9x55MVhV0Lea2PZZaQYA2JY9mPakKLIJTRdYD44bmyz4cMlAPZfr4pVFPqh+2Xc+WwZBV4IIiq8IFQ1aJC4KsGqeOXAZcNpoaSNeX6FvgGiX2tQ3yXAu4HajNYJOuLY27iW9zL6Bdz9nUk58aR7Uncy8QoljNQx4Br1pHtXURSadSJfV8bTbrjrA3td6peQf1rlp2nfwQ6Ap7F/gCHpepZRF/ZRGBERiBERiBERiBuvED5+Xz9rjc2gIAAAAASUVORK5CYII=",
}
local function b64decode(data)
local dec = crypt and (crypt.base64decode or crypt.base64_decode)
if dec then return dec(data) end
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local map = {}
for i = 1, 64 do map[chars:sub(i, i)] = i - 1 end
local out, bits, n = {}, 0, 0
for c in data:gmatch("[%w%+/]") do
bits, n = bits * 64 + map[c], n + 6
if n >= 8 then
n = n - 8
out[#out + 1] = string.char(math.floor(bits / 2 ^ n) % 256)
bits = bits % 2 ^ n
end
end
return table.concat(out)
end
local ICON = {}
if getcustomasset and writefile then
local ok, err = pcall(function()
if makefolder and isfolder then
if not isfolder("DukeGUI") then makefolder("DukeGUI") end
if not isfolder("DukeGUI/icons") then makefolder("DukeGUI/icons") end
end
for name, data in pairs(ICON_PNG) do
local path = "DukeGUI/icons/" .. name .. ".png"
writefile(path, b64decode(data))
ICON[name] = getcustomasset(path)
end
end)
if not ok then warn("[DukeGUI] icons: " .. tostring(err)) end
end
local function mk(className, props, parent)
local obj = Instance.new(className)
if obj:IsA("GuiObject") then obj.BorderSizePixel = 0 end
for k, v in pairs(props or {}) do obj[k] = v end
if props and props.TextSize then obj.TextSize = fontPx(props.TextSize) end
if parent then obj.Parent = parent end
return obj
end
local function corner(parent, radius) return mk("UICorner", { CornerRadius = UDim.new(0, radius) }, parent) end
local function stroke(parent, color, thickness, outer)
local st = mk("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = color, Thickness = thickness or 1 }, parent)
pcall(function() st.BorderStrokePosition = outer and Enum.BorderStrokePosition.Outer or Enum.BorderStrokePosition.Inner end)
return st
end
local function padding(parent, top, right, bottom, left)
return mk("UIPadding", {
PaddingTop = UDim.new(0, top or 0), PaddingRight = UDim.new(0, right or 0),
PaddingBottom = UDim.new(0, bottom or 0), PaddingLeft = UDim.new(0, left or 0),
}, parent)
end
local function vlist(parent, gap)
return mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, gap or 0) }, parent)
end
local function hlist(parent, gap, valign, halign)
return mk("UIListLayout", {
SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, gap or 0),
VerticalAlignment = valign or Enum.VerticalAlignment.Center, HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
}, parent)
end
local function text(props, parent)
local base = {
BackgroundTransparency = 1, FontFace = FONT.regular, TextColor3 = T.text, TextSize = 13, RichText = true,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Text = "",
}
for k, v in pairs(props or {}) do base[k] = v end
return mk("TextLabel", base, parent)
end
local function tween(obj, time, props)
local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
t:Play()
return t
end
local function chevron(parent, kind, color, size)
size = size or 12
local holder = mk("Frame", { Name = "Chevron", BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size) }, parent)
local image = kind == "right" and ICON.chevronRight or ICON.chevronUpDown
if image then
local img = mk("ImageLabel", { BackgroundTransparency = 1, Image = image, ImageColor3 = color, Size = UDim2.fromScale(1, 1) }, holder)
if kind == "right" then
holder:SetAttribute("Open", false)
holder:GetAttributeChangedSignal("Open"):Connect(function()
img.Rotation = holder:GetAttribute("Open") == true and 90 or 0
end)
end
return holder
end
local k = size / 12
local function bar(cx, cy, len, rot)
local b = mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx * k, cy * k),
Size = UDim2.fromOffset(len * k, 1.6), Rotation = rot, BackgroundColor3 = color,
}, holder)
corner(b, 1)
return b
end
if kind == "right" then
local b1, b2 = bar(6, 4.5, 4.6, 45), bar(6, 7.5, 4.6, -45)
holder:SetAttribute("Open", false)
holder:GetAttributeChangedSignal("Open"):Connect(function()
local open = holder:GetAttribute("Open") == true
b1.Position = UDim2.fromOffset((open and 4.5 or 6) * k, (open and 6 or 4.5) * k)
b2.Position = UDim2.fromOffset((open and 7.5 or 6) * k, (open and 6 or 7.5) * k)
end)
else
bar(4.75, 3.25, 3.9, -45)
bar(7.25, 3.25, 3.9, 45)
bar(4.75, 8.75, 3.9, 45)
bar(7.25, 8.75, 3.9, -45)
end
return holder
end
local function guiHost()
if isStudio then return LocalPlayer:FindFirstChild("PlayerGui") end
local ok, h = pcall(function() return gethui and gethui() end)
if ok and h then return h end
return DukeGUI.GetService("CoreGui")
end
local libConnections = {}
local function track(c)
libConnections[#libConnections + 1] = c
return c
end
local function fmtNumber(value, precision)
precision = precision or 0
if precision <= 0 then return tostring(math.floor(value + 0.5)) end
return string.format("%." .. precision .. "f", value)
end
local function newRow(card, opts)
opts = opts or {}
local row = mk("Frame", {
Name = opts.name or "Row", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = card.nextOrder(),
}, card.frame)
local bg = mk("Frame", { Name = "Bg", BackgroundColor3 = T.nested, Size = UDim2.fromScale(1, 1), ZIndex = 1 }, row)
corner(bg, 12)
local edge = stroke(bg, T.cardStroke)
local body = mk("Frame", { Name = "Body", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2 }, row)
local bodyPad = padding(body, 1 + (opts.padTop or 9), opts.padRight or 12, opts.padBottom or 9, opts.padLeft or 16)
vlist(body, 0)
local main = mk("Frame", {
Name = "Main", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, opts.minHeight or 30),
AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, ZIndex = 2,
}, body)
local mainLayout = hlist(main, 16)
local r = { frame = row, body = body, main = main, nested = false, danger = false }
local baseLeft = opts.padLeft or 16
function r.paint()
bg.BackgroundColor3 = r.danger and T.danger or (r.nested and T.nested:Lerp(T.accent, 0.04) or T.nested)
edge.Color = r.danger and T.dangerLine or T.cardStroke
bodyPad.PaddingLeft = UDim.new(0, baseLeft + (r.nested and 14 or 0))
end
r.want = true
function r.setVisible(on)
r.want = on ~= false
row.Visible = r.want and not card.collapsed
end
function r.setNested(on)
r.nested = on == true
r.paint()
end
function r.addLabel(name, description, danger)
local col = mk("Frame", { Name = "Left", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, ZIndex = 2 }, main)
vlist(col, 2)
local nameLabel = text({
Name = "Name", Text = name or "", TextSize = 14, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y,
Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 1, ZIndex = 2,
TextColor3 = danger and T.dangerText or T.text, FontFace = danger and FONT.medium or FONT.regular,
}, col)
local descLabel = text({
Name = "Description", Text = description or "", TextSize = 12, LineHeight = 1.4 / 1.3, TextWrapped = true, TextColor3 = T.sub,
AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 17), LayoutOrder = 2, Visible = (description or "") ~= "", ZIndex = 2,
}, col)
r.left, r.nameLabel, r.descLabel = col, nameLabel, descLabel
if danger then
r.danger = true
r.paint()
end
return nameLabel, descLabel
end
function r.setRight(ctrl)
ctrl.LayoutOrder = 2
ctrl.Parent = main
local function fit()
local narrow = main.AbsoluteSize.X > 0 and main.AbsoluteSize.X < 420
mainLayout.FillDirection = narrow and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
mainLayout.VerticalAlignment = narrow and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center
mainLayout.Padding = UDim.new(0, narrow and 8 or 16)
if r.left then r.left.Size = UDim2.new(1, narrow and 0 or -(ctrl.AbsoluteSize.X + 16), 0, 0) end
end
ctrl:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
main:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
fit()
end
r.paint()
row.Visible = not card.collapsed
card.rows[#card.rows + 1] = r
return r
end
local function rowApi(r, obj)
function obj:SetVisibility(on) r.setVisible(on) end
function obj:SetNested(on) r.setNested(on) end
obj.Row = r
return obj
end
local function newCard(W, tab)
local frame = mk("Frame", {
Name = "Section", BackgroundColor3 = T.card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = tab.nextOrder(),
}, tab.page)
corner(frame, 18)
stroke(frame, T.cardStroke)
mk("UIGradient", { Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, T.card:Lerp(T.accent, 0.025)),
ColorSequenceKeypoint.new(1, T.card),
}), Rotation = 30 }, frame)
padding(frame, 8, 8, 8, 8)
vlist(frame, 6)
local card = { frame = frame, rows = {}, order = 0, collapsed = false }
function card.nextOrder()
card.order = card.order + 1
return card.order
end
function card.setCollapsed(on)
card.collapsed = on == true
for _, r in ipairs(card.rows) do r.frame.Visible = r.want and not card.collapsed end
end
local function index(s) if s and s ~= "" then tab.index(s) end end
local SF = {}
function SF:Header(Settings)
local collapsible = Settings.Collapsible == true
local head = mk(collapsible and "TextButton" or "Frame", {
Name = "Header", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 0,
}, frame)
if collapsible then head.Text = "" head.AutoButtonColor = false end
padding(head, 14, 16, 12, 16)
vlist(head, 4)
local titleRow = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 1 }, head)
local sectionMark = mk("Frame", { Name = "SectionMark", BackgroundColor3 = T.accent, Position = UDim2.fromOffset(0, 7), Size = UDim2.fromOffset(8, 8) }, titleRow)
corner(sectionMark, 4)
local title = text({ Name = "HeaderText", Text = Settings.Text or Settings.Name or "", FontFace = FONT.semibold, TextSize = 15, TextColor3 = T.bright, Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -18, 1, 0) }, titleRow)
if Settings.Tag then
local tag = text({
Name = "Tag", Text = Settings.Tag, TextSize = 11, FontFace = FONT.medium, TextColor3 = T.tagText, BackgroundTransparency = 0,
BackgroundColor3 = T.tagBg, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 18),
AnchorPoint = Vector2.new(0, 0.5), TextXAlignment = Enum.TextXAlignment.Center,
}, titleRow)
corner(tag, 9)
padding(tag, 0, 7, 0, 7)
local function place() tag.Position = UDim2.new(0, title.TextBounds.X + 40, 0.5, 0) end
title:GetPropertyChangedSignal("TextBounds"):Connect(place)
place()
end
local desc = text({
Name = "HeaderDescription", Text = Settings.Description or "", TextSize = 12.5, LineHeight = 1.45 / 1.3, TextColor3 = T.sub, TextWrapped = true,
AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 2, Visible = (Settings.Description or "") ~= "",
}, head)
index(Settings.Name) index(Settings.Description)
local HF = { Settings = Settings }
local descText = Settings.Description or ""
function HF:UpdateName(v) title.Text = v end
function HF:UpdateDescription(v)
descText = v or ""
desc.Text = descText
desc.Visible = descText ~= "" and not card.collapsed
end
function HF:SetVisibility(on) head.Visible = on end
if collapsible then
local chev = chevron(titleRow, "right", T.sub, 12)
chev.AnchorPoint, chev.Position = Vector2.new(1, 0.5), UDim2.new(1, 0, 0.5, 0)
local summary = text({
Name = "Summary", Text = "", TextSize = 12.5, TextColor3 = T.sub, AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -22, 0.5, 0), AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20),
TextXAlignment = Enum.TextXAlignment.Right, Visible = false,
}, titleRow)
local function apply()
chev:SetAttribute("Open", not card.collapsed)
summary.Visible = card.collapsed and summary.Text ~= ""
desc.Visible = descText ~= "" and not card.collapsed
end
function HF:SetCollapsed(on)
card.setCollapsed(on)
apply()
end
function HF:IsCollapsed() return card.collapsed end
function HF:SetSummary(t)
summary.Text = t or ""
apply()
end
HF.UpdateSummary = HF.SetSummary
head.MouseEnter:Connect(function() title.TextColor3 = T.bright end)
head.MouseLeave:Connect(function() title.TextColor3 = T.bright end)
head.MouseButton1Click:Connect(function()
HF:SetCollapsed(not card.collapsed)
if Settings.OnCollapse then task.spawn(Settings.OnCollapse, card.collapsed) end
end)
HF:SetCollapsed(Settings.Collapsed == true)
end
return HF
end
function SF:Toggle(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name, Settings.Description, Settings.Danger)
index(Settings.Name) index(Settings.Description)
local button = mk("TextButton", { Name = "Switch", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(52, 36) })
local track = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(40, 24), BackgroundColor3 = T.off }, button)
corner(track, 12)
local knob = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(18, 18), BackgroundColor3 = T.knobOff }, track)
corner(knob, 9)
r.setRight(button)
local TF = rowApi(r, { Settings = Settings, Class = "Toggle", IgnoreConfig = false, State = Settings.Default == true })
local function render(animate)
local on = TF.State == true
local trackColor = on and (Settings.Danger and T.dangerOn or T.accent) or T.off
local knobPos = UDim2.new(0, on and 19 or 3, 0.5, 0)
local knobColor = on and T.white or T.knobOff
if animate then
tween(track, 0.15, { BackgroundColor3 = trackColor })
tween(knob, 0.15, { Position = knobPos, BackgroundColor3 = knobColor })
else
track.BackgroundColor3, knob.Position, knob.BackgroundColor3 = trackColor, knobPos, knobColor
end
end
function TF:UpdateState(state)
TF.State = state == true
render(true)
if Settings.Callback then Settings.Callback(TF.State) end
end
function TF:Toggle() TF:UpdateState(not TF.State) end
function TF:GetState() return TF.State end
function TF:UpdateName(v) Settings.Name = v nameLabel.Text = v end
button.MouseButton1Click:Connect(function() TF:Toggle() end)
render(false)
if Flag then DukeGUI.Options[Flag] = TF end
return TF
end
function SF:Slider(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name, Settings.Description)
index(Settings.Name) index(Settings.Description)
local holder = mk("Frame", { Name = "Slider", BackgroundTransparency = 1, Size = UDim2.fromOffset(230, 24) })
local rail = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 1, 0.5, 0), Size = UDim2.new(1, -54, 0, 8), BackgroundColor3 = T.rail }, holder)
corner(rail, 4)
stroke(rail, T.railLine, 1)
local fill = mk("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = T.accent }, rail)
corner(fill, 4)
local knob = mk("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 7, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = T.accent, ZIndex = 3 }, rail)
corner(knob, 7)
local valueLabel = text({
AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(44, 20),
TextXAlignment = Enum.TextXAlignment.Right, FontFace = FONT.mono, TextSize = 12.5, TextColor3 = T.text,
}, holder)
local hit = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, -44, 1, 0), ZIndex = 4 }, holder)
r.setRight(holder)
local minimum, maximum = Settings.Minimum or 0, Settings.Maximum or 100
local precision = Settings.Precision or 0
local SL = rowApi(r, { Settings = Settings, Class = "Slider", IgnoreConfig = false })
local function setValue(v, fire)
v = tonumber(v) or minimum
v = math.clamp(v, minimum, maximum)
local mult = 10 ^ precision
v = math.floor(v * mult + 0.5) / mult
local frac = maximum > minimum and (v - minimum) / (maximum - minimum) or 0
fill.Size = UDim2.new(frac, 7 - 14 * frac, 1, 0)
knob.Position = UDim2.new(frac, 7 - 14 * frac, 0.5, 0)
valueLabel.Text = (Settings.Prefix or "") .. fmtNumber(v, precision) .. (Settings.Suffix or "")
local changed = SL.Value ~= v
SL.Value = v
if fire and changed and Settings.Callback then task.spawn(Settings.Callback, v) end
end
local dragging = false
local function fromX(x)
local frac = math.clamp((x - rail.AbsolutePosition.X) / math.max(1, rail.AbsoluteSize.X), 0, 1)
setValue(minimum + frac * (maximum - minimum), true)
end
hit.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
fromX(input.Position.X)
end
end)
track(UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
fromX(input.Position.X)
end
end))
track(UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end))
function SL:UpdateValue(v) setValue(v, false) end
function SL:GetValue() return SL.Value end
function SL:UpdateName(v) Settings.Name = v nameLabel.Text = v end
setValue(Settings.Default or minimum, false)
if Flag then DukeGUI.Options[Flag] = SL end
return SL
end
function SF:Dropdown(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name, Settings.Description)
index(Settings.Name) index(Settings.Description)
local multi = Settings.Multi == true
local box = mk("TextButton", {
Name = "Select", Text = "", AutoButtonColor = false, BackgroundColor3 = T.input,
Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, ClipsDescendants = true,
})
corner(box, 11)
local boxStroke = stroke(box, T.inputStroke)
padding(box, 0, 8, 0, 11)
hlist(box, 8)
local valueText = text({
Name = "Value", Text = "", TextSize = 13, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 32),
TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1,
}, box)
mk("UISizeConstraint", { MaxSize = Vector2.new(230, 32) }, valueText)
chevron(box, "updown", T.sub, 12).LayoutOrder = 2
r.setRight(box)
local panel = mk("Frame", { Name = "Options", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Visible = false }, r.body)
padding(panel, 8, 0, 2, 0)
vlist(panel, 6)
local searchBox
if Settings.Search then
searchBox = mk("TextBox", {
Name = "Search", Text = "", PlaceholderText = "Search...", PlaceholderColor3 = T.placeholder, ClearTextOnFocus = false,
BackgroundColor3 = T.search, TextColor3 = T.text, FontFace = FONT.regular, TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 1,
}, panel)
corner(searchBox, 7)
stroke(searchBox, T.searchStroke)
padding(searchBox, 0, 10, 0, 10)
end
local list = mk("ScrollingFrame", {
Name = "List", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 3, ScrollBarImageColor3 = T.scroll, ScrollingDirection = Enum.ScrollingDirection.Y, LayoutOrder = 2,
}, panel)
vlist(list, 2)
local DF = rowApi(r, { Settings = Settings, Class = "Dropdown", IgnoreConfig = false })
local options, objs, Selected = {}, {}, {}
local function resize()
local shown = 0
for _, name in ipairs(options) do if objs[name] and objs[name].button.Visible then shown = shown + 1 end end
list.Size = UDim2.new(1, 0, 0, math.min(shown * 32, 224))
end
local function paintOptions()
for name, o in pairs(objs) do
local on = table.find(Selected, name) ~= nil
o.button.BackgroundTransparency = on and 0 or 1
o.label.TextColor3 = on and T.white or T.text
o.label.FontFace = on and FONT.medium or FONT.regular
end
end
local function refreshText()
if #Selected > 0 then
valueText.Text = table.concat(Selected, ", ")
else
valueText.Text = multi and "None" or "..."
end
paintOptions()
end
local function fire()
if not Settings.Callback then return end
if multi then
local out = {}
for _, n in ipairs(Selected) do out[n] = true end
Settings.Callback(out)
else
Settings.Callback(Selected[1])
end
end
local function setOpen(open)
if open and W.openDropdown and W.openDropdown ~= DF then pcall(W.openDropdown.Close, W.openDropdown) end
panel.Visible = open
boxStroke.Color = open and T.accent or T.inputStroke
W.openDropdown = open and DF or (W.openDropdown ~= DF and W.openDropdown or nil)
if open and searchBox then searchBox.Text = "" end
resize()
end
function DF:Close() setOpen(false) end
local function addOption(name)
if objs[name] then return end
local button = mk("TextButton", {
Name = "Option", Text = "", AutoButtonColor = false, BackgroundColor3 = T.navActive, BackgroundTransparency = 1,
Size = UDim2.new(1, -6, 0, 30), LayoutOrder = #options + 1,
}, list)
corner(button, 6)
local label = text({ Text = tostring(name), TextSize = 13, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0), TextTruncate = Enum.TextTruncate.AtEnd }, button)
button.MouseEnter:Connect(function() if not table.find(Selected, name) then button.BackgroundTransparency = 0.6 end end)
button.MouseLeave:Connect(function() if not table.find(Selected, name) then button.BackgroundTransparency = 1 end end)
button.MouseButton1Click:Connect(function()
if multi then
local i = table.find(Selected, name)
if i then table.remove(Selected, i) else table.insert(Selected, name) end
DF.Value = Selected
refreshText()
fire()
else
Selected = { name }
DF.Value = name
refreshText()
setOpen(false)
fire()
end
end)
options[#options + 1] = name
objs[name] = { button = button, label = label }
end
box.MouseButton1Click:Connect(function() setOpen(not panel.Visible) end)
if searchBox then
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
local q = string.lower(searchBox.Text)
for name, o in pairs(objs) do o.button.Visible = q == "" or string.find(string.lower(tostring(name)), q, 1, true) ~= nil end
resize()
end)
end
function DF:UpdateSelection(sel)
if sel == nil then return end
local picked = {}
if type(sel) == "number" then
if options[sel] then picked = { options[sel] } end
elseif type(sel) == "string" then
if objs[sel] then picked = { sel } end
elseif type(sel) == "table" then
for _, n in ipairs(options) do if table.find(sel, n) then picked[#picked + 1] = n end end
end
Selected = picked
DF.Value = multi and Selected or Selected[1]
refreshText()
fire()
end
function DF:InsertOptions(newOptions)
for _, n in ipairs(newOptions or {}) do addOption(n) end
Settings.Options = options
resize()
end
function DF:ClearOptions()
for _, o in pairs(objs) do o.button:Destroy() end
options, objs, Selected = {}, {}, {}
DF.Value = multi and Selected or nil
refreshText()
resize()
end
function DF:RemoveOptions(remove)
for _, n in ipairs(remove or {}) do
if objs[n] then objs[n].button:Destroy() objs[n] = nil end
local i = table.find(options, n)
if i then table.remove(options, i) end
local j = table.find(Selected, n)
if j then table.remove(Selected, j) end
end
refreshText()
resize()
end
function DF:GetOptions()
local out = {}
for _, n in ipairs(options) do out[n] = table.find(Selected, n) ~= nil end
return out
end
function DF:IsOption(n) return objs[n] ~= nil end
function DF:UpdateName(v) Settings.Name = v nameLabel.Text = v end
DF:InsertOptions(Settings.Options or {})
local default = Settings.Default
if multi then
if type(default) == "table" then
for _, n in ipairs(options) do if table.find(default, n) then Selected[#Selected + 1] = n end end
end
DF.Value = Selected
else
if type(default) == "number" and options[default] then Selected = { options[default] }
elseif type(default) == "string" and objs[default] then Selected = { default } end
DF.Value = Selected[1]
end
refreshText()
if Flag then DukeGUI.Options[Flag] = DF end
return DF
end
function SF:EggPicker(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name, Settings.Description)
index(Settings.Name) index(Settings.Description)
local box = mk("TextButton", {
Name = "Select", Text = "", AutoButtonColor = false, BackgroundColor3 = T.input,
Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, ClipsDescendants = true,
})
corner(box, 11)
local boxStroke = stroke(box, T.inputStroke)
padding(box, 0, 8, 0, 11)
hlist(box, 8)
local valueText = text({
Name = "Value", Text = "", TextSize = 13, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 32),
TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1,
}, box)
mk("UISizeConstraint", { MaxSize = Vector2.new(230, 32) }, valueText)
chevron(box, "right", T.sub, 12).LayoutOrder = 2
r.setRight(box)
local items = Settings.Items or {}
local selected = {}
for _, n in ipairs(Settings.Default or {}) do selected[n] = true end
local shade = mk("TextButton", {
Name = "EggPicker", Text = "", AutoButtonColor = false, BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 0.45,
Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 30,
}, W.Base)
corner(shade, 12)
local panel = mk("Frame", {
BackgroundColor3 = T.content, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.new(1, -40, 1, -40), ZIndex = 31,
}, shade)
corner(panel, 10)
stroke(panel, T.cardStroke)
local head = mk("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 12), Size = UDim2.new(1, -36, 0, 30), ZIndex = 31 }, panel)
text({ Text = Settings.Name or "", FontFace = FONT.semibold, TextSize = 15, Size = UDim2.new(1, -120, 1, 0), ZIndex = 31 }, head)
local countLabel = text({
Text = "", TextSize = 12.5, TextColor3 = T.sub, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -40, 0, 0),
Size = UDim2.fromOffset(120, 30), TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 31,
}, head)
local close = mk("TextButton", {
Text = "", AutoButtonColor = false, BackgroundColor3 = T.input, AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(28, 28), ZIndex = 32,
}, head)
corner(close, 14)
stroke(close, T.inputStroke)
if ICON.cross then
mk("ImageLabel", { BackgroundTransparency = 1, Image = ICON.cross, ImageColor3 = T.text, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 33 }, close)
else
close.Text, close.FontFace, close.TextColor3 = "X", FONT.semibold, T.text
close.TextSize = fontPx(12)
end
local tabBar = mk("ScrollingFrame", {
BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 50), Size = UDim2.new(1, -36, 0, 36), CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingDirection = Enum.ScrollingDirection.X, ScrollBarThickness = 2,
ScrollBarImageColor3 = T.scroll, ZIndex = 31,
}, panel)
hlist(tabBar, 6)
local grid = mk("ScrollingFrame", {
BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 94), Size = UDim2.new(1, -36, 1, -108), CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 3,
ScrollBarImageColor3 = T.scroll, ZIndex = 31,
}, panel)
padding(grid, 2, 6, 8, 2)
local twoLines = Settings.InfoLines == 2
local partsH = Settings.Parts and 20 or 0
for _, it in ipairs(Settings.Items or {}) do if it.Parts then partsH = 20 end end
mk("UIGridLayout", { CellSize = UDim2.fromOffset(118, (twoLines and 166 or 150) + partsH), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
local EP = rowApi(r, { Settings = Settings, Class = "EggPicker", IgnoreConfig = false })
local cards, tabButtons, currentTab = {}, {}, "All"
local pendingModels, setOpen = {}, nil

local function list()
local out, seen = {}, {}
for _, it in ipairs(items) do
if selected[it.Name] then out[#out + 1] = it.Name seen[it.Name] = true end
end
for name in pairs(selected) do
if not seen[name] then out[#out + 1] = name end
end
return out
end
local function paint()
local names = list()
valueText.Text = #names > 0 and table.concat(names, ", ") or (Settings.Single and "..." or "None")
countLabel.Text = (#names > 0 and not Settings.Single) and (#names .. " selected") or ""
for name, c in pairs(cards) do
local on = selected[name] == true
c.frame.BackgroundColor3 = on and T.navActive or T.card
c.stroke.Color = on and T.accent or (c.toneColor or T.cardStroke)
c.check.Visible = on
end
EP.Value = names
end
local function showTab(rarity)
currentTab = rarity
for name, b in pairs(tabButtons) do
local on = name == rarity
b.BackgroundColor3 = on and T.primary or T.input
b.TextColor3 = on and T.ink or T.nav
b.FontFace = on and FONT.medium or FONT.regular
end
for _, c in pairs(cards) do c.frame.Visible = rarity == "All" or c.rarity == rarity end
grid.CanvasPosition = Vector2.zero
end
local function fire()
if Settings.Callback then task.spawn(Settings.Callback, list()) end
end
local function drawParts(row, parts)
for _, c in ipairs(row:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
for j, p in ipairs(parts or {}) do
if p.Image and p.Image ~= "" then
mk("ImageLabel", { BackgroundTransparency = 1, Image = p.Image, ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromOffset(15, 15), LayoutOrder = j * 2 - 1, ZIndex = 33 }, row)
end
text({ Text = p.Text or "", TextSize = 11, TextColor3 = T.sub, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 18), LayoutOrder = j * 2, ZIndex = 33 }, row)
end
end
local rarities = { "All" }
for _, rr in ipairs(Settings.Rarities or {}) do rarities[#rarities + 1] = rr end
for i, rarity in ipairs(rarities) do
local b = mk("TextButton", {
Text = rarity, AutoButtonColor = false, FontFace = FONT.regular, TextSize = 13, TextColor3 = T.nav,
BackgroundColor3 = T.input, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 30), LayoutOrder = i, ZIndex = 32,
}, tabBar)
corner(b, 11)
padding(b, 0, 14, 0, 14)
b.MouseButton1Click:Connect(function() showTab(rarity) end)
tabButtons[rarity] = b
end
for i, it in ipairs(items) do
local img
local f = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = T.card, LayoutOrder = i, ZIndex = 32 }, grid)
corner(f, 10)
local st = stroke(f, T.cardStroke)
if it.Model then
local vp = mk("ViewportFrame", {
BackgroundTransparency = 1, Ambient = rgb(170, 170, 175), LightColor = T.white, LightDirection = Vector3.new(-1, -1, -1),
AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(96, 90), ZIndex = 33,
}, f)
pendingModels[#pendingModels + 1] = function()
local source = type(it.Model) == "function" and it.Model() or it.Model
local m = source and source:Clone()
if not m then return end
for _, d in ipairs(m:GetDescendants()) do
if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("ParticleEmitter") then d:Destroy() end
end
m.Parent = vp
local cf, size = m:GetBoundingBox()
local root = m:FindFirstChild("HumanoidRootPart")
local look = root and root.CFrame.LookVector or cf.LookVector
local cam = mk("Camera", { FieldOfView = 40 }, vp)
local dist = math.max(size.Y, size.X * 0.7, 4) * 1.5
cam.CFrame = CFrame.lookAt(cf.Position + look * dist + Vector3.new(0, size.Y * 0.1, 0), cf.Position)
vp.CurrentCamera = cam
end
else
img = mk("ImageLabel", {
BackgroundTransparency = 1, Image = it.Image or "", ScaleType = Enum.ScaleType.Fit,
AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14), Size = UDim2.fromOffset(78, 78), ZIndex = 33,
}, f)
end
text({ Text = it.Name, FontFace = FONT.medium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd, Position = UDim2.new(0, 6, 0, 100), Size = UDim2.new(1, -12, 0, 20), ZIndex = 33 }, f)
local partsRow
if partsH > 0 then
partsRow = mk("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 120), Size = UDim2.new(1, -8, 0, 18), ZIndex = 33 }, f)
mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, partsRow)
drawParts(partsRow, it.Parts)
end
local sub = text({ Text = it.Rarity or "", TextSize = 11.5, TextColor3 = T.sub, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.new(0, 6, 0, 120 + partsH), Size = UDim2.new(1, -12, 0, 16), ZIndex = 33 }, f)
if twoLines then sub.TextWrapped, sub.TextYAlignment, sub.Size = true, Enum.TextYAlignment.Top, UDim2.new(1, -12, 0, 32) end
local dot = mk("Frame", { BackgroundColor3 = TONES.off, Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(10, 10), Visible = false, ZIndex = 34 }, f)
corner(dot, 5)
local check = mk("Frame", { BackgroundColor3 = T.accent, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -7, 0, 7), Size = UDim2.fromOffset(20, 20), Visible = false, ZIndex = 34 }, f)
corner(check, 10)
if ICON.check then
mk("ImageLabel", { BackgroundTransparency = 1, Image = ICON.check, ImageColor3 = T.ink, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 35 }, check)
else
text({ Text = "✓", FontFace = FONT.semibold, TextSize = 12, TextColor3 = T.ink, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), ZIndex = 35 }, check)
end
f.MouseEnter:Connect(function() if not selected[it.Name] then f.BackgroundColor3 = T.navHover end end)
f.MouseLeave:Connect(function() if not selected[it.Name] then f.BackgroundColor3 = T.card end end)
f.MouseButton1Click:Connect(function()
if Settings.Single then
selected = { [it.Name] = true }
paint()
fire()
setOpen(false)
return
end
selected[it.Name] = not selected[it.Name] or nil
paint()
fire()
end)
cards[it.Name] = { frame = f, stroke = st, check = check, rarity = it.Rarity, sub = sub, dot = dot, img = img, parts = partsRow }
end
setOpen = function(open)
if open and W.openDropdown then pcall(W.openDropdown.Close, W.openDropdown) end
if open and #pendingModels > 0 then
for _, build in ipairs(pendingModels) do pcall(build) end
table.clear(pendingModels)
end
shade.Visible = open
boxStroke.Color = open and T.accent or T.inputStroke
if open then showTab(currentTab) end
end
box.MouseButton1Click:Connect(function() setOpen(true) end)
close.MouseButton1Click:Connect(function() setOpen(false) end)
function EP:Open() setOpen(true) end
function EP:Close() setOpen(false) end
function EP:GetSelection() return list() end
function EP:UpdateSelection(names)
if type(names) == "string" then names = { names } end

if Settings.Single and (type(names) ~= "table" or names[1] == nil) then return end
selected = {}
for _, n in ipairs(type(names) == "table" and names or {}) do selected[n] = true end
paint()
fire()
end
function EP:UpdateName(v) Settings.Name = v nameLabel.Text = v end
function EP:SetInfo(name, text, tone)
local c = cards[name]
if not c then return end
c.sub.Text = text or c.rarity or ""
c.toneColor = tone and TONES[tone] or nil
c.dot.Visible = c.toneColor ~= nil
if c.toneColor then c.dot.BackgroundColor3 = c.toneColor end
paint()
end
function EP:SetImage(name, image)
local card = cards[name]
if card and card.img then card.img.Image = image or "" end
end
function EP:SetParts(name, parts)
local card = cards[name]
if card and card.parts then drawParts(card.parts, parts) end
end
function EP:SetInfoAll(map)
for name, info in pairs(map or {}) do
local c = cards[name]
if c then
c.sub.Text = info[1] or c.rarity or ""
c.toneColor = info[2] and TONES[info[2]] or nil
c.dot.Visible = c.toneColor ~= nil
if c.toneColor then c.dot.BackgroundColor3 = c.toneColor end
end
end
paint()
end
paint()
showTab("All")
if Flag then DukeGUI.Options[Flag] = EP end
return EP
end
function SF:Status(Settings, Flag)
local r = newRow(card)
r.addLabel(Settings.Name or "Status")
local holder = mk("Frame", { Name = "Status", BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X })
hlist(holder, 8)
local dot = mk("Frame", { Size = UDim2.fromOffset(8, 8), BackgroundColor3 = TONES.off, LayoutOrder = 1 }, holder)
corner(dot, 4)
local value = text({ Name = "StatusValue", Text = "", TextSize = 13, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 20), LayoutOrder = 2, TextTruncate = Enum.TextTruncate.AtEnd }, holder)
local limit = mk("UISizeConstraint", { MaxSize = Vector2.new(400, 20) }, value)
r.setRight(holder)
r.main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
limit.MaxSize = Vector2.new(math.max(80, r.main.AbsoluteSize.X - 120), 20)
end)
local ST = rowApi(r, { Settings = Settings, Class = "Status" })
local tone = Settings.Tone or "off"
function ST:Set(t, newTone)
if newTone then tone = newTone end
value.Text = tostring(t or "")
dot.BackgroundColor3 = TONES[tone] or TONES.off
end
function ST:UpdateName(t) ST:Set(t) end
ST:Set(Settings.Text or "Off", tone)
if Flag then DukeGUI.Options[Flag] = ST end
return ST
end
function SF:Value(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name)
index(Settings.Name)
local value = text({
Name = "Value", Text = Settings.Text or "-", FontFace = FONT.mono, TextSize = 12.5, TextColor3 = T.value,
TextXAlignment = Enum.TextXAlignment.Right, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 18),
})
local limit = mk("UISizeConstraint", { MaxSize = Vector2.new(380, 200) }, value)
r.setRight(value)
r.main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
limit.MaxSize = Vector2.new(math.max(120, r.main.AbsoluteSize.X - 150), 200)
end)
local V = rowApi(r, { Settings = Settings, Class = "Value" })
function V:UpdateName(t) value.Text = tostring(t or "") end
function V:UpdateLabel(t) nameLabel.Text = t end
if Flag then DukeGUI.Options[Flag] = V end
return V
end
function SF:Label(Settings, Flag)
local r = newRow(card, { minHeight = 22 })
local label = text({
Name = "LabelText", Text = Settings.Text or Settings.Name or "", TextSize = 13, TextColor3 = T.value, TextWrapped = true,
AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 1,
}, r.main)
local L = rowApi(r, { Settings = Settings, Class = "Label" })
function L:UpdateName(t) label.Text = t end
if Flag then DukeGUI.Options[Flag] = L end
return L
end
function SF:Paragraph(Settings, Flag)
local r = newRow(card, { padTop = 10, padBottom = 14, minHeight = 0 })
local col = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1 }, r.main)
vlist(col, 5)
local header = text({ Text = Settings.Header or "", FontFace = FONT.semibold, TextSize = 13, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, LayoutOrder = 1 }, col)
local body = text({
Text = Settings.Body or "", FontFace = FONT.mono, TextSize = 12, TextColor3 = T.log, TextWrapped = true,
TextYAlignment = Enum.TextYAlignment.Top, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2,
LineHeight = (1.3 * 12 + 5) / (1.3 * 12),
}, col)
local P = rowApi(r, { Settings = Settings, Class = "Paragraph" })
function P:UpdateHeader(t) header.Text = t header.Visible = (t or "") ~= "" end
function P:UpdateBody(t) body.Text = t end
header.Visible = (Settings.Header or "") ~= ""
if Flag then DukeGUI.Options[Flag] = P end
return P
end
function SF:Warning(Settings)
local r = newRow(card, { padTop = 10, padBottom = 12, minHeight = 0 })
local box = mk("Frame", { BackgroundColor3 = T.warnBg, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1 }, r.main)
corner(box, 8)
padding(box, 10, 12, 10, 12)
hlist(box, 10, Enum.VerticalAlignment.Top)
if ICON.warning then
mk("ImageLabel", { BackgroundTransparency = 1, Image = ICON.warning, ImageColor3 = T.warnText, Size = UDim2.fromOffset(16, 16), LayoutOrder = 1 }, box)
else
local icon = text({ Text = "!", FontFace = FONT.semibold, TextSize = 12, TextColor3 = T.warnBg, BackgroundTransparency = 0, BackgroundColor3 = T.warnText, Size = UDim2.fromOffset(16, 16), TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 1 }, box)
corner(icon, 8)
end
local label = text({ Text = Settings.Text or "", TextSize = 12.5, LineHeight = 1.45 / 1.3, TextColor3 = T.warnText, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, -26, 0, 0), LayoutOrder = 2 }, box)
local Wn = rowApi(r, { Settings = Settings, Class = "Warning" })
function Wn:UpdateName(t) label.Text = t end
return Wn
end
function SF:Buttons(list)
local r = newRow(card, { padTop = 10, padBottom = 12, minHeight = 34 })
local holder = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), LayoutOrder = 1 }, r.main)
local buttonLayout = hlist(holder, 8)
local out = {}
local function fitButtons()
local count = 0
for _, item in ipairs(out) do if item.Button.Visible then count = count + 1 end end
local narrow = holder.AbsoluteSize.X > 0 and holder.AbsoluteSize.X < 440 and count > 1
buttonLayout.FillDirection = narrow and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
buttonLayout.VerticalAlignment = narrow and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center
holder.Size = UDim2.new(1, 0, 0, narrow and (count * 42 - 8) or 34)
for _, item in ipairs(out) do
item.Button.AutomaticSize = narrow and Enum.AutomaticSize.None or Enum.AutomaticSize.X
item.Button.Size = narrow and UDim2.new(1, 0, 0, 34) or UDim2.fromOffset(0, 34)
end
end
local function rowVisible()
local any = false
for _, b in ipairs(out) do if b.Button.Visible then any = true end end
r.setVisible(any)
fitButtons()
end
for i, s in ipairs(list) do
local b = mk("TextButton", {
Name = "Button", Text = s.Name or "", AutoButtonColor = false, FontFace = s.Primary and FONT.medium or FONT.regular, TextSize = 13,
TextColor3 = s.Primary and T.ink or T.text, BackgroundColor3 = s.Primary and T.primary or T.input,
AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 34), LayoutOrder = i,
}, holder)
corner(b, 11)
stroke(b, s.Primary and T.accent or T.inputStroke)
padding(b, 0, 14, 0, 14)
index(s.Name)
local base = b.BackgroundColor3
b.MouseEnter:Connect(function() b.BackgroundColor3 = base:Lerp(T.white, 0.06) end)
b.MouseLeave:Connect(function() b.BackgroundColor3 = base end)
b.MouseButton1Click:Connect(function() if s.Callback then s.Callback() end end)
local B = { Settings = s, Button = b, Row = r }
function B:UpdateName(t) b.Text = t end
function B:SetVisibility(on) b.Visible = on ~= false rowVisible() end
function B:SetNested(on) r.setNested(on) end
out[i] = B
end
holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitButtons)
task.defer(fitButtons)
return out
end
function SF:Button(Settings, Flag)
local b = SF:Buttons({ Settings })[1]
if Flag then DukeGUI.Options[Flag] = b end
return b
end
function SF:Disclosure(Settings)
local r = newRow(card, { padTop = 0, padBottom = 0, minHeight = 40 })
local b = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), LayoutOrder = 1 }, r.main)
hlist(b, 8)
local chev = chevron(b, "right", T.sub, 12)
chev.LayoutOrder = 1
local label = text({ Text = Settings.Name or "", TextSize = 12.5, TextColor3 = T.sub, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 40), LayoutOrder = 2 }, b)
b.MouseButton1Click:Connect(function() if Settings.Callback then Settings.Callback() end end)
local D = rowApi(r, { Settings = Settings, Class = "Disclosure" })
function D:UpdateName(t) label.Text = t end
function D:SetOpen(open) chev:SetAttribute("Open", open == true) end
return D
end
function SF:Divider()
local r = newRow(card, { padTop = 0, padBottom = 0, minHeight = 0 })
return rowApi(r, { Class = "Divider", Remove = function() r.frame:Destroy() end })
end
function SF:Spacer()
local r = newRow(card, { padTop = 4, padBottom = 4, minHeight = 0 })
return rowApi(r, { Class = "Spacer", Remove = function() r.frame:Destroy() end })
end
function SF:SubLabel(Settings, Flag)
local L = SF:Label(Settings, Flag)
return L
end
function SF:Input(Settings, Flag)
local r = newRow(card)
local nameLabel = r.addLabel(Settings.Name, Settings.Description)
local box = mk("TextBox", {
Text = Settings.Default or "", PlaceholderText = Settings.Placeholder or "", PlaceholderColor3 = T.placeholder, ClearTextOnFocus = false,
BackgroundColor3 = T.input, TextColor3 = T.text, FontFace = FONT.mono, TextSize = 12.5, TextXAlignment = Enum.TextXAlignment.Right,
Size = UDim2.fromOffset(Settings.Width or 110, 32),
})
corner(box, 11)
stroke(box, T.inputStroke)
padding(box, 0, 10, 0, 10)
r.setRight(box)
local I = rowApi(r, { Settings = Settings, Class = "Input", IgnoreConfig = false, Text = box.Text })
box.FocusLost:Connect(function()
local t = box.Text
if Settings.AcceptedCharacters == "Numeric" then t = t:gsub("[^%d%.%-]", "") box.Text = t end
I.Text = t
if Settings.Callback then Settings.Callback(t) end
end)
function I:UpdateText(t) box.Text = t I.Text = t if Settings.Callback then Settings.Callback(t) end end
function I:GetInput() return box.Text end
function I:UpdatePlaceholder(t) box.PlaceholderText = t end
function I:UpdateName(t) nameLabel.Text = t end
if Flag then DukeGUI.Options[Flag] = I end
return I
end
return SF
end
function DukeGUI:Window(Settings)
local W = { Settings = Settings }
local gui = mk("ScreenGui", {
Name = Settings.GuiName or "DukeGUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
DisplayOrder = 2147483647, IgnoreGuiInset = true,
})
pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
gui.Parent = guiHost()
W.Gui = gui
local HH = Settings.HeaderHeight or 76
local SW = Settings.SidebarWidth or 200
local base = mk("Frame", {
Name = "Base", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = Settings.Size or UDim2.fromOffset(868, 700), BackgroundColor3 = T.content, Active = true,
}, gui)
corner(base, 22)
stroke(base, T.windowStroke)
mk("UIGradient", { Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, T.content),
ColorSequenceKeypoint.new(0.62, rgb(20, 28, 23)),
ColorSequenceKeypoint.new(1, T.content),
}), Rotation = 35 }, base)
padding(base, 1, 1, 1, 1)
local baseScale = mk("UIScale", {}, base)
local header = mk("Frame", { Name = "Header", BackgroundColor3 = T.header, Position = UDim2.fromOffset(12, 10), Size = UDim2.new(1, -24, 0, HH - 18), Active = true, ZIndex = 2 }, base)
corner(header, 16)
stroke(header, T.cardStroke)
local function brandAsset(name, data)
if not (data and getcustomasset and writefile) then return nil end
local ok, asset = pcall(function()
local file = "DukeGUI/icons/" .. name .. ".png"
writefile(file, b64decode(data))
return getcustomasset(file)
end)
if not ok then warn("[DukeGUI] " .. name .. ": " .. tostring(asset)) end
return ok and asset or nil
end
local logo = brandAsset("logo", Settings.Logo)
local wordmark = brandAsset("wordmark", Settings.Wordmark)
local globe = mk("ImageButton", {
Name = "GlobalSettingsButton", Image = logo or ICON.globe or ASSET.globe, ImageColor3 = logo and Color3.new(1, 1, 1) or T.icon, BackgroundColor3 = T.input, AutoButtonColor = false,
AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0),
Size = UDim2.fromOffset(44, 44),
ScaleType = Enum.ScaleType.Fit, ZIndex = 3,
}, header)
corner(globe, 12)
stroke(globe, T.inputStroke)
local titleFrame = mk("Frame", { Name = "TitleFrame", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 68, 0.5, 0), Size = UDim2.new(1, -158, 1, 0), ZIndex = 3 }, header)
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), VerticalAlignment = Enum.VerticalAlignment.Center }, titleFrame)
local title = text({ Name = "Title", Text = Settings.Title or "", FontFace = FONT.semibold, TextSize = 17, TextColor3 = T.bright, Size = UDim2.new(1, 0, 0, wordmark and 0 or 22), LayoutOrder = 1, ZIndex = 3, Visible = wordmark == nil }, titleFrame)
local headerWordmark
if wordmark then
headerWordmark = mk("ImageLabel", {
Name = "Wordmark", BackgroundTransparency = 1, Image = wordmark, ScaleType = Enum.ScaleType.Fit,
Size = UDim2.fromOffset(256, 36), LayoutOrder = 1, ZIndex = 3,
}, titleFrame)
end
local subtitle = text({ Name = "Subtitle", Text = Settings.Subtitle or "", TextSize = 12.5, TextColor3 = T.accent, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 2, ZIndex = 3 }, titleFrame)
local dots = mk("Frame", { Name = "Controls", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(60, 28), ZIndex = 3 }, header)
hlist(dots, 6, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Right)
local function dot(name, color, order, icon, glyphColor)
local d = mk("TextButton", { Name = name, Text = "", AutoButtonColor = false, BackgroundColor3 = color, Size = UDim2.fromOffset(26, 26), LayoutOrder = order, ZIndex = 3 }, dots)
corner(d, 9)
stroke(d, T.inputStroke)
local glyph = ICON[icon] and mk("ImageLabel", {
BackgroundTransparency = 1, Image = ICON[icon], ImageColor3 = glyphColor, ImageTransparency = 0.4,
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12), ZIndex = 4,
}, d)
return d, glyph
end
local minDot, minGlyph = dot("Minimize", T.chrome, 1, "winMinimize", T.accent)
local exitDot, exitGlyph = dot("Exit", T.chrome, 2, "winClose", T.dangerText)
local function showGlyphs(on)
for _, g in ipairs({ minGlyph, exitGlyph }) do if g then g.ImageTransparency = on and 0 or 0.4 end end
end
for _, d in ipairs({ minDot, exitDot }) do
d.MouseEnter:Connect(function() showGlyphs(true) end)
d.MouseLeave:Connect(function() showGlyphs(false) end)
end
local navButton = mk("TextButton", { Name = "NavigationButton", Text = "≡", AutoButtonColor = false,
FontFace = FONT.semibold, TextSize = 21, TextColor3 = T.accent, BackgroundColor3 = T.input,
AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -82, 0.5, 0),
Size = UDim2.fromOffset(28, 28), Visible = false, ZIndex = 5 }, header)
corner(navButton, 9)
stroke(navButton, T.inputStroke)
local menuKey = Settings.Keybind or Enum.KeyCode.RightControl
local MINI_FILE = DukeGUI.Folder .. "/" .. tostring(Settings.GuiName or "DukeGUI") .. "_mini.txt"
local MINI_DEFAULT = UDim2.new(1, -16, 0, 70)
local mini = mk("TextButton", {
Name = "Mini", Text = "", AutoButtonColor = false, BackgroundColor3 = T.header, AnchorPoint = Vector2.new(1, 0),
Position = MINI_DEFAULT, Size = UDim2.fromOffset(56, 56), Visible = false, ZIndex = 60,
}, gui)
corner(mini, 16)
stroke(mini, T.windowStroke)
mk("Frame", { Name = "SignalStrip", BackgroundColor3 = T.accent, BackgroundTransparency = 0.25, Size = UDim2.new(1, 0, 0, 1), ZIndex = 61 }, mini)
mk("ImageLabel", { Name = "Logo", BackgroundTransparency = 1, Image = logo or ICON.globe or ASSET.globe,
ImageColor3 = logo and T.white or T.accent, ScaleType = Enum.ScaleType.Fit, AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(40, 40), ZIndex = 61 }, mini)
local miniDot = mk("Frame", { BackgroundColor3 = TONES.off, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -6, 1, -6), Size = UDim2.fromOffset(8, 8), ZIndex = 62 }, mini)
corner(miniDot, 4)
local miniTitle = text({ Text = Settings.Title or "", FontFace = FONT.medium, TextSize = 13, Position = UDim2.fromOffset(32, 6), Size = UDim2.new(1, -70, 0, 17), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 61, Visible = false }, mini)
local miniWordmark
if wordmark then
miniWordmark = mk("ImageLabel", {
Name = "MiniWordmark", BackgroundTransparency = 1, Image = wordmark, ScaleType = Enum.ScaleType.Fit,
Position = UDim2.fromOffset(32, 5), Size = UDim2.fromOffset(120, 17), Visible = false, ZIndex = 61,
}, mini)
end
local miniSub = text({ Text = "", TextSize = 12, TextColor3 = T.sub, Position = UDim2.fromOffset(32, 23), Size = UDim2.new(1, -70, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd, Visible = false, ZIndex = 61 }, mini)
local miniOpen = mk("ImageLabel", {
BackgroundTransparency = 1, Image = ICON.expand or "", ImageColor3 = T.icon, AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -16, 0.5, 0), Size = UDim2.fromOffset(14, 14), Visible = false, ZIndex = 61,
}, mini)
local miniStatus = { title = "", text = "", tone = "off" }
local miniHover, pulse = false, nil
local function keyName()
return (tostring(menuKey.Name):gsub("Control", " Ctrl"):gsub("Shift", " Shift"):gsub("Alt", " Alt"):gsub("^%s+", ""))
end
local function paintMini()
miniTitle.Text = miniStatus.title ~= "" and miniStatus.title or (Settings.Title or "")
miniSub.Text = miniHover and ("Click to open  ·  " .. keyName()) or miniStatus.text
miniDot.BackgroundColor3 = TONES[miniStatus.tone] or TONES.off
local run = miniStatus.tone == "run" and mini.Visible
if run and not pulse then
pulse = TweenService:Create(miniDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.65 })
pulse:Play()
elseif not run and pulse then
pulse:Cancel()
pulse = nil
miniDot.BackgroundTransparency = 0
end
end
local function setMiniStatus(t, t2, right, tone)
t2, right = tostring(t2 or ""), tostring(right or "")
miniStatus.title = tostring(t or "")
miniStatus.text = t2 .. ((t2 ~= "" and right ~= "") and "  ·  " or "") .. right
miniStatus.tone = tone or "off"
paintMini()
end
mini.MouseEnter:Connect(function()
miniHover = true
mini.BackgroundColor3, miniOpen.ImageColor3 = T.navHover, T.bright
paintMini()
end)
mini.MouseLeave:Connect(function()
miniHover = false
mini.BackgroundColor3, miniOpen.ImageColor3 = T.header, T.icon
paintMini()
end)
pcall(function()
if isfile and isfile(MINI_FILE) then
local x, y = readfile(MINI_FILE):match("^(%-?%d+),(%-?%d+)$")
if x then mini.Position = UDim2.new(1, tonumber(x), 0, tonumber(y)) end
end
end)
local miniDrag, miniStart, miniMoved
mini.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
miniDrag, miniStart, miniMoved = input.Position, mini.Position, false
end
end)
track(UserInputService.InputChanged:Connect(function(input)
if miniDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local d = input.Position - miniDrag
if miniMoved or d.Magnitude > 4 then
miniMoved = true
mini.Position = UDim2.new(miniStart.X.Scale, miniStart.X.Offset + d.X, miniStart.Y.Scale, miniStart.Y.Offset + d.Y)
end
end
end))
local body = mk("Frame", { Name = "Body", BackgroundTransparency = 1, Position = UDim2.fromOffset(0, HH + 4), Size = UDim2.new(1, 0, 1, -(HH + 4)) }, base)
local sidebar = mk("Frame", { Name = "Sidebar", BackgroundColor3 = T.sidebar, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(0, SW - 18, 1, -12), ZIndex = 20 }, body)
corner(sidebar, 16)
stroke(sidebar, T.sidebarLine)
local searchHolder = mk("Frame", { Name = "SearchHolder", BackgroundTransparency = 1, Size = UDim2.new(1, -1, 0, 52), ZIndex = 2 }, sidebar)
padding(searchHolder, 12, 10, 4, 10)
local searchFrame = mk("Frame", { Name = "Search", BackgroundColor3 = T.search, Size = UDim2.fromScale(1, 1), ZIndex = 2 }, searchHolder)
corner(searchFrame, 9)
stroke(searchFrame, T.searchStroke)
mk("ImageLabel", { Image = ICON.search or ASSET.search, ImageColor3 = T.placeholder, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.fromOffset(14, 14), ZIndex = 2 }, searchFrame)
local searchBox = mk("TextBox", {
Name = "SearchBox", Text = "", PlaceholderText = "Search settings", PlaceholderColor3 = T.placeholder, ClearTextOnFocus = false,
BackgroundTransparency = 1, TextColor3 = T.text, FontFace = FONT.regular, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -40, 1, 0), ZIndex = 2,
}, searchFrame)
local PROFILE_H = 72
local nav = mk("ScrollingFrame", {
Name = "Tabs", BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 52), Size = UDim2.new(1, 0, 1, -(60 + PROFILE_H)),
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = T.scroll,
ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 2,
}, sidebar)
padding(nav, 4, 10, 4, 10)
vlist(nav, 4)
local profile = mk("Frame", { Name = "UserInfo", BackgroundColor3 = T.card, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, PROFILE_H), ZIndex = 2 }, sidebar)
corner(profile, 14)
stroke(profile, T.cardStroke)
local profileAccent = mk("Frame", { Name = "ProfileAccent", BackgroundColor3 = T.accent, Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(18, 3), ZIndex = 3 }, profile)
corner(profileAccent, 2)
local avatar = mk("ImageLabel", { Name = "Headshot", BackgroundColor3 = T.avatarBg, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.fromOffset(40, 40), ZIndex = 2 }, profile)
corner(avatar, 20)
stroke(avatar, T.avatarStroke, 1, true)
task.spawn(function()
local ok, img = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
if ok and img and avatar.Parent then avatar.Image = img end
end)
local names = mk("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 68, 0.5, 0), Size = UDim2.new(1, -80, 0, 36), ZIndex = 2 }, profile)
vlist(names, 1)
text({ Name = "DisplayName", Text = LocalPlayer.DisplayName, FontFace = FONT.semibold, TextSize = 14, TextColor3 = T.bright, Size = UDim2.new(1, 0, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1, ZIndex = 2 }, names)
text({ Name = "Username", Text = "@" .. LocalPlayer.Name, TextSize = 12.5, TextColor3 = T.muted, Size = UDim2.new(1, 0, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 2, ZIndex = 2 }, names)
local content = mk("Frame", { Name = "Content", BackgroundTransparency = 1, Position = UDim2.fromOffset(SW + 6, 0), Size = UDim2.new(1, -(SW + 18), 1, -12) }, body)
local navShade = mk("TextButton", { Name = "NavigationShade", Text = "", AutoButtonColor = false,
BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 0.38,
Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 10 }, body)
local compactLayout = false
local windowAnimating = false
local function setNavOpen(open)
if not compactLayout then return end
sidebar.Visible = open == true
navShade.Visible = open == true
end
navButton.MouseButton1Click:Connect(function() setNavOpen(not sidebar.Visible) end)
navShade.MouseButton1Click:Connect(function() setNavOpen(false) end)
local function updateLayout()
if windowAnimating then return end
local vp = gui.AbsoluteSize
local compact = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
or vp.X < 720 or vp.Y < 500 or base.AbsoluteSize.X < 650
if compact == compactLayout then return end
compactLayout = compact
navButton.Visible = compact
if compact then
sidebar.Size = UDim2.new(0, math.min(260, math.max(200, base.Size.X.Offset - 24)), 1, -12)
content.Position = UDim2.fromOffset(0, 0)
content.Size = UDim2.new(1, 0, 1, -12)
if headerWordmark then headerWordmark.Visible = false end
title.Visible = true
title.Size = UDim2.new(1, 0, 0, 22)
setNavOpen(false)
else
sidebar.Size = UDim2.new(0, SW - 18, 1, -12)
sidebar.Visible = true
navShade.Visible = false
content.Position = UDim2.fromOffset(SW + 6, 0)
content.Size = UDim2.new(1, -(SW + 18), 1, -12)
if headerWordmark then headerWordmark.Visible = true title.Visible = false title.Size = UDim2.new(1, 0, 0, 0) end
end
end
track(base:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout))
track(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout))
task.defer(updateLayout)
local pageTop = 0
if Settings.StatusBar ~= false then
local bar = mk("Frame", { Name = "StatusBar", BackgroundColor3 = T.bar, Position = UDim2.fromOffset(20, 0), Size = UDim2.new(1, -40, 0, 70) }, content)
corner(bar, 16)
stroke(bar, T.barStroke)
mk("UIGradient", { Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, rgb(216, 249, 102)),
ColorSequenceKeypoint.new(0.55, T.accent),
ColorSequenceKeypoint.new(1, rgb(125, 204, 78)),
}), Rotation = 12 }, bar)
local left = mk("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -36, 1, 0), ClipsDescendants = true }, bar)
local barDot = mk("Frame", { Position = UDim2.fromOffset(0, 17), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = T.ink }, left)
corner(barDot, 4)
local barTitle = text({ Text = "", FontFace = FONT.semibold, TextSize = 17, TextColor3 = T.ink, Position = UDim2.fromOffset(16, 7), Size = UDim2.new(1, -130, 0, 28), TextTruncate = Enum.TextTruncate.AtEnd }, left)
local barText = text({ Text = "", TextSize = 12.5, TextColor3 = rgb(50, 67, 35), Position = UDim2.fromOffset(16, 35), Size = UDim2.new(1, -130, 0, 24), TextTruncate = Enum.TextTruncate.AtEnd }, left)
local barRight = text({ Text = "", TextSize = 12.5, FontFace = FONT.medium, TextColor3 = T.accent, BackgroundTransparency = 0,
BackgroundColor3 = T.ink, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Size = UDim2.fromOffset(94, 30),
TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.AtEnd }, bar)
corner(barRight, 10)
local function fitBar()
local reserved = barRight.Visible and 126 or 22
barTitle.Size = UDim2.new(1, -reserved, 0, 28)
barText.Size = UDim2.new(1, -reserved, 0, 24)
end
function W:SetStatus(t, t2, right, tone)
barTitle.Text = tostring(t or "")
barText.Text = tostring(t2 or "")
barRight.Text = tostring(right or "")
barRight.Visible = barRight.Text ~= ""
barDot.BackgroundColor3 = tone == "bad" and rgb(148, 44, 38) or T.ink
fitBar()
setMiniStatus(t, t2, right, tone)
end
barRight.Visible = false
fitBar()
pageTop = 84
else
function W:SetStatus(t, t2, right, tone) setMiniStatus(t, t2, right, tone) end
end
local pages = mk("Frame", { Name = "Pages", BackgroundTransparency = 1, Position = UDim2.fromOffset(0, pageTop), Size = UDim2.new(1, 0, 1, -pageTop) }, content)
local dragStart, startPos
header.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragStart, startPos = input.Position, base.Position
end
end)
track(UserInputService.InputChanged:Connect(function(input)
if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end))
track(UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragStart = nil
if W.KeepOnScreen then W:KeepOnScreen() end
end
end))
local resizeDrag
local function resizeHandle(name, position, size, edges)
local handle = mk("TextButton", { Name = name, Text = "", AutoButtonColor = false,
BackgroundTransparency = 1, Position = position, Size = size, ZIndex = 35 }, base)
handle.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
local p, s = base.AbsolutePosition, base.AbsoluteSize
resizeDrag = { input = input, start = input.Position, left = p.X, top = p.Y,
right = p.X + s.X, bottom = p.Y + s.Y, edges = edges }
end)
return handle
end
resizeHandle("ResizeLeft", UDim2.fromOffset(0, 18), UDim2.new(0, 7, 1, -36), { left = true })
resizeHandle("ResizeRight", UDim2.new(1, -7, 0, 18), UDim2.new(0, 7, 1, -36), { right = true })
resizeHandle("ResizeTop", UDim2.fromOffset(18, 0), UDim2.new(1, -36, 0, 7), { top = true })
resizeHandle("ResizeBottom", UDim2.new(0, 18, 1, -7), UDim2.new(1, -36, 0, 7), { bottom = true })
resizeHandle("ResizeTopLeft", UDim2.fromOffset(0, 0), UDim2.fromOffset(18, 18), { top = true, left = true })
resizeHandle("ResizeTopRight", UDim2.new(1, -18, 0, 0), UDim2.fromOffset(18, 18), { top = true, right = true })
resizeHandle("ResizeBottomLeft", UDim2.new(0, 0, 1, -18), UDim2.fromOffset(18, 18), { bottom = true, left = true })
local cornerGrip = resizeHandle("ResizeBottomRight", UDim2.new(1, -20, 1, -20), UDim2.fromOffset(20, 20), { bottom = true, right = true })
text({ Text = "◢", FontFace = FONT.semibold, TextSize = 13, TextColor3 = T.accent,
TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), ZIndex = 36 }, cornerGrip)
track(UserInputService.InputChanged:Connect(function(input)
if not resizeDrag or (input.UserInputType ~= Enum.UserInputType.MouseMovement and input ~= resizeDrag.input) then return end
local d = input.Position - resizeDrag.start
local vp = gui.AbsoluteSize
local origin = gui.AbsolutePosition
local minW = math.min(320, math.max(240, vp.X - 16))
local minH = math.min(320, math.max(220, vp.Y - 16))
local left, top, right, bottom = resizeDrag.left, resizeDrag.top, resizeDrag.right, resizeDrag.bottom
local e = resizeDrag.edges
if e.left then left = math.clamp(left + d.X, origin.X + 8, math.max(origin.X + 8, right - minW)) end
if e.right then right = math.clamp(right + d.X, left + minW, math.max(left + minW, origin.X + vp.X - 8)) end
if e.top then top = math.clamp(top + d.Y, origin.Y + 8, math.max(origin.Y + 8, bottom - minH)) end
if e.bottom then bottom = math.clamp(bottom + d.Y, top + minH, math.max(top + minH, origin.Y + vp.Y - 8)) end
local scale = math.max(0.1, baseScale.Scale)
base.Size = UDim2.fromOffset((right - left) / scale, (bottom - top) / scale)
base.Position = UDim2.new(0.5, (left + right) * 0.5 - origin.X - vp.X * 0.5,
0.5, (top + bottom) * 0.5 - origin.Y - vp.Y * 0.5)
end))
track(UserInputService.InputEnded:Connect(function(input)
if not resizeDrag or (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input ~= resizeDrag.input) then return end
resizeDrag = nil
if W._onResized then W._onResized(base.Size.X.Offset, base.Size.Y.Offset) end
end))
local tabs, groups = {}, {}
local groupOrder = 0
local current
local function paintTab(t, hover)
local on = t == current
local bg = on and T.navActive or T.navHover
local transparency = (on or hover) and 0 or 1
local labelColor = on and T.ink or T.nav
if t.painted then
tween(t.button, 0.18, { BackgroundColor3 = bg, BackgroundTransparency = transparency })
tween(t.label, 0.18, { TextColor3 = labelColor })
else
t.button.BackgroundColor3, t.button.BackgroundTransparency = bg, transparency
t.label.TextColor3 = labelColor
t.painted = true
end
t.marker.Visible = on
t.label.FontFace = on and FONT.medium or FONT.regular
end
local noMatch = text({
Name = "NoMatch", Text = "No matches", RichText = false, FontFace = FONT.regular, TextSize = 13, TextColor3 = T.placeholder,
Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 100000, Visible = false, ZIndex = 2,
}, nav)
local function applySearch()
local q = string.lower(searchBox.Text or "")
local found = false
for _, g in ipairs(groups) do
local any = false
for _, t in ipairs(g.tabs) do
local show = q == "" or string.find(t.search, q, 1, true) ~= nil
t.button.Visible = show
any = any or show
end
if g.label then g.label.Visible = any end
if g.separator then g.separator.Visible = q == "" end
g.frame.Visible = any or q == ""
found = found or any
end
noMatch.Text = "No matches for \"" .. (searchBox.Text or "") .. "\""
noMatch.Visible = q ~= "" and not found
end
searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)
function W:TabGroup(GroupSettings)
GroupSettings = GroupSettings or {}
groupOrder = groupOrder + 1
local frame = mk("Frame", { Name = "Group", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = groupOrder, ZIndex = 2 }, nav)
vlist(frame, 2)
local g = { frame = frame, tabs = {}, order = 0 }
groups[#groups + 1] = g
if GroupSettings.Separator then
g.separator = mk("Frame", { Name = "Separator", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 17), LayoutOrder = 0, ZIndex = 2 }, frame)
mk("Frame", { BackgroundColor3 = T.sidebarLine, Position = UDim2.fromOffset(10, 9), Size = UDim2.new(1, -20, 0, 1), ZIndex = 2 }, g.separator)
end
if GroupSettings.Name then
g.label = text({
Name = "GroupLabel", Text = string.upper(GroupSettings.Name), FontFace = FONT.medium, TextSize = 11, TextColor3 = T.group,
Size = UDim2.new(1, 0, 0, 31), TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = 1, ZIndex = 2,
}, frame)
padding(g.label, 13, 10, 4, 10)
end
local GF = {}
function GF:Tab(TabSettings)
g.order = g.order + 1
local button = mk("TextButton", {
Name = "TabSwitcher", Text = "", AutoButtonColor = false, BackgroundColor3 = T.navHover, BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 1 + g.order, ZIndex = 2,
}, frame)
corner(button, 12)
local marker = mk("Frame", { Name = "ActiveMark", BackgroundColor3 = T.ink, Position = UDim2.fromOffset(12, 16), Size = UDim2.fromOffset(7, 7), Visible = false, ZIndex = 3 }, button)
corner(marker, 4)
local label = text({ Name = "TabSwitcherName", Text = TabSettings.Name or "", TextSize = 13.5, TextColor3 = T.nav, Position = UDim2.fromOffset(27, 0), Size = UDim2.new(1, -50, 1, 0), ZIndex = 2 }, button)
local badge = mk("Frame", { Name = "Badge", BackgroundColor3 = TONES.run, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(7, 7), Visible = false, ZIndex = 2 }, button)
corner(badge, 4)
local page = mk("ScrollingFrame", {
Name = "Page", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollBarThickness = 3, ScrollBarImageColor3 = T.scroll, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
}, pages)
local pageScale = mk("UIScale", { Scale = 1 }, page)
padding(page, 2, 20, 24, 20)
vlist(page, 12)
local t = { button = button, marker = marker, label = label, page = page, order = 0, search = string.lower(TabSettings.Name or "") }
function t.nextOrder()
t.order = t.order + 1
return t.order
end
function t.index(s) t.search = t.search .. " " .. string.lower(tostring(s)) end
if TabSettings.Title then
local head = mk("Frame", { Name = "PageHeader", BackgroundColor3 = T.card, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 0 }, page)
corner(head, 16)
stroke(head, T.cardStroke)
padding(head, 14, 18, 16, 18)
vlist(head, 4)
text({ Name = "PageEyebrow", Text = "DUKEHUB  /  " .. string.upper(TabSettings.Name or "VIEW"), FontFace = FONT.mono, TextSize = 10, TextColor3 = T.accent, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 0 }, head)
text({ Name = "PageTitle", Text = TabSettings.Title, FontFace = FONT.semibold, TextSize = 21, TextColor3 = T.bright,
TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 27), LayoutOrder = 1 }, head)
if TabSettings.Description then
text({ Name = "PageDescription", Text = TabSettings.Description, TextSize = 13, TextColor3 = T.sub, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 0), LayoutOrder = 2 }, head)
end
t.index(TabSettings.Title)
t.index(TabSettings.Description or "")
end
tabs[#tabs + 1] = t
g.tabs[#g.tabs + 1] = t
local TF = { Settings = TabSettings }
function TF:Select()
if W.openDropdown then pcall(W.openDropdown.Close, W.openDropdown) end
local previous = current
if previous == t then
if compactLayout then setNavOpen(false) end
return
end
current = t
for _, other in ipairs(tabs) do other.page.Visible = other == t end
if previous and previous ~= t then paintTab(previous) end
paintTab(t)
page.Position = UDim2.fromOffset(18, 0)
pageScale.Scale = 0.98
tween(page, 0.25, { Position = UDim2.fromOffset(0, 0) })
tween(pageScale, 0.25, { Scale = 1 })
if compactLayout then setNavOpen(false) end
end
function TF:SetBadge(on, color)
badge.Visible = on == true
if color then badge.BackgroundColor3 = color end
end
function TF:Section() return newCard(W, t) end
button.MouseButton1Click:Connect(function() TF:Select() end)
button.MouseEnter:Connect(function() paintTab(t, true) end)
button.MouseLeave:Connect(function() paintTab(t, false) end)
paintTab(t)
return TF
end
return GF
end
local globalMenu = mk("Frame", { Name = "GlobalSettings", BackgroundColor3 = T.card, Position = UDim2.fromOffset(14, HH - 6), Size = UDim2.fromOffset(220, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 20 }, base)
corner(globalMenu, 10)
stroke(globalMenu, T.cardStroke)
padding(globalMenu, 6, 6, 6, 6)
vlist(globalMenu, 2)
globe.MouseButton1Click:Connect(function() globalMenu.Visible = not globalMenu.Visible end)
globe.MouseEnter:Connect(function() if logo then globe.ImageTransparency = 0.2 else globe.ImageColor3 = T.text end end)
globe.MouseLeave:Connect(function() if logo then globe.ImageTransparency = 0 else globe.ImageColor3 = T.icon end end)
function W:GlobalSetting(GS)
local state = GS.Default == true
local b = mk("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = T.navHover, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), ZIndex = 20 }, globalMenu)
corner(b, 6)
local lbl = text({ Text = GS.Name or "", TextSize = 13, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -60, 1, 0), ZIndex = 20 }, b)
local trackF = mk("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(30, 18), BackgroundColor3 = T.off, ZIndex = 20 }, b)
corner(trackF, 9)
local knob = mk("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = T.knobOff, ZIndex = 20 }, trackF)
corner(knob, 7)
local function render()
trackF.BackgroundColor3 = state and T.accent or T.off
knob.Position = UDim2.new(0, state and 14 or 2, 0.5, 0)
knob.BackgroundColor3 = state and T.white or T.knobOff
end
render()
b.MouseEnter:Connect(function() b.BackgroundTransparency = 0 end)
b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 end)
local G2 = {}
function G2:UpdateState(v)
state = v == true
render()
if GS.Callback then GS.Callback(state) end
end
function G2:UpdateName(v) lbl.Text = v end
b.MouseButton1Click:Connect(function() G2:UpdateState(not state) end)
return G2
end
local notifyHolder = mk("Frame", { Name = "Notifications", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 50 }, gui)
padding(notifyHolder, 12, 12, 12, 12)
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom }, notifyHolder)
local notificationsOn = true
local notifyCount = 0
function W:Notify(NS)
local NF = {}
if not notificationsOn then
function NF:Cancel() end
function NF:UpdateTitle() end
function NF:UpdateDescription() end
function NF:Resize() end
return NF
end
notifyCount = notifyCount + 1
local box = mk("Frame", { Name = "Notification", BackgroundColor3 = T.card, Size = UDim2.fromOffset(300, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = notifyCount, ZIndex = 50 }, notifyHolder)
corner(box, 10)
stroke(box, T.cardStroke)
padding(box, 12, 14, 12, 14)
vlist(box, 3)
local t1 = text({ Text = NS.Title or "", FontFace = FONT.semibold, TextSize = 13, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = 1, ZIndex = 50 }, box)
local t2 = text({ Text = NS.Description or "", TextSize = 13, TextColor3 = T.sub, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, LayoutOrder = 2, ZIndex = 50 }, box)
local closed = false
function NF:Cancel()
if closed then return end
closed = true
box:Destroy()
end
function NF:UpdateTitle(v) t1.Text = v end
function NF:UpdateDescription(v) t2.Text = v end
function NF:Resize(x) box.Size = UDim2.fromOffset(x, 0) end
task.delay(NS.Lifetime or 5, function() NF:Cancel() end)
return NF
end
function W:SetNotificationsState(on) notificationsOn = on == true end
function W:GetNotificationsState() return notificationsOn end
function W:Dialog(DS)
local shade = mk("TextButton", { Name = "Dialog", Text = "", AutoButtonColor = false, BackgroundColor3 = rgb(0, 0, 0), BackgroundTransparency = 0.45, Size = UDim2.fromScale(1, 1), ZIndex = 40 }, base)
corner(shade, 12)
local box = mk("Frame", { BackgroundColor3 = T.card, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 41 }, shade)
corner(box, 10)
stroke(box, T.cardStroke)
padding(box, 16, 16, 16, 16)
vlist(box, 8)
text({ Text = DS.Title or "", FontFace = FONT.semibold, TextSize = 15, Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1, ZIndex = 41 }, box)
text({ Text = DS.Description or "", TextSize = 13, TextColor3 = T.sub, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, ZIndex = 41 }, box)
local row = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), LayoutOrder = 3, ZIndex = 41 }, box)
hlist(row, 8, Enum.VerticalAlignment.Center, Enum.HorizontalAlignment.Right)
local DF = {}
function DF:Cancel() shade:Destroy() end
for i, bs in ipairs(DS.Buttons or {}) do
local primary = i == 1
local b = mk("TextButton", {
Text = bs.Name or "", AutoButtonColor = false, FontFace = primary and FONT.medium or FONT.regular, TextSize = 13,
TextColor3 = primary and T.ink or T.text, BackgroundColor3 = primary and T.primary or T.input,
AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 34), LayoutOrder = i, ZIndex = 41,
}, row)
corner(b, 11)
stroke(b, primary and T.accent or T.inputStroke)
padding(b, 0, 14, 0, 14)
b.MouseButton1Click:Connect(function()
DF:Cancel()
if bs.Callback then bs.Callback() end
end)
end
function DF:UpdateTitle() end
function DF:UpdateDescription() end
return DF
end
local windowOpen = true
local expandedSize, expandedPosition = base.Size, base.Position
local stateTween, stateToken = nil, 0
local function miniTarget()
local p, s, vp = mini.AbsolutePosition - gui.AbsolutePosition, mini.AbsoluteSize, gui.AbsoluteSize
local scale = math.max(0.1, baseScale.Scale)
return UDim2.new(0.5, p.X + s.X * 0.5 - vp.X * 0.5, 0.5, p.Y + s.Y * 0.5 - vp.Y * 0.5),
UDim2.fromOffset(s.X / scale, s.Y / scale)
end
function W:SetState(open)
open = open == true
if open == windowOpen and not stateTween then return end
stateToken = stateToken + 1
local token = stateToken
local wasAnimating = windowAnimating
if stateTween then stateTween:Cancel() stateTween = nil end
windowAnimating = true
if open then
windowOpen = true
if not base.Visible then
base.Position, base.Size = miniTarget()
end
base.Visible = true
mini.Visible = false
base.ClipsDescendants = true
stateTween = TweenService:Create(base, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
{ Position = expandedPosition, Size = expandedSize })
stateTween.Completed:Connect(function()
if token ~= stateToken then return end
stateTween = nil
windowAnimating = false
base.ClipsDescendants = false
updateLayout()
end)
else
if not wasAnimating then expandedSize, expandedPosition = base.Size, base.Position end
windowOpen = false
base.Visible = true
mini.Visible = false
base.ClipsDescendants = true
local targetPosition, targetSize = miniTarget()
stateTween = TweenService:Create(base, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
{ Position = targetPosition, Size = targetSize })
stateTween.Completed:Connect(function()
if token ~= stateToken then return end
stateTween = nil
base.Visible = false
base.Size, base.Position = expandedSize, expandedPosition
base.ClipsDescendants = false
windowAnimating = false
mini.Visible = Settings.MiniBar ~= false
paintMini()
end)
end
stateTween:Play()
paintMini()
end
function W:GetState() return windowOpen end
function W:SetKeybind(k) menuKey = k paintMini() end
local function toggleMenu()
W:SetState(not windowOpen)
end
track(UserInputService.InputEnded:Connect(function(input)
if miniDrag and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
local moved = miniMoved
miniDrag, miniMoved = nil, false
if moved then
pcall(function()
if writefile then
if makefolder and isfolder and not isfolder(DukeGUI.Folder) then makefolder(DukeGUI.Folder) end
writefile(MINI_FILE, string.format("%d,%d", mini.Position.X.Offset, mini.Position.Y.Offset))
end
end)
else
W:SetState(true)
end
end
end))
track(UserInputService.InputEnded:Connect(function(input, gpe)
if gpe then return end
if input.KeyCode == menuKey then toggleMenu() end
end))
minDot.MouseButton1Click:Connect(toggleMenu)
local onUnload
function W.onUnloaded(fn) onUnload = fn end
function W:Unload()
for _, c in ipairs(libConnections) do pcall(c.Disconnect, c) end
table.clear(libConnections)
if gui.Parent then gui:Destroy() end
if onUnload then pcall(onUnload) end
end
exitDot.MouseButton1Click:Connect(function()
W:Dialog({
Title = Settings.Title,
Description = "Close the menu? Everything it runs stops until you start it again.",
Buttons = { { Name = "Close", Callback = function() W:Unload() end }, { Name = "Cancel" } },
})
end)
local blur = false
function W:SetAcrylicBlurState(v) blur = v == true end
function W:GetAcrylicBlurState() return blur end
function W:SetUserInfoState(v) profile.Visible = v ~= false end
function W:GetUserInfoState() return profile.Visible end
function W:SetSize(v) base.Size = v end
function W:GetSize() return base.Size end
function W:SetScale(v) baseScale.Scale = v end
function W:GetScale() return baseScale.Scale end
function W:KeepOnScreen()
local vp, p, s = gui.AbsoluteSize, base.AbsolutePosition - gui.AbsolutePosition, base.AbsoluteSize
if vp.X < 50 or vp.Y < 50 or s.X < 1 or s.Y < 1 then return end
local x = math.clamp(p.X, math.min(8, vp.X - s.X), math.max(8, vp.X - s.X - 8))
local y = math.clamp(p.Y, math.min(8, vp.Y - s.Y), math.max(8, vp.Y - s.Y - 8))
base.Position = UDim2.new(0.5, x + s.X * 0.5 - vp.X * 0.5, 0.5, y + s.Y * 0.5 - vp.Y * 0.5)
end
function W:UpdateTitle(v)
title.Text = v
miniTitle.Text = v
if headerWordmark then headerWordmark.Visible = false title.Visible = true title.Size = UDim2.new(1, 0, 0, 22) end
if miniWordmark then miniWordmark.Visible = false miniTitle.Visible = true end
end
function W:UpdateSubtitle(v) subtitle.Text = v end
W.Base = base
return W
end
local ClassParser = {
Toggle = {
Save = function(flag, data) return { type = "Toggle", flag = flag, state = data.State or false } end,
Load = function(flag, data)
local option = DukeGUI.Options[flag]
if option and data.state ~= nil and option.State ~= (data.state == true) then option:UpdateState(data.state == true) end
end,
},
Slider = {
Save = function(flag, data) return { type = "Slider", flag = flag, value = (data.Value and tostring(data.Value)) or false } end,
Load = function(flag, data)
local option = DukeGUI.Options[flag]
if option and data.value then
option:UpdateValue(data.value)
if option.Settings and option.Settings.Callback and option.Value ~= nil then task.spawn(option.Settings.Callback, option.Value) end
end
end,
},
Input = {
Save = function(flag, data) return { type = "Input", flag = flag, text = data.Text } end,
Load = function(flag, data)
if DukeGUI.Options[flag] and type(data.text) == "string" then DukeGUI.Options[flag]:UpdateText(data.text) end
end,
},
Dropdown = {
Save = function(flag, data) return { type = "Dropdown", flag = flag, value = data.Value } end,
Load = function(flag, data)
if DukeGUI.Options[flag] and data.value then DukeGUI.Options[flag]:UpdateSelection(data.value) end
end,
},
EggPicker = {
Save = function(flag, data) return { type = "EggPicker", flag = flag, value = data.Value or {} } end,
Load = function(flag, data)
if DukeGUI.Options[flag] and type(data.value) == "table" then DukeGUI.Options[flag]:UpdateSelection(data.value) end
end,
},
}
local function buildFolderTree()
if isStudio or not (isfolder and makefolder) then return end
for _, p in ipairs({ DukeGUI.Folder, DukeGUI.Folder .. "/settings" }) do
if not isfolder(p) then makefolder(p) end
end
end
function DukeGUI:SetFolder(folder)
if isStudio then return "Config system unavailable." end
DukeGUI.Folder = folder
buildFolderTree()
end
function DukeGUI:SaveConfig(path)
if isStudio or not writefile then return false, "Config system unavailable." end
if not path then return false, "Please select a config file." end
local data = { objects = {} }
for flag, option in next, DukeGUI.Options do
local parser = ClassParser[option.Class]
if parser and not option.IgnoreConfig then table.insert(data.objects, parser.Save(flag, option)) end
end
local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
if not ok then return false, "Unable to encode into JSON data" end
writefile(DukeGUI.Folder .. "/settings/" .. path .. ".json", encoded)
return true
end
function DukeGUI:LoadConfig(path)
if isStudio or not (isfile and readfile) then return false, "Config system unavailable." end
if not path then return false, "Please select a config file." end
local file = DukeGUI.Folder .. "/settings/" .. path .. ".json"
if not isfile(file) then return false, "Invalid file" end
local ok, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
if not ok then return false, "Unable to decode JSON data." end
for _, option in next, decoded.objects do
local parser = ClassParser[option.type]
if parser then task.spawn(function() parser.Load(option.flag, option) end) end
end
return true
end
function DukeGUI:RefreshConfigList()
if isStudio or not (isfolder and listfiles) then return {} end
local dir = DukeGUI.Folder .. "/settings"
local out = {}
if not (isfolder(DukeGUI.Folder) and isfolder(dir)) then return out end
for _, file in ipairs(listfiles(dir)) do
local name = file:match("([^/\\]+)%.json$")
if name and name ~= "options" then out[#out + 1] = name end
end
return out
end
function DukeGUI:LoadAutoLoadConfig()
if isStudio or not (isfile and readfile) then return end
local f = DukeGUI.Folder .. "/settings/autoload.txt"
if isfile(f) then DukeGUI:LoadConfig(readfile(f)) end
end
if type(S) == "table" then S.DukeGUI = DukeGUI end
return DukeGUI
end)()
DukeGUI:SetFolder(DATA_DIR)
local CONFIG_NAME = "LineagePiece"
local START_CLOCK = os.clock()
local LOGO_PNG = "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"
local WORDMARK_PNG = "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"
local UI = { rows = {}, shown = {}, configLoading = true, applyingConfig = false, saveQueued = false, settingKeys = {} }

local Goal = {sellers = {}, questlines = {}, prev = {}, storageEvent = getRE("StorageEvent"), job = nil,
lastStart = -math.huge, lastBuy = -math.huge, lastSwap = -math.huge, raceOk = {}, raceAsked = {}, buyFails = {},
MODE_FLAGS = {dungeon = {"autoCreateDungeon", "autoStartDungeon", "autoKillAllDungeon", "autoLeaveDungeon"},
sea = {"autoPlaySea", "autoStartSea", "autoKillMobsSea", "autoPickBestCard", "autoLeaveSea"},
tower = {"autoStartTower", "autoKillAllTower"}}}
pcall(function() Goal.sellers = require(ReplicatedStorage.Shared.Data.Sellers) end)
pcall(function() Goal.questlines = require(ReplicatedStorage.Shared.Data.Questlines) end)
for id, q in pairs(Goal.questlines) do
if type(q) == "table" and q.Next then Goal.prev[q.Next] = id end
end
function Goal.num(v)
v = tonumber(v) or 0
if v >= 1e9 then return string.format("%.3gB", v / 1e9) end
if v >= 1e6 then return string.format("%.3gM", v / 1e6) end
if v >= 1e4 then return string.format("%.3gk", v / 1e3) end
return tostring(math.floor(v))
end

function Goal.toolSlot(name)
for _, holder in ipairs({player:FindFirstChild("Backpack") or false, player.Character or false}) do
local t = holder and holder:FindFirstChild(name)
if t and t:IsA("Tool") then return "hotbar", t end
end
local main
pcall(function() main = player.PlayerGui.ScreenGui.HUD.StorageFrame.Main end)
for _, frameName in ipairs({"WeaponFrame", "StyleFrame", "PowerFrame"}) do
local f = main and main:FindFirstChild(frameName)
if f and f:FindFirstChild(name) then return frameName end
end
return nil
end
function Goal.has(sell)
if type(sell) ~= "table" then return false end
if sell.Type == "Style" or sell.Type == "Weapon" or sell.Type == "Power" then return Goal.toolSlot(sell.Name) ~= nil end
if sell.Type == "Race" then return state.profile.Race == sell.Name end
if sell.Type == "Haki" then return state.profile[sell.Name == "Obs Haki" and "ObsHaki" or "BusoHaki"] == true end
return false
end
function Goal.sellerFor(kind, name)
for key, s in pairs(Goal.sellers) do
if type(s) == "table" and s.Sell and s.Sell.Type == kind and s.Sell.Name == name then return key end
end
return nil
end
function Goal.npc(name)
local root = workspace:FindFirstChild("NPC")
for _, folder in ipairs(root and root:GetChildren() or {}) do
local m = folder:FindFirstChild(name)
if m and m:IsA("Model") then return m end
end
return nil
end

pcall(function() Goal.crafts = require(ReplicatedStorage.Shared.Data.Crafts_Info) end)
Goal.CRAFT_NPC = {RealmList = "RSshop", SolemnList = "AngelaExchange"}
function Goal.sellerNpc(key)
local npc = Goal.npc(key)
if npc then return npc end
local craft = type(Goal.crafts) == "table" and Goal.crafts[key]
local name = type(craft) == "table" and Goal.CRAFT_NPC[craft.Parent]
return name and Goal.npc(name) or nil
end
function Goal.questlineNpc(head)
local root = workspace:FindFirstChild("NPC")
for _, folderName in ipairs({"Questline", "QuestlineAndSeller"}) do
local folder = root and root:FindFirstChild(folderName)
for _, m in ipairs(folder and folder:GetChildren() or {}) do
if m:GetAttribute("QuestlineId") == head then return m end
end
end
return nil
end
function Goal.head(id)
for _ = 1, 60 do
if not Goal.prev[id] then break end
id = Goal.prev[id]
end
return id
end
function Goal.stepText(id, progress, maxProgress)
local q = Goal.questlines[id]
if type(q) ~= "table" or type(q.Text) ~= "string" then return "#" .. tostring(id) end

local amount = maxProgress or q.Amount
local shown = amount and amount > 0 and Goal.num(amount) or "?"
local ok, text = pcall(string.format, q.Text, shown, Goal.num(progress or 0), shown)
return ok and text or q.Text
end

function Goal.matSource(item)
local info = ITEM_DROP_MAP[item]
if info then return info end
for _, name in ipairs(QUEST_TARGET_NAMES) do
for _, mat in ipairs(QUEST_RECIPES[name].materials) do
if mat.item == item then return mat end
end
end
local drop = Goal.bestSource(item)
if drop and drop.onMap then return {item = item, mob = drop.mob, after = drop.after} end
if drop then return {item = item, how = string.format(L("ดรอปจาก %s (ไม่อยู่บนแมพหลัก)", "drops from %s (not on the main map)"), drop.mob)} end
return nil
end

function Goal.dropList(item)
if not Goal.drops then
local enemies = {}
pcall(function() enemies = require(ReplicatedStorage.Shared.Data.Enemies) end)
local idx = {}
for name, e in pairs(enemies) do
if type(name) == "string" and type(e) == "table" then
local onMap = KNOWN_NAMES[string.lower(name)] == true
local function scan(loot)
for drop, info in pairs(type(loot) == "table" and loot or {}) do
local chance = type(info) == "table" and tonumber(info.Chance) or tonumber(info) or 0

local cond = type(info) == "table" and type(info.Req) == "table" and tonumber(info.Req.QuestlineId) or nil
idx[drop] = idx[drop] or {}
local entry
for _, s in ipairs(idx[drop]) do if s.mob == name then entry = s end end
if entry then entry.chance = math.max(entry.chance, chance)
else table.insert(idx[drop], {mob = name, chance = chance, onMap = onMap, boss = bossesData[name] ~= nil, after = cond}) end
end
end
if type(e.Drop) == "table" then scan(e.Drop.Loot) end
for _, d in pairs(type(e.Difficult) == "table" and e.Difficult or {}) do
if type(d) == "table" and type(d.Drop) == "table" then scan(d.Drop.Loot) end
end
end
end
Goal.drops = idx
end
return Goal.drops[item] or {}
end

function Goal.bestSource(item)
local tier = getCurrentTier()
local levelMob = tier and tier[3]
local best, bestScore = nil, -math.huge
for _, s in ipairs(Goal.dropList(item)) do
local locked = s.after and player:GetAttribute("Questline" .. s.after) ~= true
local score = (s.onMap and 1000 or 0) + (s.mob == levelMob and 500 or 0) + (s.boss and 0 or 200) - (locked and 300 or 0) + s.chance
if score > bestScore then best, bestScore = s, score end
end
return best
end

function Goal.liveOrbTarget()
local _, _, root = getCharParts()
if not root then return nil end
local now = os.clock()
if now < (state.orbPauseUntil or 0) then return nil end
local round = state.orbRound
local chanceByName = {}
for _, source in ipairs(Goal.dropList("Cursed Orb")) do
local name = string.lower(source.mob)
if (name == "miwa" or name == "sorcerer student" or name == "mahito")
and Goal.usable(source) and source.chance > 0 then
chanceByName[name] = source.chance
end
end
refreshMobIndex()
if not round then
round = {targets = {}, left = 0, captured = {}, hit = {}}
state.orbRound = round
logLine("ORB", "round started: Miwa, Sorcerer Student, Mahito")
end
local found = {}
for mob in pairs(mobIndex) do
local name = string.lower(mob.Name)
local chance = chanceByName[name]
if chance and not round.captured[name] and (state.avoidTargets[mob] or 0) <= now and liveMobRoot(mob) then
round.targets[mob] = chance
round.left = round.left + 1
found[name] = true
end
end
for name in pairs(found) do round.captured[name] = true end
for mob in pairs(round.targets) do
local mobRoot = liveMobRoot(mob)
if not mobRoot or (state.avoidTargets[mob] or 0) > now then
round.targets[mob] = nil
round.left = round.left - 1
end
end
for name in pairs(chanceByName) do
if round.captured[name] and not round.hit[name] then
local pending = false
for mob in pairs(round.targets) do
if string.lower(mob.Name) == name then pending = true break end
end
if not pending then round.captured[name] = nil end
end
end
local covered = round.hit.miwa and round.hit["sorcerer student"] and round.hit.mahito
if round.left <= 0 and covered then
state.orbRound = nil
state.orbWarpTarget = nil
state.orbPauseUntil = now + 10
logLine("ORB", "three kinds complete: pause 10 seconds")
return nil
end
local current = state.farmTarget
if current and round.targets[current] then return current end
local best, bestRate = nil, -math.huge
for mob, chance in pairs(round.targets) do
local mobRoot = liveMobRoot(mob)
local hum = mobRoot and mob:FindFirstChildOfClass("Humanoid")
if hum then
local distance = (root.Position - mobRoot.Position).Magnitude
local killSeconds = 1 + math.max(hum.Health, hum.MaxHealth * 0.5) / 18000
local rate = chance / (killSeconds + distance / 100)
if rate > bestRate then best, bestRate = mob, rate end
end
end
return best
end

Goal.merchantEvent = getRE("MerchantEvent")
Goal.merchantInfo = {}
pcall(function() Goal.merchantInfo = require(ReplicatedStorage.Shared.Data.Merchants_Info) end)
Goal.merchant = {window = nil, stock = {}, purchased = {}, asked = -math.huge}
if Goal.merchantEvent then
track(Goal.merchantEvent.OnClientEvent:Connect(function(action, payload)
if type(payload) ~= "table" then return end
if action == "Restock" then
Goal.merchant.window = math.floor(workspace:GetServerTimeNow() / 1200)
Goal.merchant.stock = type(payload.Stock) == "table" and payload.Stock or {}
Goal.merchant.purchased = type(payload.Purchased) == "table" and payload.Purchased or {}
elseif action == "Update" and type(payload.Purchased) == "table" then
Goal.merchant.purchased = payload.Purchased
end
end))
end
function Goal.merchantLeft(item)
local m = Goal.merchant
local window = math.floor(workspace:GetServerTimeNow() / 1200)
if Goal.merchantEvent and ((m.window ~= window and os.clock() - m.asked > 20) or os.clock() - m.asked > 120) then
m.asked = os.clock()
safe("GOAL", function() Goal.merchantEvent:FireServer("Request") end)
end
if m.window ~= window then return 0 end
return math.max(0, (tonumber(m.stock[item]) or 0) - (tonumber(m.purchased[item]) or 0))
end

function Goal.usable(src)
return src ~= nil and src.onMap ~= false and (src.mob ~= nil or src.anyMob) and not src.quest
and (not src.after or player:GetAttribute("Questline" .. src.after) == true)
end

function Goal.summonShort(name)
local data = bossesData[name]
local req = type(data) == "table" and type(data.Req) == "table" and data.Req or {}
local short = 0
for item, amount in pairs(type(req.Materials) == "table" and req.Materials or {}) do
local missing = (tonumber(amount) or 1) - (tonumber(state.inventory[item]) or 0)
if missing > 0 then
short = short + missing + (Goal.usable(Goal.bestSource(item)) and 0 or 1000)
end
end
if req.Coins and (tonumber(state.currency.Coins) or 0) < req.Coins then short = short + 1 end
if req.Gems and (tonumber(state.currency.Gems) or 0) < req.Gems then short = short + 1 end
return short
end

function Goal.typeSummon(bossType, needDiff)
local names = {}
for name, data in pairs(bossesData) do
if type(data) == "table" and data.Type == "Summon" and (not needDiff or data.Difficulty) and (not bossType or data.SummonType == bossType) then
names[#names + 1] = name
end
end
table.sort(names)
local best, bestShort = nil, math.huge
for _, name in ipairs(names) do
local short = Goal.summonShort(name)
if short < bestShort then best, bestShort = name, short end
end
return best, bestShort
end

function Goal.findTypedBoss(bossType, needDiff)
if not bossType and not needDiff then return findBossTarget("[All Spawned Bosses]") end
local _, _, root = getCharParts()
local best, bestDist = nil, math.huge
for name, data in pairs(bossesData) do
if type(data) == "table" and (not bossType or data.SummonType == bossType)
and (not needDiff or (data.Type == "Summon" and data.Difficulty)) then
local m = findBossTarget(name)
local r = m and (m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart)
if r and root and (r.Position - root.Position).Magnitude < bestDist then
best, bestDist = m, (r.Position - root.Position).Magnitude
end
end
end
return best
end

function Goal.summonFallback(job)
local boss
if job.kind == "boss" then
if Goal.findTypedBoss(job.bossType, job.diff ~= nil) then return job end
boss = Goal.typeSummon(job.bossType, job.diff ~= nil)
else
boss = job.kind == "kill" and job.target or (job.kind == "item" and job.mat and job.mat.mob) or nil
if boss and findBossTarget(boss) then return job end
end
local data = boss and bossesData[boss]
if not config.autoSummonForItems or type(data) ~= "table" or data.Type ~= "Summon" then return job end
local result = Goal.summonItems(boss, data)

if result and result ~= job and job.prefix then
result.prefix = job.prefix
result.text = job.prefix .. tostring(result.text)
end
return result or job
end
function Goal.summonItems(boss, data)
local req = type(data.Req) == "table" and data.Req or {}
local items = {}
for item, amount in pairs(type(req.Materials) == "table" and req.Materials or {}) do items[#items + 1] = {item, tonumber(amount) or 1} end
table.sort(items, function(a, b) return a[1] < b[1] end)
local coins = tonumber(state.currency.Coins) or 0
for _, m in ipairs(items) do
local item, need = m[1], m[2]
local have = tonumber(state.inventory[item]) or 0
if have < need then
local left = Goal.merchantLeft(item)
local price = type(Goal.merchantInfo[item]) == "table" and type(Goal.merchantInfo[item].Req) == "table" and tonumber(Goal.merchantInfo[item].Req.Coins) or nil
if left > 0 and price and coins >= price * left then
return {kind = "merchant", item = item, amount = left, via = boss,
text = string.format(L("ซื้อ %s %d ชิ้นจากพ่อค้าพเนจร ไว้อัญเชิญ %s", "Buying %d %s from the travelling merchant to summon %s"), item, left, boss)}
end
local src = Goal.bestSource(item)
if Goal.usable(src) then
local sourceName = item == "Cursed Orb" and L("มอนที่ดรอปได้", "available droppers") or src.mob
return {kind = "item", mat = {item = item, mob = src.mob}, via = boss,
text = string.format(L("ฟาร์ม %s %d/%d จาก %s ไว้อัญเชิญ %s (ระหว่างรอ)", "Farming %s %d/%d from %s to summon %s (meanwhile)"), item, have, need, sourceName, boss)}
end
return nil
end
end
if (req.Coins and coins < req.Coins) or (req.Gems and (tonumber(state.currency.Gems) or 0) < req.Gems) then
return {kind = "money", via = boss, text = string.format(L("หาเงินไว้อัญเชิญ %s", "Earning Coins/Gems to summon %s"), boss)}
end
return nil
end

function Goal.stepJob(id, progress, maxProgress)
local q = Goal.questlines[id] or {}
local t, tool = q.Type, q.SpecificTool
local text = Goal.stepText(id, progress, maxProgress)

local diffs = type(q.SpecificDifficulty) == "table" and q.SpecificDifficulty or nil
local diff = diffs and (table.find(diffs, config.itemSummonDifficulty) and config.itemSummonDifficulty or diffs[1]) or nil
if t == "KillSpecific" or t == "KillSpecificWithTool" then
local data = bossesData[q.SpecificTarget]
if type(data) == "table" and data.Type == "Summon" and not config.autoSummonForItems then
text = text .. L(" · รอคนอื่นอัญเชิญ (เปิด \"อัญเชิญบอสเมื่อไม่เจอ\" ในการ์ดการอัญเชิญบอสด้านล่าง ให้อัญเชิญเอง)", " · waiting for someone's summon (turn on \"Summon the boss when missing\" in the Boss summons card below to summon)")
end
return {kind = "kill", target = q.SpecificTarget, tool = tool, diff = diff, text = text}
elseif t == "KillBosses" then
return {kind = "boss", tool = tool, diff = diff, bossType = q.SpecificBossType, text = text}
elseif t == "KillNPCs" and not q.Mutation then
return {kind = "level", tool = tool, text = text}
elseif t == "DamageWithSpecific" or t == "M1Specific" or t == "UsingSkillSpecific" then
if q.SpecificRace and state.profile.Race ~= q.SpecificRace then
return {kind = "blocked", text = text .. L(" · ต้องเป็นเผ่า ", " · needs race ") .. q.SpecificRace}
end
return {kind = "level", tool = tool, skills = t == "UsingSkillSpecific", text = text}
elseif t == "Collecting" and q.Item then
local src = Goal.matSource(q.Item)
if src and (src.mob or src.anyMob) then return {kind = "item", mat = {item = q.Item, mob = src.mob, anyMob = src.anyMob, minDiff = src.minDiff}, text = text} end
return {kind = "blocked", text = text .. (src and src.how and (" · " .. src.how) or "")}
elseif t == "Interact" and q.InteractWith then
return {kind = "collect", group = q.InteractWith, text = text}
elseif t == "ClearSpecificPortal" and q.SpecificPortal then
local portalDiffs = type(q.Difficult) == "table" and q.Difficult or {"Easy"}
return {kind = "dungeon", portal = q.SpecificPortal, diff = portalDiffs[1], text = text}
elseif t == "ClearSimulatedSea" then
return {kind = "sea", tier = type(q.HardTier) == "table" and q.HardTier[1] or 1, text = text}
elseif t == "ReachFloor" then
return {kind = "tower", text = text}
elseif t == "FlameChaser" then
return {kind = "chaser", text = text}
end
return {kind = "blocked", text = text .. L(" · สคริปต์ทำขั้นนี้ให้ไม่ได้ ทำเองแล้วสคริปต์จะทำต่อ", " · the script can't do this step; do it and the script carries on")}
end

function Goal.analyze(key, depth, lines, costs)
local s = Goal.sellers[key]
if type(s) ~= "table" or type(s.Sell) ~= "table" then return {kind = "blocked", text = L("ไม่พบเป้าหมาย ", "Unknown target ") .. tostring(key)} end
local req = type(s.Req) == "table" and s.Req or {}
local pad = string.rep("    ", depth)
local job
local function line(ok, text)
if lines then lines[#lines + 1] = pad .. (ok and "✓ " or "· ") .. text end
end
local function want(j) job = job or j end
if depth == 0 or not Goal.has(s.Sell) then
if lines then lines[#lines + 1] = pad .. string.format("%s %s (%s)", depth == 0 and "◆" or "↳", s.Sell.Name, s.Sell.Type) end
end
if Goal.has(s.Sell) and depth == 0 then
line(true, L("มีแล้ว", "Already owned"))
return {kind = "done", key = key, text = L("ได้แล้ว", "Owned")}
end
if depth > 4 then return {kind = "blocked", text = L("เงื่อนไขซ้อนกันลึกเกินไป", "Requirements nest too deep")} end
if costs then
costs.coins = costs.coins + (tonumber(req.Coins) or 0)
costs.gems = costs.gems + (tonumber(req.Gems) or 0)
costs.buys[#costs.buys + 1] = s.Sell.Name
if s.Sell.Type == "Race" then costs.race = s.Sell.Name end
end

for _, kind in ipairs({"Weapon", "Style"}) do
local need = req[kind]
if need then
if Goal.toolSlot(need) then
line(true, kind .. ": " .. need)
else
local sub = Goal.sellerFor(kind, need)
line(false, kind .. ": " .. need)
if sub then want(Goal.analyze(sub, depth + 1, lines, costs))
else want({kind = "blocked", text = string.format(L("ต้องมี %s (ไม่มีร้านขาย หาเอง)", "Needs %s (no seller; get it yourself)"), need)}) end
end
end
end
for _, kind in ipairs({"Title", "Trait"}) do
local need = req[kind]
if need then
local ok = state.profile[kind] == need
line(ok, (kind == "Title" and L("ฉายา ", "Title ") or "Trait ") .. need)
if not ok then want({kind = "blocked", text = string.format(L("ต้องใส่ %s %s ก่อน (ทำเองในเกม)", "Needs %s %s equipped (do it in game)"), kind, need)}) end
end
end

local function keyed(j)
if not j or j.kind ~= "dungeon" then return j end
local p = portalsData[j.portal]
local keyItem = type(p) == "table" and p.Used or nil
if not keyItem or (tonumber(state.inventory[keyItem]) or 0) >= 1 then return j end
line(false, string.format(L("กุญแจ %s 0/1", "Key %s 0/1"), keyItem))
local craft = Goal.sellerFor("Material", keyItem)
if craft then return Goal.analyze(craft, depth + 1, lines, costs) end
local src = Goal.matSource(keyItem)
if Goal.usable(src) then
return {kind = "item", mat = {item = keyItem, mob = src.mob, anyMob = src.anyMob}, text = string.format(L("ฟาร์มกุญแจ %s", "Farming key %s"), keyItem)}
end
return {kind = "blocked", text = string.format(L("ต้องมี %s เพื่อเข้า %s", "Needs %s to enter %s"), keyItem, tostring(p.Name))}
end

local function questline(target, reach)
local head = Goal.head(target)
local active = player:GetAttribute("QuestlineId")
local inChain, step = false, nil
local id = head
for _ = 1, 40 do
if not id then break end
local done = player:GetAttribute("Questline" .. id) == true
if id == active then inChain = true end
local progress = id == active and player:GetAttribute("QuestlineProgress") or nil
local maxProgress = id == active and player:GetAttribute("QuestlineMaxProgress") or nil
line(done, L("เควสต์ ", "Quest ") .. id .. ": " .. Goal.stepText(id, progress, maxProgress)
.. ((reach and id == target) and L(" (ของดรอปช่วงนี้)", " (the drop happens here)") or ""))
if not done and not step then step = id end

if costs and id == head and not done and not (active and Goal.head(active) == head)
and type(Goal.questlines[id]) == "table" and type(Goal.questlines[id].FirstTimeReq) == "table" then
costs.coins = costs.coins + (tonumber(Goal.questlines[id].FirstTimeReq.Coins) or 0)
costs.gems = costs.gems + (tonumber(Goal.questlines[id].FirstTimeReq.Gems) or 0)
end
if id == target then break end
id = type(Goal.questlines[id]) == "table" and Goal.questlines[id].Next or nil
end
if not step or job or (reach and active == target) then return end
local q = type(Goal.questlines[step]) == "table" and Goal.questlines[step] or {}
local stepReq = type(q.Req) == "table" and q.Req or {}
if inChain then
want(keyed(Goal.stepJob(active, player:GetAttribute("QuestlineProgress"), player:GetAttribute("QuestlineMaxProgress"))))
elseif active then

local other = Goal.stepJob(active, player:GetAttribute("QuestlineProgress"), player:GetAttribute("QuestlineMaxProgress"))
if other.kind ~= "blocked" then
other.prefix = string.format(L("จบเควสต์ที่ค้าง (#%s) ก่อน · ", "Finishing the active questline (#%s) first · "), tostring(active))
other.text = other.prefix .. tostring(other.text)
want(keyed(other))
else
want({kind = "blocked", text = string.format(L("มีเควสต์สายอื่นค้างอยู่ (#%s) ที่สคริปต์ทำไม่ได้ · ทำให้จบ หรือกด \"ยกเลิกเควสต์ที่ค้าง\"", "Another questline (#%s) the script can't do is active · finish it or press \"Cancel active questline\""), tostring(active))})
end
elseif stepReq.Level and getPlayerLevel() < stepReq.Level then
want({kind = "level", text = string.format(L("เควสต์ %d ต้องเลเวล %d · ฟาร์มเลเวล", "Quest %d needs level %d · level farming"), step, stepReq.Level)})
elseif stepReq.Weapon and not Goal.toolSlot(stepReq.Weapon) then
local sub = Goal.sellerFor("Weapon", stepReq.Weapon)
want(sub and Goal.analyze(sub, depth + 1, lines, costs) or {kind = "blocked", text = L("เควสต์ต้องมี ", "The quest needs ") .. stepReq.Weapon})
elseif stepReq.Style and not Goal.toolSlot(stepReq.Style) then
local sub = Goal.sellerFor("Style", stepReq.Style)
want(sub and Goal.analyze(sub, depth + 1, lines, costs) or {kind = "blocked", text = L("เควสต์ต้องมี ", "The quest needs ") .. stepReq.Style})
elseif stepReq.Race and state.profile.Race ~= stepReq.Race then
want({kind = "blocked", text = string.format(L("เควสต์ %d ต้องเป็นเผ่า %s", "Quest %d needs race %s"), step, stepReq.Race)})
else
want({kind = "qstart", head = head, step = step, tool = stepReq.Weapon or stepReq.Style,
text = string.format(L("รับเควสต์ %d ที่ NPC", "Take quest %d at the NPC"), head)})
end
end
local qlTarget = tonumber(req.Questline)
if qlTarget then questline(qlTarget, false) end

local mats = {}
for item, amount in pairs(type(req.Materials) == "table" and req.Materials or {}) do mats[#mats + 1] = {item, amount} end
table.sort(mats, function(a, b) return a[1] < b[1] end)
for _, m in ipairs(mats) do
local item, amount = m[1], tonumber(m[2]) or 1
local have = tonumber(state.inventory[item]) or 0
line(have >= amount, string.format("%s %d/%d", item, have, amount))
if costs then costs.mats[#costs.mats + 1] = item .. " x" .. amount end
if have < amount and not job then
local src = Goal.matSource(item)
local craft = Goal.sellerFor("Material", item)
if src and (src.mob or src.anyMob) and src.after and player:GetAttribute("Questline" .. src.after) ~= true then

line(false, string.format(L("%s ดรอปหลังจบเควสต์ %d", "%s drops after quest %d is done"), item, src.after))
questline(src.after, false)
elseif src and (src.mob or src.anyMob) then
if not src.quest or player:GetAttribute("QuestlineId") == src.quest then
want({kind = "item", mat = {item = item, mob = src.mob, anyMob = src.anyMob, minDiff = src.minDiff}, text = string.format(L("ฟาร์ม %s %d/%d", "Farming %s %d/%d"), item, have, amount)})
elseif player:GetAttribute("Questline" .. src.quest) == true then
want({kind = "blocked", text = string.format(L("%s ดรอปเฉพาะตอนเควสต์ %d ค้างอยู่ ซึ่งทำจบไปแล้ว", "%s only drops while quest %d is active, and it is finished"), item, src.quest)})
else

questline(src.quest, true)
end
elseif src and src.dungeon and DNG_MAP[src.dungeon] then
want(keyed({kind = "dungeon", portal = DNG_MAP[src.dungeon], diff = config.selectDifficulty, text = string.format(L("ดันเจี้ยน %s เพื่อ %s %d/%d", "Dungeon %s for %s %d/%d"), src.dungeon, item, have, amount)}))
elseif craft then
want(Goal.analyze(craft, depth + 1, lines, costs))
else
want({kind = "blocked", text = string.format(L("%s %d/%d ต้องหาเอง%s", "%s %d/%d must be found by hand%s"), item, have, amount, src and src.how and (" · " .. src.how) or "")})
end
end
end
local coins, gems = tonumber(state.currency.Coins) or 0, tonumber(state.currency.Gems) or 0
for _, c in ipairs({{"Coins", coins}, {"Gems", gems}}) do
local need = tonumber(req[c[1]])
if need then
line(c[2] >= need, string.format("%s %s/%s", c[1], Goal.num(c[2]), Goal.num(need)))
if c[2] < need then want({kind = "money", text = string.format(L("หา %s %s/%s (ฟาร์มเควสต์เลเวล)", "Earning %s %s/%s (level quests)"), c[1], Goal.num(c[2]), Goal.num(need))}) end
end
end

if req.Race then
if state.profile.Race == req.Race then
line(true, L("เผ่า ", "Race ") .. req.Race)
else
local sub = Goal.sellerFor("Race", req.Race)
line(false, L("เผ่า ", "Race ") .. req.Race .. L(" (ตอนนี้ ", " (now ") .. tostring(state.profile.Race) .. ")")
if sub then want(Goal.analyze(sub, depth + 1, lines, costs))
else want({kind = "blocked", text = string.format(L("ต้องเป็นเผ่า %s (ไม่มีร้านขาย สุ่มเผ่าเอง)", "Needs race %s (no seller; reroll for it)"), req.Race)}) end
end
end
want({kind = "buy", key = key, race = s.Sell.Type == "Race", text = string.format(L("ซื้อ %s", "Buying %s"), s.Sell.Name)})
return job
end

function Goal.summary(key)
local costs = {coins = 0, gems = 0, buys = {}, mats = {}, race = nil}
Goal.analyze(key, 0, nil, costs)
local s = Goal.sellers[key]
local parts = {string.format(L("ซื้อ: %s", "Buys: %s"), table.concat(costs.buys, ", ")),
string.format(L("ใช้ Coins %s · Gems %s", "Spends %s Coins · %s Gems"), Goal.num(costs.coins), Goal.num(costs.gems))}
if #costs.mats > 0 then parts[#parts + 1] = L("ใช้ของ: ", "Uses: ") .. table.concat(costs.mats, ", ") end
if costs.race then parts[#parts + 1] = string.format(L("ต้องเปลี่ยนเผ่าเป็น %s (จะถามก่อนซื้อ)", "Changes your race to %s (asks first)"), costs.race) end
parts[#parts + 1] = L("ขั้นที่ต้องเข้าดันเจี้ยน/ทะเล/หอคอยจะใช้กุญแจหรือ Coins ต่อรอบ · บอสที่ต้องอัญเชิญใช้ของเมื่อเปิด \"อัญเชิญบอสเมื่อไม่เจอ\" (การ์ดการอัญเชิญบอส) ถ้าของอัญเชิญไม่พอ จะซื้อจากพ่อค้าพเนจร (Summon Core 15k Coins/ชิ้น) และฟาร์มจากมอนระหว่างรอ · สลับอาวุธ/สไตล์ในมือตามที่เควสต์ต้องการ",
"Dungeon/sea/tower steps spend keys or Coins per run · bosses are summoned only with \"Summon the boss when missing\" on (Boss summons card); short on summon items it buys them from the travelling merchant (Summon Core 15k Coins each) and farms them meanwhile · swaps the weapon/style in your hotbar as quests need")
return (s and s.Sell and s.Sell.Name or tostring(key)) .. "\n" .. table.concat(parts, "\n")
end

function Goal.equip(name, char, hum)
local slot, tool = Goal.toolSlot(name)
if slot == "hotbar" then
if tool.Parent ~= char then pcall(function() hum:EquipTool(tool) end) end
return tool
end
local action = slot == "WeaponFrame" and "ChangeWeapon" or slot == "StyleFrame" and "ChangeStyle" or slot == "PowerFrame" and "ChangePower" or nil
if action and Goal.storageEvent and os.clock() - Goal.lastSwap >= 8 then
Goal.lastSwap = os.clock()
logLine("GOAL", action .. " " .. name)
safe("GOAL", function() Goal.storageEvent:FireServer(action, {Name = name}) end)
end
return nil
end

function Goal.applyModes(job)
local kind = job and job.kind or nil
if kind == "dungeon" then
local name = type(portalsData[job.portal]) == "table" and portalsData[job.portal].Name

if name and config.selectDungeon ~= name then
config.selectDungeon = name
local dd = DukeGUI.Options.selectDungeon
if dd and dd:IsOption(name) then pcall(dd.UpdateSelection, dd, name) end
end
if job.diff and config.selectDifficulty ~= job.diff then
config.selectDifficulty = job.diff
local dd = DukeGUI.Options.selectDifficulty
if dd and dd:IsOption(job.diff) then pcall(dd.UpdateSelection, dd, job.diff) end
end
elseif kind == "sea" and config.selectSeaTier ~= tostring(job.tier) then
config.selectSeaTier = tostring(job.tier)
local dd = DukeGUI.Options.selectSeaTier
if dd and dd:IsOption(tostring(job.tier)) then pcall(dd.UpdateSelection, dd, tostring(job.tier)) end
end
local changed = false
for mode, flags in pairs(Goal.MODE_FLAGS) do
for _, flag in ipairs(flags) do
local want = kind == mode
if config[flag] ~= want then
config[flag] = want
UI.mirror(flag, want)
changed = true
end
end
end
if changed then
logLine("GOAL", "modes -> " .. tostring(kind))
UI.queueSave()
end
end
local function setupMenu()
local menuScale = { auto = true, pct = 100, now = 1, w = 860, h = 640 }
local windowSizes = { desktop = {860, 640} }
for _, device in ipairs({"desktop", "mobilePortrait", "mobileLandscape"}) do
local file = DATA_DIR .. "/window_" .. device .. ".txt"
pcall(function()
if not (isfile and readfile and isfile(file)) then return end
local w, h = readfile(file):match("^(%d+),(%d+)$")
w, h = tonumber(w), tonumber(h)
if w and h and w >= 280 and w <= 1400 and h >= 300 and h <= 1100 then windowSizes[device] = {w, h} end
end)
end
local function viewport()
local vp = W and W.Gui.AbsoluteSize or Vector2.zero
if vp.X < 50 or vp.Y < 50 then vp = workspace.CurrentCamera.ViewportSize end
return vp
end
local function deviceKey(vp)
if (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) or vp.X < 720 then
return vp.X > vp.Y and "mobileLandscape" or "mobilePortrait"
end
return "desktop"
end
local function fitScale()
local vp = viewport()
local margin = menuScale.device == "desktop" and 0.9 or 0.97
return math.min(vp.X * 0.97 / menuScale.w, vp.Y * margin / menuScale.h)
end
local function applyMenuScale()
local vp = viewport()
local device = deviceKey(vp)
local dimensions = windowSizes[device]
if not dimensions then
dimensions = {
math.max(280, math.min(device == "mobileLandscape" and 900 or 620, vp.X - 20)),
math.max(300, math.min(device == "mobileLandscape" and 500 or 780, vp.Y - 20)),
}
end
if menuScale.device ~= device or (not windowSizes[device] and (menuScale.w ~= dimensions[1] or menuScale.h ~= dimensions[2])) then
menuScale.device = device
menuScale.w, menuScale.h = dimensions[1], dimensions[2]
W:SetSize(UDim2.fromOffset(menuScale.w, menuScale.h))
end
local fit = fitScale()
menuScale.now = math.max(0.2, math.min(menuScale.auto and 1 or menuScale.pct / 100, fit))
W:SetScale(menuScale.now)
task.defer(function() if W and W.Gui.Parent then W:KeepOnScreen() end end)
end
local function createWindow()
W = DukeGUI:Window({
Title = HUB_NAME, Subtitle = "Lineage Piece · v" .. VERSION, GuiName = "DukeHub",
Logo = LOGO_PNG,
Wordmark = WORDMARK_PNG,
Size = UDim2.fromOffset(860, 640), Keybind = Enum.KeyCode.RightControl,
})
W._onResized = function(w, h)
local device = menuScale.device or deviceKey(viewport())
local dimensions = windowSizes[device] or {}
windowSizes[device] = dimensions
dimensions[1], dimensions[2] = math.floor(w + 0.5), math.floor(h + 0.5)
menuScale.w, menuScale.h = dimensions[1], dimensions[2]
pcall(function()
if writefile then writefile(DATA_DIR .. "/window_" .. device .. ".txt", string.format("%d,%d", dimensions[1], dimensions[2])) end
end)
applyMenuScale()
end
W.onUnloaded(function()
local inst = env.LineageHubInstance
if inst and type(inst.Destroy) == "function" then pcall(inst.Destroy) end
end)
W.Gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
if menuScale.auto then applyMenuScale() end
end)
applyMenuScale()
end
function UI.notify(text)
W:Notify({ Title = HUB_NAME, Description = text, Lifetime = 3 })
end
function UI.action(tag, gap, fn)
local last = 0
return function(...)
if os.clock() - last < gap then return end
last = os.clock()
local args = table.pack(...)
task.spawn(function() safe("UI:" .. tag, fn, table.unpack(args, 1, args.n)) end)
end
end
function UI.queueSave()
if UI.configLoading or UI.saveQueued then return end
UI.saveQueued = true
task.delay(1, function()
UI.saveQueued = false
if state.alive then
local ok, err = DukeGUI:SaveConfig(CONFIG_NAME)
if not ok then logLine("CONFIG", "save failed: " .. tostring(err)) end
end
end)
end
function UI.set(key, after)
return function(v)
config[key] = v
if after then after(v) end
UI.queueSave()
end
end
function UI.setMap(tbl, keys, after)
return function(picked)
picked = picked or {}
for _, k in ipairs(keys) do tbl[k] = picked[k] == true end
if after then after() end
UI.queueSave()
end
end
local function keysOn(tbl, keys)
local out = {}
for _, k in ipairs(keys) do if tbl[k] then out[#out + 1] = k end end
return out
end
function UI.mirror(flag, v)
local o = DukeGUI.Options[flag]
if o and o.Class == "Toggle" and o.State ~= v then o:UpdateState(v) end
end
function UI.confirm(title, desc, onYes, onNo)
if UI.applyingConfig then onYes() return end
W:Dialog({
Title = title, Description = desc,
Buttons = {
{ Name = L("ยืนยัน", "Confirm"), Callback = onYes },
{ Name = L("ยกเลิก", "Cancel"), Callback = onNo },
},
})
end
function UI.dangerToggle(card, flag, name, desc, apply)
return card:Toggle({
Name = name, Description = desc, Danger = true, Default = config[flag] == true,
Callback = function(v)
if v and not config[flag] then
UI.confirm(name, desc or "", function()
config[flag] = true
logLine("SPEND", flag .. " = ON")
if apply then apply(true) end
UI.queueSave()
end, function() UI.mirror(flag, false) end)
elseif not v then
config[flag] = false
if apply then apply(false) end
UI.queueSave()
end
end,
}, flag)
end
function UI.statusRow(card, get, name)
local row = card:Status({ Name = name or L("สถานะ", "Status"), Text = "-", Tone = "off" })
UI.rows[#UI.rows + 1] = { row = row, get = get }
return row
end
function UI.valueRow(row, get)
UI.rows[#UI.rows + 1] = { row = row, get = get, value = true }
return row
end
function UI.textRow(get, set)
UI.rows[#UI.rows + 1] = { get = get, set = set }
end
function UI.settingToggle(card, flag, key, name, desc, danger)
UI.settingKeys[flag] = key
local function send(v)
if settingEvent and player:GetAttribute(key) ~= v then
logLine(danger and "SPEND" or "SETTING", key .. " = " .. tostring(v))
safe("SETTING", function() settingEvent:FireServer(key, v) end)
end
end
local t = card:Toggle({
Name = name, Description = desc, Danger = danger, Default = player:GetAttribute(key) == true,
Callback = function(v)
if v and danger and player:GetAttribute(key) ~= true then
UI.confirm(name, desc or "", function() send(true) end, function() UI.mirror(flag, false) end)
else
send(v)
end
end,
}, flag)
t.IgnoreConfig = true
return t
end
track(player.AttributeChanged:Connect(function(attr)
for flag, key in pairs(UI.settingKeys) do
if key == attr then UI.mirror(flag, player:GetAttribute(key) == true) end
end
end))
local function modelRoot(model)
return model and (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model.PrimaryPart)
end
local function warpAbove(model)
local r = modelRoot(model)
if r then moveTo(CFrame.new(r.Position + Vector3.new(0, config.farmHeight, 0), r.Position)) end
return r ~= nil
end
local function selectedMobName()
local tier = Farm.selectedTier()
return tier and tier[3] or Farm.mobName(config.selectedMonster)
end

function UI.choice(card, flag, key, name, desc, labels, values)
local dd
local function labelOf(v)
for i, x in ipairs(values) do if x == v then return labels[i] end end
return labels[1]
end
dd = card:Dropdown({ Name = name, Description = desc, Options = labels, Default = labelOf(config[key]),
Callback = function(label)
local i = label and table.find(labels, label)
if not i then
task.defer(function() if dd and dd.Value == nil then dd:UpdateSelection(labelOf(config[key])) end end)
return
end
config[key] = values[i]
UI.queueSave()
end }, flag)
return dd
end
local function buildLevelPage(tab)
local lv = tab:Section()
lv:Header({ Name = L("ฟาร์มเลเวล", "Level farm"), Description = L("รับเควสต์ตามเลเวลให้เอง เลเวลถึงช่วงใหม่เปลี่ยนเควสต์ทันที แล้วตีจากเหนือหัวมอน", "Takes the quest for your level, switches the moment you reach a new tier, and attacks from above") })
lv:Toggle({ Name = L("ฟาร์มเลเวล + เควสต์อัตโนมัติ", "Level farm + auto quest"), Default = config.autoFarm, Callback = UI.set("autoFarm") }, "autoFarm")
UI.statusRow(lv, function()
if not config.autoFarm then return L("ปิด", "Off"), "off" end
if state.worldBossUp and config.autoFarmWorldBoss then return L("พักไปตีบอสโลก ", "Paused for world boss ") .. tostring(state.statusTarget or ""), "wait" end
if state.questBusy then return L("กำลังรับเควสต์ ", "Taking quest ") .. tostring(state.levelQuest or ""), "run" end
if state.statusTarget then return L("ตี ", "Attacking ") .. state.statusTarget, "run" end
return L("รอมอนเกิด", "Waiting for a monster"), "wait"
end)
local options = { "[Auto Level Progression]" }
for _, t in ipairs(Farm.questTiers()) do options[#options + 1] = t[5] end
lv:Dropdown({ Name = L("เควสต์", "Quest"), Description = L("Auto = ช่วงตามเลเวล (ช่วงอ่านจากป้าย NPC ในเกม)", "Auto = the tier for your level (ranges read from the in-game NPC signs)"),
Options = options, Default = table.find(options, config.selectedMonster) and config.selectedMonster or options[1],
Callback = function(v)
if not v then return end
config.selectedMonster = v
state.lastQuest = 0
UI.queueSave()
end }, "levelQuestPick")
UI.choice(lv, "questSkip", "questSkip", L("ข้ามเวล", "Skip levels"),
L("ใช้กับ Auto · รับเควสต์ช่วงที่สูงกว่าเลเวล · ตายหรือถอยระหว่างข้ามจะลดลง 1 ช่วง · \"EXP คุ้มสุด\" วัด EXP/นาทีจริงของทุกเควสต์แล้วเลือกตัวที่ได้มากสุด ไม่สนเลเวล (เกมให้เควสต์ทุกช่วงกับทุกเลเวล)", "Auto only · takes a higher tier's quest · dying or retreating while skipping drops one tier · \"Best EXP\" measures each quest's real EXP/min and keeps the best, any level (the game gives every quest to every level)"),
{ L("ไม่ข้าม (ตามเลเวล)", "Off (your level)"), L("ข้ามขึ้น 1 ช่วง", "1 tier up"), L("ข้ามขึ้น 2 ช่วง", "2 tiers up"), L("สูงสุดที่ NPC ให้", "Highest the NPC gives"), L("EXP คุ้มสุด (วัดจริง)", "Best EXP (measured)") },
{ 0, 1, 2, 99, 100 })
UI.valueRow(lv:Value({ Name = L("เควสต์ตอนนี้", "Current quest"), Text = "-" }), function()
local tier = Farm.selectedTier()
if not tier then return Farm.mobName(config.selectedMonster) .. L(" (ไม่มีเควสต์)", " (no quest)") end
local text = tier[5]
if Farm.inUse > 0 then text = text .. string.format(L(" · ข้าม +%d", " · skip +%d"), Farm.inUse) end
if Farm.penalty > 0 then text = text .. string.format(L(" · ลดลง %d", " · down %d"), Farm.penalty) end
return text
end)
lv:Buttons({
{ Name = L("วาร์ปไปมอน", "Warp to monster"), Callback = UI.action("warpMob", 0.5, function()
if not warpAbove(findTargetMob(selectedMobName())) then UI.notify(L("ไม่พบมอนในแมพตอนนี้", "No monster found right now")) end
end) },
{ Name = L("ลองข้ามเวลใหม่", "Retry skipping"), Callback = UI.action("retakeQuest", 1, function()
table.clear(Farm.locked)
Farm.penalty = 0
state.lastQuest = 0
state.questFails = 0
UI.notify(L("ล้างช่วงที่ถูกล็อกแล้ว · จะรับเควสต์ใหม่", "Cleared locked tiers · the quest will be taken again"))
end) },
})
local nq = tab:Section()
nq:Header({ Name = L("ฟาร์มไม่รับเควส", "Farm without quest") })
nq:Toggle({ Name = L("ตีมอนที่เลือก", "Attack the selected monster"), Default = config.autoFarmNoQuest, Callback = UI.set("autoFarmNoQuest") }, "autoFarmNoQuest")
nq:Dropdown({ Name = L("มอนสเตอร์", "Monster"), Options = ALL_MOBS, Default = config.selectedMonsterNoQuest, Search = true, Callback = UI.set("selectedMonsterNoQuest") }, "selectedMonsterNoQuest")
end
local GOAL_TABS = { "Style", "Weapon", "Race", "Power", "Haki", "Mastery", "Material" }
local function buildGoalPage(tab)
local items, byName, nameOf = {}, {}, {}
local keys = {}
for key, s in pairs(Goal.sellers) do
if type(s) == "table" and type(s.Sell) == "table" and (table.find(GOAL_TABS, s.Sell.Type) or s.Sell.Type == "Unlocked") then keys[#keys + 1] = key end
end

local TYPE_ORDER = { Style = 1, Weapon = 1, Race = 1, Power = 1, Haki = 1 }
table.sort(keys, function(a, b)
local ta, tb = TYPE_ORDER[Goal.sellers[a].Sell.Type] or 2, TYPE_ORDER[Goal.sellers[b].Sell.Type] or 2
if ta ~= tb then return ta < tb end
return a < b
end)
for _, key in ipairs(keys) do
local sell = Goal.sellers[key].Sell
local name = sell.Name
if byName[name] then name = name .. " (" .. sell.Type .. ")" end
byName[name], nameOf[key] = key, name

byName[sell.Name .. " (" .. sell.Type .. ")"] = byName[sell.Name .. " (" .. sell.Type .. ")"] or key
items[#items + 1] = { Name = name, Rarity = sell.Type == "Unlocked" and "Mastery" or sell.Type, Model = function() return Goal.sellerNpc(key) end }
end
table.sort(items, function(a, b) return a.Name < b.Name end)
local gp = tab:Section()
gp:Header({ Name = L("ทำเป้าหมายจนได้", "Get it all done"),
Description = L("เลือกสไตล์/อาวุธ/เผ่า แล้วสคริปต์หาอาวุธที่ต้องมีก่อน รับเควสต์และทำทีละขั้น ฟาร์มของที่ขาด หาเงิน แล้วซื้อให้",
"Pick a style/weapon/race: the script gets what it requires, takes and runs the questline, farms what is missing, earns the Coins/Gems, then buys it") })
local picker
picker = gp:EggPicker({ Name = L("เป้าหมาย", "Target"), Single = true, Items = items, Rarities = GOAL_TABS, Default = { nameOf[config.goalTarget] or items[1].Name },
Callback = function(names)
local key = names and names[1] and byName[names[1]]

if key and names[1] ~= nameOf[key] then
task.defer(function() picker:UpdateSelection({ nameOf[key] }) end)
end
if not key or key == config.goalTarget then return end
config.goalTarget = key
Goal.doneKey, Goal.buyFails = nil, {}
UI.queueSave()
end }, "goalTarget")
gp:Toggle({ Name = L("ทำจนได้อัตโนมัติ", "Do it all automatically"), Danger = true, Default = config.autoGoal,
Description = L("ใช้ Coins/Gems/ของตามที่ร้านต้องการ · ถามก่อนเปลี่ยนเผ่า · ปิดโหมดฟาร์มอื่นระหว่างทำ", "Spends the seller's Coins/Gems/materials · asks before a race change · turns the other farm modes off"),
Callback = function(v)
if v and not config.autoGoal then
UI.confirm(L("ทำเป้าหมายนี้จนได้?", "Run this goal to the end?"), Goal.summary(config.goalTarget), function()
config.autoGoal = true
Goal.raceAsked, Goal.buyFails, Goal.doneKey = {}, {}, nil

if not UI.applyingConfig then
for _, flag in ipairs(Rank.FARM_MODE_FLAGS) do
if flag ~= "autoGoal" and config[flag] then config[flag] = false UI.mirror(flag, false) end
end
logLine("SPEND", "auto goal ON " .. tostring(config.goalTarget) .. " | " .. costText(nil))
end
state.token = state.token + 1
state.farmTarget = nil
cancelMotion()
UI.queueSave()
end, function() UI.mirror("autoGoal", false) end)
elseif not v and config.autoGoal then
config.autoGoal = false

Goal.applyModes(nil)
releaseAutoSummon("goal off")
UI.queueSave()
end
end }, "autoGoal")
gp:Toggle({ Name = L("ไม่ซื้อตัวสุดท้าย", "Don't buy the target"),
Description = L("ทำเควสต์และฟาร์มของให้ครบ แล้วหยุดให้คุณไปซื้อเอง (ของที่ต้องมีก่อน เช่น กุญแจ ยังซื้อให้)", "Runs the questline and farms everything, then stops so you buy it yourself (prerequisites like keys are still bought)"),
Default = config.goalNoBuy, Callback = UI.set("goalNoBuy") }, "goalNoBuy")
UI.statusRow(gp, function()
if not config.autoGoal then return L("ปิด", "Off"), "off" end
local st = Goal.status
if not st then return L("กำลังวางแผน...", "Planning..."), "wait" end
local text = st[1]
if state.statusTarget and st[2] == "run" then text = text .. L(" · ตี ", " · attacking ") .. state.statusTarget end

local b, job = state.summonBlocked, Goal.job
if b and job and not state.statusTarget and (job.target == b.boss or (job.mat and job.mat.mob == b.boss)) then
return text .. string.format(L(" · อัญเชิญไม่ได้ ขาด %s · รอคนอื่นอัญเชิญ", " · can't summon, missing %s · waiting for someone's summon"), b.missing), "wait"
end
return text, st[2]
end)
local plan = gp:Paragraph({ Header = L("แผน", "Plan"), Body = "..." })
local shownOwned = {}
UI.textRow(function()
if not state.inventoryInit then return L("กำลังอ่านกระเป๋า...", "Reading inventory...") end
local lines = {}
Goal.analyze(config.goalTarget, 0, lines)
for _, key in ipairs(keys) do
local owned = Goal.has(Goal.sellers[key].Sell)
if owned ~= shownOwned[key] then
shownOwned[key] = owned
pcall(picker.SetInfo, picker, nameOf[key], owned and L("มีแล้ว", "Owned") or nil, owned and "done" or nil)
end
end
return table.concat(lines, "\n")
end, function(body) plan:UpdateBody(body) end)
gp:Buttons({
{ Name = L("วาร์ปไป NPC", "Warp to the NPC"), Callback = UI.action("goalNpc", 1, function()
local npc = Goal.sellerNpc(config.goalTarget)
local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
if part then moveTo(part.CFrame + part.CFrame.LookVector * 4, nil, "Teleport") else UI.notify(L("ไม่พบ NPC บนแมพนี้", "NPC not found on this map")) end
end) },
{ Name = L("ยกเลิกเควสต์ที่ค้าง", "Cancel active questline"), Callback = UI.action("goalCancelQl", 1, function()
local active = player:GetAttribute("QuestlineId")
if not active or not questlineRemote then return UI.notify(L("ไม่มีเควสต์สายที่ค้างอยู่", "No active questline")) end
UI.confirm(L("ยกเลิกเควสต์สาย?", "Cancel the questline?"), Goal.stepText(active, player:GetAttribute("QuestlineProgress"), player:GetAttribute("QuestlineMaxProgress"))
.. L(" · ความคืบหน้าขั้นนี้จะหาย", " · this step's progress is lost"), function()
logLine("GOAL", "cancel questline " .. tostring(active))
questlineRemote:FireServer("Cancel")
end)
end) },
})
end
local function buildFarmSettingsPage(tab)
local mv = tab:Section()
mv:Header({ Name = L("การเคลื่อนที่ & ความปลอดภัย", "Movement & safety"), Description = L("ใช้กับทุกโหมดฟาร์ม", "Applies to every farm mode") })
mv:Dropdown({ Name = L("การเคลื่อนที่", "Movement"), Options = { "Teleport", "Tween" }, Default = config.farmMovement, Callback = UI.set("farmMovement", function(v)
if v == "Teleport" then cancelMotion() end
end) }, "farmMovement")
mv:Dropdown({ Name = L("ความสูงเหนือมอน", "Height above monster"), Description = L("ยืนเหนือหัวเป้าหมายเสมอ · ปรับความสูงให้การโจมตีโดนตามต้องการ", "Always stays above the target · adjust height so attacks connect"),
Options = { "3", "4", "5", "6", "7", "8", "9", "10", "12", "14", "15", "16", "18", "20" }, Default = tostring(config.farmHeight),
Callback = function(v) config.farmHeight = tonumber(v) or 16 UI.queueSave() end }, "farmHeight")
mv:Dropdown({ Name = L("ความเร็ว Tween", "Tween speed"), Description = L("ยิ่งเร็วยิ่งเสี่ยงโดนเกมเตะ", "Faster = higher kick risk"),
Options = { "80", "120", "150" }, Default = tostring(config.tweenSpeed),
Callback = function(v) config.tweenSpeed = tonumber(v) or 150 UI.queueSave() end }, "tweenSpeed")
mv:Toggle({ Name = L("ถอยเมื่อเลือดต่ำ", "Retreat on low HP"),
Description = L("เลือดต่ำกว่า 35% ถอยไปพัก กลับมาตีเมื่อเลือด 80%", "Below 35% HP backs off, comes back at 80%"),
Default = config.autoRetreat, Callback = UI.set("autoRetreat", function(v)
if not v then state.retreat = nil end
end) }, "autoRetreat")
mv:Toggle({ Name = L("หยุดเมื่อตายซ้ำ", "Stop after repeated deaths"),
Description = L("ตาย 3 ครั้งใน 3 นาที → ปิดทุกโหมดที่ขยับตัวละคร", "3 deaths in 3 minutes → turns off every mode that moves the character"),
Default = config.stopOnDeaths, Callback = UI.set("stopOnDeaths") }, "stopOnDeaths")
mv:Buttons({
{ Name = L("บันทึกจุดเซฟ", "Save safe spot"), Callback = UI.action("saveSpot", 0.5, function()
local _, _, root = getCharParts()
if root then state.safeSpot = root.CFrame UI.notify(L("บันทึกจุดเซฟแล้ว", "Safe spot saved")) end
end) },
{ Name = L("กลับจุดเซฟ", "Back to safe spot"), Callback = UI.action("backSpot", 0.5, function()
if state.safeSpot then moveTo(state.safeSpot) end
end) },
})
local sk = tab:Section()
sk:Header({ Name = L("สกิลอาวุธ", "Weapon skills") })
sk:Toggle({ Name = L("ใช้สกิลอัตโนมัติ", "Auto skills"), Default = config.autoSkill, Callback = UI.set("autoSkill", function() syncNativeAutoSkills() end) }, "autoSkill")
sk:Dropdown({
Name = L("ปุ่มสกิล", "Skill keys"), Multi = true, Options = skillOrder, Default = keysOn(config.skillKeys, skillOrder),
Callback = UI.setMap(config.skillKeys, skillOrder, function() syncNativeAutoSkills() end),
}, "skillKeys")
UI.valueRow(sk:Value({ Name = L("สกิลล่าสุด", "Last skill"), Text = "-" }), function()
if state.lastSkillUsed then return state.lastSkillUsed end

local native = {}
for _, key in ipairs(skillOrder) do
if nativeAutoEnabled(key) == true then native[#native + 1] = key end
end
return #native > 0 and (L("เกมกดให้อัตโนมัติ: ", "Game auto skill: ") .. table.concat(native, " ")) or "-"
end):SetNested(true)
end
local BOSS_TIMED = L("บอสเวลา", "Timed")
local BOSS_GROUPS = { "Normal", "JJK", "Bleach", "Shinjuku", "Elysian", BOSS_TIMED }
local function bossItems(opts)
local items = {}
if opts.all then items[1] = { Name = "[All Spawned Bosses]", Rarity = L("ทุกตัวที่เกิด", "Any spawned") } end
local enemies = ReplicatedStorage:FindFirstChild("Enemies")
for _, name in ipairs(BOSSES) do
local d = bossesData[name] or {}
if not opts.summonOnly or d.Type == "Summon" then
items[#items + 1] = {
Name = name,
Rarity = (d.Type == "Time" or d.Type == "Castorice" or name == "Stone") and BOSS_TIMED or (d.SummonType or "Normal"),
Model = enemies and enemies:FindFirstChild(name),
}
end
end
return items
end
local function bossPicker(card, key, name, opts, after)
return card:EggPicker({
Name = name, Single = true, Items = bossItems(opts), Rarities = BOSS_GROUPS, Default = { config[key] },
Callback = function(names)
local v = names and names[1]
if not v then return end
config[key] = v
if after then after(v) end
UI.queueSave()
end,
}, key)
end

local function worldBossPicks()
local picks = config.worldBosses
local all = table.find(picks, "[All Spawned Bosses]") ~= nil
return picks, all
end
local function buildWorldBossPage(tab)
local wb = tab:Section()
wb:Header({ Name = L("บอสโลก", "World bosses"),
Description = L("ตีบอสที่เลือกเมื่อเกิด (เลือกได้หลายตัว) · ระหว่างรอ โหมดฟาร์มอื่นที่เปิดไว้ทำงานต่อ แล้วกลับมาตีบอสเมื่อเกิด",
"Attacks the picked bosses when they spawn (pick several) · while waiting, any other farm mode you turned on keeps running") })
wb:Toggle({ Name = L("ตีบอสโลก", "Farm world bosses"), Default = config.autoFarmWorldBoss, Callback = UI.set("autoFarmWorldBoss") }, "autoFarmWorldBoss")
UI.statusRow(wb, function()
if not config.autoFarmWorldBoss then return L("ปิด", "Off"), "off" end
if state.worldBossUp and state.statusTarget then return L("ตี ", "Attacking ") .. state.statusTarget, "run" end
local picks, all = worldBossPicks()
if #picks == 0 then return L("ยังไม่ได้เลือกบอส", "No boss picked"), "bad" end
local nextName, nextEta
for name, t in pairs(Farm.bossTimes()) do
if (all or table.find(picks, name)) and t.eta and (not nextEta or t.eta < nextEta) then nextName, nextEta = name, t.eta end
end
local text = nextName and string.format(L("รอ %s · เกิดใน %s", "Waiting for %s · spawns in %s"), nextName, Farm.clock(nextEta)) or L("รอบอสเกิด", "Waiting for a boss")
if state.statusTarget then text = text .. L(" · ระหว่างรอตี ", " · meanwhile attacking ") .. state.statusTarget end
return text, "wait"
end)
local groups = { BOSS_TIMED }
for i = 1, #BOSS_GROUPS - 1 do groups[#groups + 1] = BOSS_GROUPS[i] end
local picker = wb:EggPicker({ Name = L("บอส", "Bosses"), Description = L("เลือกได้หลายตัว · ตีตัวที่ใกล้ที่สุดก่อน", "Pick several · the nearest one goes first"),
Items = bossItems({ all = true }), Rarities = groups, Default = config.worldBosses,
Callback = function(names)
config.worldBosses = names or {}
state.lastBossSeenTime = nil
UI.queueSave()
end }, "selectedWorldBoss")
local timers = wb:Paragraph({ Header = L("เวลาเกิด", "Spawn times"), Body = "..." })
local shownInfo = {}
UI.textRow(function()
local times = Farm.bossTimes()
local picks, all = worldBossPicks()
local rows = {}
for _, name in ipairs(BOSSES) do
local d = bossesData[name] or {}
local timed = d.Type == "Time" or d.Type == "Castorice" or name == "Stone"
local t = times[name]
local info, tone
if t and t.alive then
info, tone = L("เกิดแล้ว", "Up now"), "run"
elseif t and t.eta then
info, tone = Farm.clock(t.eta), "wait"
end
if info ~= shownInfo[name] then
shownInfo[name] = info
pcall(picker.SetInfo, picker, name, info, tone)
end
if timed or (t and t.alive) or (not all and table.find(picks, name)) then
local line
if t and t.alive then line = L("เกิดแล้ว", "up now")
elseif t and t.eta then line = string.format(L("เกิดใน %s", "in %s"), Farm.clock(t.eta)) .. (t.approx and L(" (ทุก 20 นาที)", " (every 20 min)") or "")
elseif name == "Rimuru" then line = L("ใส่ Slime Orb ที่ Fossil Island ก่อน", "needs Slime Orbs at Fossil Island")
elseif timed then line = L("ไม่มีตัวจับเวลาในห้องนี้", "no timer in this server")
else line = L("รอมีคนอัญเชิญ", "waits for a summon") end
local mark = (all or table.find(picks, name)) and "● " or "· "
rows[#rows + 1] = { t and t.alive and -1 or (t and t.eta) or math.huge, mark .. (name == "Stone" and "Huge Stone" or name) .. "  " .. line }
end
end
table.sort(rows, function(a, b) return a[1] < b[1] end)
local out = {}
for _, r in ipairs(rows) do out[#out + 1] = r[2] end
return table.concat(out, "\n")
end, function(body) timers:UpdateBody(body) end)
wb:Toggle({ Name = L("ย้ายห้องเมื่อไม่มีบอส", "Server hop when no boss"),
Description = L("ไม่มีบอสที่เลือกเกิน 25 วิ และไม่มีตัวไหนจะเกิดใน 90 วิ → ย้ายห้อง", "No picked boss for 25 s and none spawns within 90 s → hop"),
Default = config.autoHopBoss, Callback = UI.set("autoHopBoss") }, "autoHopBoss")
wb:Button({ Name = L("วาร์ปไปบอสที่เกิดอยู่", "Warp to a spawned boss"), Callback = UI.action("warpBoss", 0.5, function()
local picks, all = worldBossPicks()
local target = all and findBossTarget("[All Spawned Bosses]")
if not all then
for _, name in ipairs(picks) do target = target or findBossTarget(name) end
end
if not warpAbove(target) then UI.notify(L("บอสที่เลือกยังไม่เกิด", "None of the picked bosses is up")) end
end) })
end
local function buildSummonPage(tab)
local sm = tab:Section()
sm:Header({ Name = L("บอสอัญเชิญ", "Summon boss"), Description = L("อัญเชิญเองหรือเปิดอัญเชิญอัตโนมัติของเกม แล้วตีบอสที่อัญเชิญ", "Summon by hand or turn on the game's auto summon, then attack the summoned boss") })
local req = sm:Label({ Text = bossRequirements(bossesData[config.selectedBoss], config.selectedBoss) })
bossPicker(sm, "selectedBoss", L("บอส", "Boss"), { summonOnly = true }, function(v) req:UpdateName(bossRequirements(bossesData[v], v)) end)
sm:Dropdown({ Name = L("ความยาก", "Difficulty"), Options = { "Easy", "Medium", "Hard", "Extreme" }, Default = config.bossDifficulty, Callback = UI.set("bossDifficulty") }, "bossDifficulty")
sm:Toggle({ Name = L("ตีบอสที่อัญเชิญ", "Farm the summoned boss"), Default = config.autoFarmSummonedBoss, Callback = UI.set("autoFarmSummonedBoss") }, "autoFarmSummonedBoss")
sm:Button({ Name = L("อัญเชิญตอนนี้", "Summon now"), Callback = UI.action("summonNow", 1, function()
UI.confirm(L("อัญเชิญบอส?", "Summon the boss?"), bossRequirements(bossesData[config.selectedBoss], config.selectedBoss), function()
logLine("SPEND", string.format("manual summon %s (%s) | %s", tostring(config.selectedBoss), tostring(config.bossDifficulty), costText(config.selectedBoss)))
requestSummonBoss(config.selectedBoss, config.bossDifficulty, false)
end)
end) })
UI.dangerToggle(sm, "autoSummonBoss", L("อัญเชิญอัตโนมัติ", "Auto summon"),
L("ใช้ของอัญเชิญทุกรอบ", "Uses the summon cost every round"), function(v)
if not v then setAutoSummon(nil, false, "boss page off") end
end)
UI.statusRow(sm, function()
local a = state.autoSummonActive
local b = state.summonBlocked
if config.autoSummonBoss and b and b.boss == config.selectedBoss then
return string.format(L("ขาด %s", "Missing %s"), b.missing), "bad"
end
if config.autoSummonBoss and (state.summonNoReply or 0) > 0 and a == nil then
return L("เกมไม่ตอบ · หยุดส่งซ้ำ", "No answer from the game · stopped"), "bad"
end
local txt = a == nil and L("เกมยังไม่บอกสถานะ", "Game has not reported") or (a and (L("เกมกำลังอัญเชิญ ", "Game auto-summoning ") .. tostring(state.autoSummonBoss)) or L("เกมปิดอยู่", "Off in game"))
return txt, a and "run" or "off"
end, L("อัญเชิญของเกม", "Game auto summon"))
local pt = tab:Section()
pt:Header({ Name = L("บอส Pity", "Pity boss") })
pt:Toggle({ Name = L("ตีบอส Pity", "Farm pity boss"), Default = config.autoFarmPityBoss, Callback = UI.set("autoFarmPityBoss") }, "autoFarmPityBoss")
bossPicker(pt, "pitySelectBoss", L("บอสปกติ", "Normal boss"), {})
bossPicker(pt, "pitySelectPityBoss", L("บอส Pity", "Pity boss"), {})
end
function UI.itemFarmStatus(on)
if not on then return L("ปิด", "Off"), "off" end
if config.autoFarm then return L("ปิดฟาร์มเลเวลก่อน (ทำทีละอย่าง)", "Turn off Level farm first (one mode at a time)"), "bad" end
if state.collectingChests or state.questlineBusy then return L("รอเก็บของบนแมพเสร็จ", "Waiting for map collection"), "wait" end
if state.statusTarget then return L("ตี ", "Attacking ") .. state.statusTarget, "run" end
if not state.inventoryInit then return L("กำลังอ่านกระเป๋า...", "Reading inventory..."), "wait" end
local need = state.itemFarmNeed
if not need then return L("รอ...", "Waiting..."), "wait" end
local data = bossesData[need]
if data and (data.Type == "Time" or data.Type == "Castorice") then
return string.format(L("%s ยังไม่เกิด · บอสเวลา รอเกิดตามรอบ", "%s is not spawned · timed boss, waits for its cycle"), need), "wait"
end
if data and data.Type == "Summon" then
if config.autoSummonForItems then
local b = state.summonBlocked
if b and b.boss == need then
return string.format(L("อัญเชิญ %s ไม่ได้ · ขาด %s", "Can't summon %s · missing %s"), need, b.missing), "bad"
end
return string.format(L("รอ %s · กำลังอัญเชิญ", "Waiting for %s · summoning"), need), "wait"
end
return string.format(L("%s ยังไม่เกิด · เปิด \"อัญเชิญบอสเมื่อไม่เจอ\"", "%s is not spawned · turn on \"Summon the boss when missing\""), need), "bad"
end
return string.format(L("หา %s ในแมพไม่เจอ", "Can't find %s on the map"), need), "wait"
end
local materialsData = {}
pcall(function() materialsData = require(ReplicatedStorage.Shared.Data.Materials) end)
local ITEM_TABS = { "Mythical", "Legendary", "Epic", "Rare" }
local function specificItemItems()
local items = {}
for _, name in ipairs(SPECIFIC_ITEM_NAMES) do
local d = materialsData[name]
items[#items + 1] = { Name = name, Rarity = type(d) == "table" and d.Rarity or "", Image = type(d) == "table" and d.Image or nil }
end
return items
end

local function buildItemCards(tab)
local it = tab:Section()
it:Header({ Name = L("ไอเทมเฉพาะชิ้น", "Specific item"), Description = L("ฟาร์มของชิ้นเดียวให้ได้ตามจำนวน ไม่ทำเควสต์ ไม่ซื้อ", "Farms one item up to an amount; no questline, no purchase") })
it:EggPicker({ Name = L("ไอเทม", "Item"), Single = true, Items = specificItemItems(), Rarities = ITEM_TABS, Default = { config.selectedSpecificItem },
Callback = function(names)
if not names[1] then return end
config.selectedSpecificItem = names[1]
UI.queueSave()
end }, "selectedSpecificItem")
it:Dropdown({ Name = L("จำนวนที่ต้องการ", "Target amount"), Description = L("มีครบแล้วหยุดฟาร์มและหยุดอัญเชิญ", "Stops farming and summoning when you have this many"),
Options = { "1", "5", "10", "25", "50", "100", "∞" }, Default = config.specificItemTarget, Callback = UI.set("specificItemTarget") }, "specificItemTarget")
it:Toggle({ Name = L("ฟาร์มไอเทมนี้", "Farm this item"), Default = config.autoFarmSpecificItem, Callback = UI.set("autoFarmSpecificItem") }, "autoFarmSpecificItem")
UI.statusRow(it, function() return UI.itemFarmStatus(config.autoFarmSpecificItem) end)
local sm = tab:Section()
sm:Header({ Name = L("การอัญเชิญบอส", "Boss summons"), Description = L("ใช้กับทำเป้าหมาย ไอเทมเฉพาะชิ้น และอัป Rank", "Used by the goal, Specific item and auto rank") })
UI.dangerToggle(sm, "autoSummonForItems", L("อัญเชิญบอสเมื่อไม่เจอ", "Summon the boss when missing"),
L("ใช้ของอัญเชิญเมื่อบอสที่ต้องตีไม่ได้เกิด · ของอัญเชิญไม่พอ ทำเป้าหมายจะซื้อ Summon Core จากพ่อค้าพเนจร (15k Coins/ชิ้น) และฟาร์มเอง · หยุดเมื่อของครบตามเป้า",
"Uses the summon cost when the boss to fight is not spawned · short on summon items, the goal buys Summon Cores from the travelling merchant (15k Coins each) and farms them · stops at the target amount"), function(v)
if not v then releaseAutoSummon("item summon off") end
end)
sm:Dropdown({ Name = L("ความยากตอนอัญเชิญ", "Summon difficulty"),
Description = L("ยิ่งยากยิ่งดรอปดี (เช่น Journey Book: Easy 0.45% / Extreme 1.25%) · เควสต์ที่กำหนดความยากจะใช้ระดับที่เควสต์นับ", "Harder drops more (e.g. Journey Book: Easy 0.45% / Extreme 1.25%) · a quest step that names difficulties uses one it counts"),
Options = { "Easy", "Medium", "Hard", "Extreme" }, Default = config.itemSummonDifficulty,
Callback = function(v) if v then config.itemSummonDifficulty = v UI.queueSave() end end }, "itemSummonDifficulty")
end
local function buildQuestPage(tab)
local rk = tab:Section()
rk:Header({ Name = L("อัป Rank อัตโนมัติ", "Auto rank up"),
Description = L("ทำเงื่อนไข Rank ถัดไปทีละข้อ แล้วกดอัป Rank ให้เอง", "Works through the next rank's requirements one by one, then ranks up") })
UI.dangerToggle(rk, "autoRank", L("อัป Rank อัตโนมัติ", "Auto rank up"),
L("ใช้กุญแจพอร์ทัล 1 ดอกต่อรอบเพื่อเคลียร์พอร์ทัล (Cartenon Key ก่อน) · ใช้ Slime Orb ครั้งละ 3 ลูกอัญเชิญ Rimuru (เก็บไว้ให้พอ Rank) · ฟาร์มของ/บอส/มอนตามที่ขาด · บอสอื่นอัญเชิญเฉพาะเมื่อเปิด \"อัญเชิญบอสเมื่อไม่เจอ\"",
"Spends 1 portal key per portal clear (Cartenon Key first) · spends 3 Slime Orbs per Rimuru summon (keeps what the rank needs) · farms the missing items/bosses/mobs · other bosses are summoned only when \"Summon the boss when missing\" is on"),
function(v)
if v then
for _, flag in ipairs(Rank.FARM_MODE_FLAGS) do
if flag ~= "autoRank" and config[flag] then config[flag] = false UI.mirror(flag, false) end
end
state.lastRankSync = 0
else
state.rankTask = nil
releaseAutoSummon("rank off")
end
state.token = state.token + 1
state.farmTarget = nil
state.lastTargetScan = 0
cancelMotion()
end)
UI.statusRow(rk, function()
if not Rank.event then return L("ไม่พบระบบ Rank ในเกม", "Rank system not found"), "off" end
local cur = state.rank and state.rank.Stats and state.rank.Stats.Rank
local job = state.rankTask
if not config.autoRank or not job then return cur and (L("Rank ปัจจุบัน: ", "Current rank: ") .. cur) or L("ปิด", "Off"), "off" end
local function needText(n)
local t = Rank.REQ_TEXT[n.key]
return string.format("%s %s/%s", t and L(t[1], t[2]) or n.key, tostring(n.have), tostring(n.need))
end
if job.kind == "sync" then return L("กำลังอ่านข้อมูล Rank...", "Reading rank data..."), "wait" end
if job.kind == "rankup" then return L("เงื่อนไขครบ · กำลังอัปเป็น ", "Requirements met · ranking up to ") .. job.rank, "run" end
if job.kind == "portal" then return string.format(L("%s · ใช้ %s", "%s · using %s"), needText(job.need), job.key), "run" end
if job.kind == "item" then
if state.statusTarget == job.info.mob then return string.format(L("%s · ตี %s", "%s · attacking %s"), needText(job.need), state.statusTarget), "run" end
local summoner = Rank.SUMMONERS[job.info.mob]
local have, cost
if summoner then have, cost = Rank.summonerFill(summoner) end
if have and cost then
local spawnBoss = Rank.spawnerBoss(summoner, job.info.mob)
if have < cost then
return string.format(L("%s · ใส่ %s %d/%d เพื่ออัญเชิญ %s", "%s · %s %d/%d in the summoner for %s"), needText(job.need), summoner.orb, have, cost, job.info.mob), "run"
elseif spawnBoss and state.statusTarget == spawnBoss.Name then
return string.format(L("%s · ฆ่า %s ให้ %s เกิดต่อ", "%s · killing %s so %s spawns next"), needText(job.need), spawnBoss.Name, job.info.mob), "run"
elseif not spawnBoss then
return string.format(L("%s · อัญเชิญแล้ว รอ %s เกิด (ตัวจับเวลา)", "%s · summoned, waiting for %s (spawner timer)"), needText(job.need), job.info.mob), "wait"
end
end
if state.statusTarget then return string.format(L("%s · รอ %s เกิด · ตี %s ระหว่างรอ", "%s · waiting for %s · attacking %s meanwhile"), needText(job.need), job.info.mob, state.statusTarget), "run" end
return string.format(L("%s · รอ %s เกิด", "%s · waiting for %s"), needText(job.need), job.info.mob), "wait"
end
if job.kind == "blocked" then return needText(job.need) .. L(" · ทำเองไม่ได้ ฟาร์มมอนรอ", " · not automatable, farming mobs"), "wait" end
return needText(job.need), state.statusTarget and "run" or "wait"
end)
local rankBody = rk:Paragraph({ Header = L("เงื่อนไข Rank ถัดไป", "Next rank requirements"), Body = "..." })
UI.textRow(function()
local cur, nextName, needs = Rank.needs()
if not cur then return L("ยังไม่มีข้อมูล (อ่านทุก 30 วินาที)", "No data yet (refreshes every 30 s)") end
if not nextName then return cur .. L(" · Rank สูงสุดแล้ว", " · highest rank") end
local lines = {cur .. " → " .. nextName}
for _, n in ipairs(needs) do
local t = Rank.REQ_TEXT[n.key]
local have = n.key == "TotalDamage" and string.format("%.3gB", n.have / 1e9) or tostring(n.have)
local need = n.key == "TotalDamage" and string.format("%.3gB", n.need / 1e9) or tostring(n.need)
lines[#lines + 1] = string.format("%s %s  %s/%s", n.have >= n.need and "✓" or "·", t and L(t[1], t[2]) or n.key, have, need)
end
return table.concat(lines, "\n")
end, function(body) rankBody:UpdateBody(body) end)
local naruto = tab:Section()
naruto:Header({ Name = L("หมัดนารูโตะ · เควสต์ Killer B", "Naruto Style · Killer B quest"),
Description = L("ปลด Jinchuriki ก่อน แล้วเก็บของจากดันเจี้ยน The Valley of the End", "Unlock Jinchuriki, then collect Naruto materials in The Valley of the End") })
UI.statusRow(naruto, function()
local id = player:GetAttribute("QuestlineId")
local progress = player:GetAttribute("QuestlineProgress") or 0
local maxProgress = player:GetAttribute("QuestlineMaxProgress") or 0
if id == 190 then return string.format(L("ใช้ Combat ทำดาเมจ %.0f/%.0f", "Combat damage %.0f/%.0f"), progress, maxProgress), "run" end
if id == 191 then return string.format(L("แบกหิน %d/%d", "Boulders %d/%d"), progress, maxProgress), "run" end
if id == 192 then return string.format(L("กำจัด NPC Chakra Flow %d/%d", "Chakra Flow NPCs %d/%d"), progress, maxProgress), "run" end
if id == 193 then return string.format(L("นั่งสมาธิ %d/%d วินาที", "Meditation %d/%d seconds"), progress, maxProgress), "run" end
if id and id ~= 190 and id ~= 191 and id ~= 192 and id ~= 193 then
return L("มีเควสต์สายอื่นค้างอยู่", "Another questline is active"), "wait"
end
if player:GetAttribute("Questline193") ~= true then
return L("เตรียม 7.5M Coins + 27.5k Gems เพื่อเริ่มกับ Killer B", "Need 7.5M Coins + 27.5k Gems to start with Killer B"), "wait"
end
if state.profile.Race ~= "Jinchuriki" then
return string.format(L("Darkness Fragment %d/2 → ซื้อเผ่า Jinchuriki", "Darkness Fragment %d/2 → buy Jinchuriki"), state.inventory["Darkness Fragment"] or 0), "wait"
end
local recipe = QUEST_RECIPES["Naruto Style"]
for _, mat in ipairs(recipe.materials) do
if (state.inventory[mat.item] or 0) < mat.amount then
return string.format("%s %d/%d · The Valley of the End", mat.item, state.inventory[mat.item] or 0, mat.amount), "wait"
end
end
if (state.currency.Coins or 0) < 40000000 or (state.currency.Gems or 0) < 30000 then
return L("ของครบแล้ว · รอ 40M Coins + 30k Gems", "Materials ready · need 40M Coins + 30k Gems"), "wait"
end
return L("พร้อมซื้อ Naruto Style ที่ NPC นารูโตะ", "Ready to buy Naruto Style at Naruto NPC"), "run"
end)
local narutoProgress = naruto:Paragraph({ Header = L("เงื่อนไขทั้งหมด", "Requirements"), Body = "..." })
UI.textRow(function()
local lines = {
string.format("Coins %s/40,000,000 · Gems %s/30,000", tostring(state.currency.Coins or 0), tostring(state.currency.Gems or 0)),
string.format("Race: %s · Darkness Fragment %d/2", tostring(state.profile.Race or player:GetAttribute("Race") or "?"), state.inventory["Darkness Fragment"] or 0),
string.format("Six Paths Key %d · Realm Signal %d/2 · Chakra Essence %d/1", state.inventory["Six Paths Key"] or 0, state.inventory["Realm Signal"] or 0, state.inventory["Chakra Essence"] or 0)
}
for _, mat in ipairs(QUEST_RECIPES["Naruto Style"].materials) do
lines[#lines + 1] = string.format("%s %d/%d", mat.item, state.inventory[mat.item] or 0, mat.amount)
end
return table.concat(lines, "\n")
end, function(body) narutoProgress:UpdateBody(body) end)
local narutoToggle = naruto:Toggle({ Name = L("ทำเควสต์ Killer B อัตโนมัติ", "Auto Killer B quest"),
Description = L("เมื่อเงินเริ่มเควสต์ครบ จะจ่าย 7.5M Coins + 27.5k Gems · ทำ Combat, หิน, Chakra Flow และสมาธิ · กลางคืนไม่พบ Chakra Flow จะย้ายห้อง", "Pays the 7.5M Coins + 27.5k Gems entry cost when ready, then runs Combat, boulders, Chakra Flow and meditation · hops at night when Chakra Flow is missing"),
Default = config.autoNarutoQuest, Callback = UI.set("autoNarutoQuest", function(v)
if v then
for _, flag in ipairs(Rank.FARM_MODE_FLAGS) do
if flag ~= "autoNarutoQuest" and config[flag] then config[flag] = false UI.mirror(flag, false) end
end
else
state.narutoHopPending = false
state.narutoNoMobSince = nil
clearNarutoHopResume()
end
state.token = state.token + 1
state.farmTarget = nil
state.lastTargetScan = 0
cancelMotion()
end) }, "autoNarutoQuest")
narutoToggle.IgnoreConfig = true
naruto:Buttons({
{ Name = L("ไปหา Killer B", "Killer B"), Callback = UI.action("narutoKillerB", 0.5, function()
warpToMerchant({name = "Killer B", path = {"NPC", "QuestlineAndSeller", "BeastTailNPC"}})
end) },
{ Name = L("ไปหานารูโตะ", "Naruto NPC"), Callback = UI.action("narutoSeller", 0.5, function()
warpToMerchant({name = "Naruto", path = {"NPC", "Seller", "NarutoNPC"}})
end) },
})
naruto:Buttons({
{ Name = L("ไปหาตัวเอง", "Waterfall clone"), Callback = UI.action("narutoClone", 0.5, function()
warpToMerchant({name = "Waterfall clone", path = {"NPC", "NarutoRace", "YourselfNPC"}})
end) },
{ Name = L("เลือกดันเจี้ยนนารูโตะ", "Select Naruto dungeon"), Callback = UI.action("narutoDungeon", 0.5, function()
local dropdown = DukeGUI.Options.selectDungeon
if dropdown then dropdown:UpdateSelection("The Valley of the End") end
UI.notify(L("เลือก The Valley of the End แล้ว · ต้องมี Six Paths Key และเปิดพอร์ทัลในแท็บดันเจี้ยน", "The Valley of the End selected · use a Six Paths Key at the Dungeon portal"))
end) },
})
naruto:Buttons({
{ Name = L("ซื้อเผ่า Jinchuriki", "Buy Jinchuriki"), Callback = UI.action("narutoRaceBuy", 0.5, function()
if player:GetAttribute("Questline193") ~= true or (state.inventory["Darkness Fragment"] or 0) < 2 then
return UI.notify(L("ต้องจบเควสต์ Killer B และมี Darkness Fragment 2 ชิ้นก่อน", "Finish Killer B and collect 2 Darkness Fragments first"))
end
UI.confirm(L("ซื้อเผ่า Jinchuriki?", "Buy Jinchuriki?"), L("ใช้ Darkness Fragment 2 ชิ้นและเปลี่ยนเผ่าปัจจุบัน", "Uses 2 Darkness Fragments and changes your current race"), function()
local npc = findMerchantTarget({path = {"NPC", "QuestlineAndSeller", "BeastTailNPC"}})
local part = npc and npc:FindFirstChild("HumanoidRootPart")
if not part or not sellerEvent then return UI.notify(L("ไม่พบ Killer B หรือ SellerEvent", "Killer B or SellerEvent unavailable")) end
if moveTo(part.CFrame + part.CFrame.LookVector * 4, nil, "Teleport") then
logLine("SPEND", string.format("buy race Jinchuriki (was %s) | Darkness Fragment=%s", tostring(state.profile.Race), tostring(state.inventory["Darkness Fragment"])))
sellerEvent:FireServer("Buy", {Name = "BeastTailNPC", Amount = 1})
state.lastInventorySync = 0
else
UI.notify(L("วาร์ปไป Killer B ไม่สำเร็จ", "Could not reach Killer B"))
end
end)
end) },
{ Name = L("ซื้อหมัดนารูโตะ", "Buy Naruto Style"), Callback = UI.action("narutoStyleBuy", 0.5, function()
if state.profile.Race ~= "Jinchuriki" or (state.currency.Coins or 0) < 40000000 or (state.currency.Gems or 0) < 30000 then
return UI.notify(L("ต้องมีเผ่า Jinchuriki, 40M Coins และ 30k Gems", "Need Jinchuriki, 40M Coins and 30k Gems"))
end
for _, mat in ipairs(QUEST_RECIPES["Naruto Style"].materials) do
if (state.inventory[mat.item] or 0) < mat.amount then
return UI.notify(string.format("%s %d/%d", mat.item, state.inventory[mat.item] or 0, mat.amount))
end
end
UI.confirm(L("ซื้อ Naruto Style?", "Buy Naruto Style?"), L("ใช้ 40M Coins, 30k Gems และวัตถุดิบทั้งหมด", "Uses 40M Coins, 30k Gems and all listed materials"), function()
local npc = findMerchantTarget({path = {"NPC", "Seller", "NarutoNPC"}})
local part = npc and npc:FindFirstChild("HumanoidRootPart")
if not part or not sellerEvent then return UI.notify(L("ไม่พบ Naruto NPC หรือ SellerEvent", "Naruto NPC or SellerEvent unavailable")) end
if moveTo(part.CFrame + part.CFrame.LookVector * 4, nil, "Teleport") then
logLine("SPEND", "buy Naruto Style | " .. costText(nil))
sellerEvent:FireServer("Buy", {Name = "NarutoNPC", Amount = 1})
state.lastInventorySync = 0
else
UI.notify(L("วาร์ปไป Naruto NPC ไม่สำเร็จ", "Could not reach Naruto NPC"))
end
end)
end) },
})
local w = tab:Section()
w:Header({ Name = L("ของเควสต์บนแมพ", "Quest items on the map") })
w:Toggle({ Name = L("เก็บของอัตโนมัติ", "Auto collect"), Default = config.autoCollectQuestline, Callback = UI.set("autoCollectQuestline", function(v)
if not v then state.token = state.token + 1 end
end) }, "autoCollectQuestline")
w:Dropdown({ Name = L("ของที่จะเก็บ", "Items to collect"), Multi = true, Options = QUESTLINE_GROUPS, Default = keysOn(config.questlineAuto, QUESTLINE_GROUPS),
Callback = UI.setMap(config.questlineAuto, QUESTLINE_GROUPS) }, "questlineAuto")
end
local function buildBagPage(tab)
local box = tab:Section()
box:Header({ Name = L("เปิดกล่อง", "Open chests"), Description = L("เปิด Chest ในกระเป๋า (เหมือนกดใช้จากกระเป๋า)", "Opens the Chests in your bag, same as using them from the bag") })
local CHESTS = { "Common Chest", "Uncommon Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Mythical Chest" }
local boxPick = L("ทุกชนิด", "All kinds")
box:Dropdown({ Name = L("ชนิดกล่อง", "Chest"), Options = { L("ทุกชนิด", "All kinds"), table.unpack(CHESTS) }, Default = boxPick,
Callback = function(v) if v then boxPick = v end end }, "chestPick").IgnoreConfig = true
local boxCounts = box:Paragraph({ Header = L("ในกระเป๋า", "In bag"), Body = "..." })
UI.textRow(function()
local lines = {}
for _, name in ipairs(CHESTS) do
local n = state.inventory[name] or 0
if n > 0 then lines[#lines + 1] = string.format("%s ×%d", name, n) end
end
return #lines > 0 and table.concat(lines, "\n") or L("ไม่มีกล่อง", "No chests")
end, function(body) boxCounts:UpdateBody(body) end)
box:Button({ Name = L("เปิดทั้งหมด", "Open all"), Primary = true, Callback = UI.action("openChests", 2, function()
if not Rank.materialEvent then return UI.notify(L("ไม่พบ MaterialEvent", "MaterialEvent unavailable")) end
if state.openingChests then return end
state.openingChests = true
task.spawn(function()
local opened = 0
for _, name in ipairs(CHESTS) do
if boxPick == name or not table.find(CHESTS, boxPick) then
local left = state.inventory[name] or 0

while left > 0 and state.alive do
local n = math.min(left, 50)
safe("CHEST_OPEN", function() Rank.materialEvent:FireServer("Use", {Item = name, Amount = n}) end)
left, opened = left - n, opened + n
task.wait(0.6)
end
end
end
state.openingChests = false
state.lastInventorySync = 0
logLine("CHEST_OPEN", "opened " .. opened)
UI.notify(opened > 0 and string.format(L("เปิดกล่อง %d กล่อง", "Opened %d chests"), opened) or L("ไม่มีกล่องให้เปิด", "No chests to open"))
end)
end) })
end
local function buildDungeonPage(tab)
local d = tab:Section()
d:Header({ Name = L("ดันเจี้ยน", "Dungeon") })

d:Dropdown({ Name = L("ดันเจี้ยน", "Dungeon"), Options = DUNGEONS, Default = config.selectDungeon,
Callback = function(v) if v then config.selectDungeon = v UI.queueSave() end end }, "selectDungeon")
d:Dropdown({ Name = L("ความยาก", "Difficulty"), Options = { "Easy", "Medium", "Hard", "Extreme" }, Default = config.selectDifficulty == "Nightmare" and "Extreme" or config.selectDifficulty,
Callback = function(v)
if v == "Nightmare" then v = "Extreme" end
if v then config.selectDifficulty = v UI.queueSave() end
end }, "selectDifficulty")
d:Toggle({ Name = L("เริ่มทันที", "Auto start"), Default = config.autoStartDungeon, Callback = UI.set("autoStartDungeon") }, "autoStartDungeon")
d:Toggle({ Name = L("ตีมอนทั้งหมด", "Kill all mobs"), Description = L("ทำงานเฉพาะในด่าน", "Only inside a dungeon"), Default = config.autoKillAllDungeon, Callback = UI.set("autoKillAllDungeon") }, "autoKillAllDungeon")
d:Toggle({ Name = L("ทำลายเสา Yhwach", "Clear Yhwach pillars"), Default = config.autoClearYhwachPillars, Callback = UI.set("autoClearYhwachPillars") }, "autoClearYhwachPillars")
d:Toggle({ Name = L("ออกเมื่อจบรอบ", "Leave when the run ends"), Description = L("เคลียร์ครบแล้วออกจากดันเจี้ยน (ยกเว้นเปิดเล่นซ้ำของเกมไว้)", "Leaves the dungeon after the last wave (unless the game's auto replay is on)"),
Default = config.autoLeaveDungeon, Callback = UI.set("autoLeaveDungeon") }, "autoLeaveDungeon")
d:Buttons({
{ Name = L("สร้างพอร์ทัล", "Create portal"), Callback = UI.action("portal", 1, function()
local key = dungeonKey(DNG_MAP[config.selectDungeon] or "ARTIFACT_01")
UI.confirm(L("สร้างพอร์ทัล?", "Create the portal?"), string.format(L("ใช้ %s 1 ดอก (มี %s)", "Uses 1 %s (you have %s)"), key, tostring(state.inventory[key] or "?")), function()
createPortal("button")
end)
end) },
{ Name = L("เริ่มเลย", "Start now"), Callback = UI.action("earlyStart", 1, function()
if portalEvent then portalEvent:FireServer("EarlyStart") end
end) },
})
UI.dangerToggle(d, "autoCreateDungeon", L("สร้างพอร์ทัลอัตโนมัติ", "Auto create portal"), L("เมื่อหน้าเลือกพอร์ทัลของเกมเปิด สคริปต์เลือกดันเจี้ยน/ความยากที่ตั้งไว้แล้วเริ่มให้ · ใช้กุญแจ 1 ดอกต่อรอบ · หยุดเมื่อกุญแจหมด", "When the game's portal selector opens, picks the set dungeon/difficulty and starts · 1 key per run · stops when out of keys"))
UI.settingToggle(d, "gameAuto_Replay_Portals", "Auto_Replay_Portals", L("เล่นซ้ำอัตโนมัติ (setting ของเกม)", "Auto replay (game setting)"), L("ใช้กุญแจทุกครั้งที่เล่นซ้ำ", "Uses a key on every replay"), true)
end
local function buildTowerPage(tab)
local t = tab:Section()
t:Header({ Name = L("หอคอย", "Tower") })
t:Toggle({ Name = L("ตีมอนทั้งหมด", "Kill all mobs"), Description = L("ทำงานเฉพาะในหอคอย", "Only inside the tower"), Default = config.autoKillAllTower, Callback = UI.set("autoKillAllTower") }, "autoKillAllTower")
UI.dangerToggle(t, "autoStartTower", L("เริ่มหอคอยอัตโนมัติ", "Auto start tower"),
string.format(L("ใช้ %s Coins ทุกครั้งที่เริ่ม", "Costs %s Coins every start"), TOWER_COST))
t:Toggle({ Name = L("ออกเมื่อจบรอบ", "Leave when the run ends"), Description = L("รอบจบแล้วออกจากหอคอยแทนการเล่นซ้ำ (เล่นซ้ำเสีย Coins)", "Leaves the tower when the run ends instead of replaying (a replay costs Coins)"),
Default = config.autoLeaveTower, Callback = UI.set("autoLeaveTower") }, "autoLeaveTower")
end
local function buildSeaPage(tab)
local s = tab:Section()
s:Header({ Name = L("ทะเล (Sea)", "Sea") })
s:Dropdown({ Name = L("ระดับ", "Tier"), Options = { "1", "2", "3", "4", "5" }, Default = config.selectSeaTier, Callback = UI.set("selectSeaTier") }, "selectSeaTier")
s:Toggle({ Name = L("เข้าทะเล + เล่นซ้ำอัตโนมัติ", "Go to sea + replay"), Default = config.autoPlaySea, Callback = UI.set("autoPlaySea") }, "autoPlaySea")
s:Toggle({ Name = L("เล่นรอบอัตโนมัติ (เริ่ม + เข้าประตู)", "Auto run (start + doors)"), Default = config.autoStartSea, Callback = UI.set("autoStartSea") }, "autoStartSea")
s:Toggle({ Name = L("ตีมอนในทะเล", "Kill sea mobs"), Default = config.autoKillMobsSea, Callback = UI.set("autoKillMobsSea") }, "autoKillMobsSea")
s:Toggle({ Name = L("เลือกการ์ดดีที่สุด", "Pick the best card"), Description = L("Gold > Silver > Bronze", "Gold > Silver > Bronze"), Default = config.autoPickBestCard, Callback = UI.set("autoPickBestCard") }, "autoPickBestCard")
s:Dropdown({ Name = L("ประตูที่จะเข้า", "Door to take"), Description = L("ไม่มีประตูแบบนี้ = เข้าประตูที่มี", "If missing, takes any open door"),
Options = { "Combat", "Elite", "Random", "Rest" }, Default = config.seaDoor, Callback = UI.set("seaDoor") }, "seaDoor")
s:Toggle({ Name = L("ออกเมื่อจบรอบ", "Leave when the run ends"), Default = config.autoLeaveSea, Callback = UI.set("autoLeaveSea") }, "autoLeaveSea")
s:Button({ Name = L("ไปทะเลเลย", "Go to sea now"), Callback = UI.action("seaPlay", 2, function()
if not seaRemote then return end
if IN_SEA then return seaStart("button") end
local tier = math.clamp(tonumber(config.selectSeaTier) or 1, 1, 5)
logLine("SEA", "Play tier " .. tier .. " (button)")
seaRemote:FireServer("Play", { HardTier = tier })
end) })
end
local function buildCharacterPage(tab)
local c = tab:Section()
c:Header({ Name = L("ตัวละคร", "Character") })
c:Toggle({ Name = L("ฮาคิเกราะอัตโนมัติ", "Auto Buso Haki"), Default = config.autoHaki, Callback = UI.set("autoHaki") }, "autoHaki")
c:Toggle({ Name = L("ฮาคิสังเกตอัตโนมัติ", "Auto Ken Haki"), Default = config.autoObsHaki, Callback = UI.set("autoObsHaki") }, "autoObsHaki")
c:Toggle({ Name = L("วิ่งเร็ว", "Speed boost"), Default = config.speedHack, Callback = UI.set("speedHack") }, "speedHack")
c:Toggle({ Name = L("กระโดดกลางอากาศ", "Infinite jump"), Default = config.infinityJump, Callback = UI.set("infinityJump") }, "infinityJump")
c:Toggle({ Name = L("มองเห็นผู้เล่น", "Player ESP"), Default = config.espPlayer, Callback = UI.set("espPlayer") }, "espPlayer")
local st = tab:Section()
st:Header({ Name = L("อัปสเตตัส", "Stats"), Description = L("ลงแต้มให้สเตตัสที่เลือก ตัวที่ต่ำกว่าได้ก่อน", "Spends points on the chosen stats, lowest first") })
st:Dropdown({ Name = L("สเตตัส", "Stats"), Multi = true, Options = STAT_NAMES, Default = keysOn(config.statTargets, STAT_NAMES),
Callback = UI.setMap(config.statTargets, STAT_NAMES) }, "statTargets")
UI.dangerToggle(st, "autoStats", L("อัปสเตตัสอัตโนมัติ", "Auto stats"), L("ลงแต้มสเตตัสถาวร (รีเซ็ตต้องใช้ของในเกม)", "Spends stat points for good (resetting needs an in-game item)"))
end
local function buildCollectCard(tab)
local col = tab:Section()
col:Header({ Name = L("เก็บของ", "Collect") })
col:Toggle({ Name = L("เก็บหีบ", "Collect chests"), Default = config.autoChests, Callback = UI.set("autoChests", function(v)
if not v then state.token = state.token + 1 end
end) }, "autoChests")
col:Toggle({ Name = L("เก็บเมล็ดที่โตแล้ว", "Collect ready seeds"), Default = config.autoSeeds, Callback = UI.set("autoSeeds", function(v)
if not v then state.token = state.token + 1 end
end) }, "autoSeeds")
col:Button({ Name = L("ทิ้งผลไม้ปีศาจทั้งหมด", "Drop all devil fruits"), Callback = UI.action("dropFruits", 2, function()
if UI.applyingConfig or state.droppingFruits then return end
local fruits = getFruitTools()
if #fruits == 0 then return UI.notify(L("ไม่มีผลไม้ปีศาจในกระเป๋า", "No devil fruits in the backpack")) end
local counts, labels = {}, {}
for _, fruit in ipairs(fruits) do counts[fruit.Name] = (counts[fruit.Name] or 0) + 1 end
for name, count in pairs(counts) do labels[#labels + 1] = name .. " x" .. count end
table.sort(labels)
UI.confirm(L("ทิ้งผลไม้ปีศาจทั้งหมด?", "Drop all devil fruits?"),
table.concat(labels, ", ") .. L(" — ผลไม้จะตกพื้นและอาจมีคนเก็บไป", " — fruits will fall on the ground and can be picked up"), function()
task.spawn(function()
local dropped, failed, err = dropFruitTools(fruits)
if err then logLine("FRUIT_DROP", err) end
UI.notify(string.format(L("ทิ้งได้ %d/%d ลูก (ไม่สำเร็จ %d)", "Dropped %d/%d fruits (%d failed)"), dropped, #fruits, failed))
end)
end)
end) })
end
local function buildPvPPage(tab)
local pv = tab:Section()
pv:Header({ Name = L("วาร์ปไปตีผู้เล่น", "Warp and attack player"),
Description = L("ล็อกคนจากรายชื่อ หรือใส่ Username/UserId เอง · ไม่ได้เลือกใครไว้จะสุ่มให้", "Lock someone from the list or enter a username/UserId · with no one chosen it picks at random") })
local targetInput = pv:Input({ Name = L("เป้าหมาย", "Target"), Placeholder = "@username / UserId", Width = 190,
Default = config.selectedPvPPlayer, Callback = UI.set("selectedPvPPlayer", function()
if not state.pvpSelectionFromButtons then
table.clear(state.pvpHistory)
state.pvpHistoryIndex = 0
local manual = findPvPPlayer()
if manual then
state.pvpHistory[1] = manual.UserId
state.pvpHistoryIndex = 1
end
end
state.farmTarget = nil
state.lastTargetScan = 0
state.stallTarget = nil
state.stallLogged = false
end) }, "selectedPvPPlayer")
local function availableById(available, userId)
for _, other in ipairs(available) do
if other.UserId == userId then return other end
end
return nil
end
local function setPvPTarget(other)
state.pvpSelectionFromButtons = true
targetInput:UpdateText(other.Name)
state.pvpSelectionFromButtons = false
state.lastPvPWarp = 0
state.token = state.token + 1
cancelMotion()
logLine("PVP", "target " .. other.Name)
UI.notify(L("เป้าหมาย: ", "Target: ") .. other.Name)
end
local function nextPvPTarget()
local available = eligiblePvPPlayers()
if #available == 0 then
UI.notify(L("ไม่มีผู้เล่นที่เปิด PvP และอยู่นอกเขตปลอดภัย", "No eligible player outside a safe zone"))
return false
end
local history = state.pvpHistory
for i = state.pvpHistoryIndex + 1, #history do
local other = availableById(available, history[i])
if other then
state.pvpHistoryIndex = i
setPvPTarget(other)
return true
end
end
for i = #history, state.pvpHistoryIndex + 1, -1 do history[i] = nil end
local seen, unvisited, others = {}, {}, {}
for _, userId in ipairs(history) do seen[userId] = true end
local current = state.pvpHistoryIndex > 0 and findPvPPlayer() or nil
for _, other in ipairs(available) do
if other ~= current then
others[#others + 1] = other
if not seen[other.UserId] then unvisited[#unvisited + 1] = other end
end
end
local pool = #unvisited > 0 and unvisited or others
if #pool == 0 then
UI.notify(L("ไม่มีผู้เล่นคนอื่นที่ตีได้ในตอนนี้", "No other eligible player right now"))
return false
end
local other = pool[math.random(1, #pool)]
history[#history + 1] = other.UserId
state.pvpHistoryIndex = #history
setPvPTarget(other)
return true
end
local function previousPvPTarget()
local available = eligiblePvPPlayers()
for i = state.pvpHistoryIndex - 1, 1, -1 do
local other = availableById(available, state.pvpHistory[i])
if other then
state.pvpHistoryIndex = i
setPvPTarget(other)
return
end
end
UI.notify(L("ไม่มีเป้าหมายก่อนหน้าที่ตีได้", "No previous eligible target"))
end
pv:Buttons({
{ Name = L("ย้อนกลับ", "Previous"), Callback = UI.action("previousPvP", 0.25, previousPvPTarget) },
{ Name = L("คนต่อไป", "Next player"), Primary = true, Callback = UI.action("nextPvP", 0.25, nextPvPTarget) },
})

local function playerNames()
local names = {}
for _, other in ipairs(Players:GetPlayers()) do
if other ~= player then names[#names + 1] = other.Name end
end
table.sort(names, function(a, b) return a:lower() < b:lower() end)
return names
end
local picker = pv:Dropdown({ Name = L("ล็อกผู้เล่น", "Lock player"), Description = L("เลือกคนในห้องเพื่อตามตีคนนี้คนเดียว", "Pick someone in this server to follow only them"),
Options = playerNames(), Callback = function(name)
if type(name) ~= "string" or name == "" then return end
local other = Players:FindFirstChild(name)
if not other then return end
table.clear(state.pvpHistory)
state.pvpHistory[1] = other.UserId
state.pvpHistoryIndex = 1
setPvPTarget(other)
end }, "pvpLockPlayer")
picker.IgnoreConfig = true
local function refreshPicker()
picker:ClearOptions()
picker:InsertOptions(playerNames())
end
track(Players.PlayerAdded:Connect(function() task.defer(refreshPicker) end))
track(Players.PlayerRemoving:Connect(function() task.defer(refreshPicker) end))
UI.statusRow(pv, function()
if not config.autoPvP then return L("ปิด", "Off"), "off" end
local other = findPvPPlayer()
if not other then return L("รอผู้เล่นเป้าหมายเข้าห้อง", "Waiting for target player"), "wait" end
if player:GetAttribute("Disable_PVP") == true then return L("คุณปิด PvP ในเกมอยู่", "Your game PvP is disabled"), "bad" end
if other:GetAttribute("Disable_PVP") == true then return L("เป้าหมายปิด PvP ในเกมอยู่", "Target has disabled PvP"), "bad" end
if other.Character and other.Character:GetAttribute("SafeZone") == true then
return L("เป้าหมายอยู่ในเขตปลอดภัย", "Target is in a safe zone"), "wait"
end
if not livePvPCharacter(other) then return L("รอเป้าหมายเกิด", "Waiting for target to respawn"), "wait" end
if state.stallLogged and state.stallTarget == other.Character then
return L("ตีไม่เข้า กดคนต่อไปได้เลย", "No damage: press Next player"), "bad"
end
return L("กำลังตามตี ", "Following ") .. other.Name, "run"
end)
pv:Button({ Name = L("วาร์ปไปหาผู้เล่น", "Warp to player"), Primary = true,
Callback = UI.action("warpPvP", 0.5, function()
local other = findPvPPlayer()
if not other and nextPvPTarget() then other = findPvPPlayer() end
local _, targetRoot = livePvPCharacter(other)
if not targetRoot then return UI.notify(L("ไม่พบผู้เล่นเป้าหมายที่ยังมีชีวิตในห้อง", "Target player is not alive in this server")) end
if moveTo(pvpDestination(targetRoot), nil, "Teleport") then
logLine("PVP", "warp to " .. other.Name)
end
end) })
local toggle = pv:Toggle({ Name = L("วาร์ปตามและตีอัตโนมัติ", "Follow and attack automatically"),
Description = L("ตามตีผู้เล่นที่ล็อก/ใส่ชื่อไว้ ถ้าไม่มีจะสุ่ม · วาร์ปไปด้านหลังและใช้การตี/สกิลที่ตั้งไว้", "Follows the locked/entered player, or a random one if none · teleports behind them and attacks"),
Default = config.autoPvP, Callback = UI.set("autoPvP", function(v)

local chosen = v and findPvPPlayer()
if v then
table.clear(state.pvpHistory)
state.pvpHistoryIndex = 0
if chosen then
state.pvpHistory[1] = chosen.UserId
state.pvpHistoryIndex = 1
end
end
if v and not chosen and not nextPvPTarget() then
config.autoPvP = false
UI.mirror("autoPvP", false)
return
end
state.farmTarget = nil
state.lastTargetScan = 0
state.lastPvPWarp = 0
if v then state.token = state.token + 1 cancelMotion() end
end) }, "autoPvP")
toggle.IgnoreConfig = true
end
local function buildGachaPage(tab)
local g = tab:Section()
g:Header({ Name = L("ตู้ Miyabi", "Miyabi banner") })
UI.valueRow(g:Value({ Name = L("ตั๋ว / Pity", "Tickets / Pity"), Text = "-" }), function()
return string.format("%d · %d/80", pityInfo.tickets, pityInfo.bannerPity)
end)
local function pull(kind, count)
return UI.action("pull" .. count, 1, function()
if not bannerEvent then return end
updatePityLabels()
if pityInfo.tickets < count then
return UI.notify(string.format(L("ตั๋วไม่พอ (มี %d)", "Not enough tickets (have %d)"), pityInfo.tickets))
end
UI.confirm(string.format(L("สุ่ม %d ครั้ง?", "Pull %d times?"), count), string.format(L("ใช้ตั๋วตู้ %d ใบ (มี %d)", "Uses %d banner tickets (have %d)"), count, pityInfo.tickets), function()
logLine("SPEND", string.format("banner %s | before tickets=%d pity=%d", kind, pityInfo.tickets, pityInfo.bannerPity))
bannerEvent:FireServer(kind, { Banner = "Miyabi" })
task.delay(1, function()
updatePityLabels()
logLine("SPEND", string.format("banner %s | after tickets=%d pity=%d", kind, pityInfo.tickets, pityInfo.bannerPity))
end)
end)
end)
end
g:Buttons({
{ Name = L("สุ่ม 1", "Pull 1"), Callback = pull("OnePull", 1) },
{ Name = L("สุ่ม 10", "Pull 10"), Callback = pull("TenPull", 10) },
})
UI.settingToggle(g, "gameAuto_Claim_Playtime", "Auto_Claim_Playtime", L("รับรางวัลเวลาเล่น", "Claim playtime rewards"), nil, false)
local roll = UI.dangerToggle(g, "autoRollBanner", L("สุ่มจนถึง 80 Pity", "Pull until 80 pity"), L("สุ่มทีละ 10 จนถึง 80 pity หรือตั๋วหมด", "Pulls 10 at a time until 80 pity or out of tickets"))
roll.IgnoreConfig = true
end
local MERCHANT_TABS = { L("ดาบ", "Weapons"), L("สไตล์", "Styles"), L("อเวค", "Mastery"), L("เผ่า", "Races"), L("สุ่ม / ฮาคิ", "Gacha"), L("แลกของ", "Exchange") }
local function buildTravelPage(tab)
local pick = {}
local islandItems, islandId = {}, {}
for i, isle in ipairs(ISLANDS) do
local info = islandData[isle[1]] or {}
islandItems[#islandItems + 1] = { Name = isle[1], Rarity = "#" .. i, Image = info.Image }
islandId[isle[1]] = isle[2]
end
pick.island = ISLANDS[1][1]
local tp = tab:Section()
tp:Header({ Name = L("วาร์ปไปเกาะ", "Island teleport") })
local islandInfo = tp:Label({ Text = (islandData[pick.island] or {}).Details or "" })
tp:EggPicker({ Name = L("เกาะ", "Island"), Single = true, Items = islandItems, Default = { pick.island }, Callback = function(names)
if not names[1] then return end
pick.island = names[1]
islandInfo:UpdateName((islandData[pick.island] or {}).Details or "")
end })
tp:Button({ Name = L("วาร์ป", "Teleport"), Primary = true, Callback = UI.action("island", 1, function()
local id = islandId[pick.island]
logLine("TRAVEL", "island " .. tostring(pick.island))
if teleportRemote then
teleportRemote:FireServer(id)
else
local p = workspace:FindFirstChild("TeleportPoint") and workspace.TeleportPoint:FindFirstChild(tostring(id))
if p then moveTo(p.CFrame + Vector3.new(0, 4, 0)) end
end
end) })
local items, byName = {}, {}
for ci, cat in ipairs(MERCHANT_CATEGORIES) do
for _, m in ipairs(cat.items) do
items[#items + 1] = { Name = m.name, Rarity = MERCHANT_TABS[ci], Model = function() return findMerchantTarget(m) end }
byName[m.name] = m
end
end
pick.merchant = items[1].Name
local mc = tab:Section()
mc:Header({ Name = L("พ่อค้า / NPC", "Merchants / NPCs") })
local reqRow = mc:Label({ Text = byName[pick.merchant].req })
mc:EggPicker({ Name = "NPC", Single = true, Items = items, Rarities = MERCHANT_TABS, Default = { pick.merchant }, Callback = function(names)
if not names[1] then return end
pick.merchant = names[1]
reqRow:UpdateName(byName[pick.merchant] and byName[pick.merchant].req or "")
end })
mc:Toggle({ Name = L("วาร์ปทันที (ไม่บิน)", "Instant warp (no flying)"), Description = L("กดได้ทุก 10 วิ · ปิด = บินไปแบบปลอดภัย", "Once per 10 s · off = fly there safely"), Default = config.instantNpcWarp, Callback = UI.set("instantNpcWarp") }, "instantNpcWarp")
mc:Button({ Name = L("วาร์ปไปหา", "Warp there"), Primary = true, Callback = UI.action("merchant", 1, function()
logLine("TRAVEL", "npc " .. tostring(pick.merchant))
if byName[pick.merchant] then warpToMerchant(byName[pick.merchant]) end
end) })
end
local function buildWebhookPage(tab)
local wh = tab:Section()
wh:Header({ Name = "Discord Webhook" })
wh:Input({ Name = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Default = config.discordWebhookUrl, Width = 260,
Callback = UI.set("discordWebhookUrl") }, "discordWebhookUrl")
wh:Button({ Name = L("ทดสอบส่ง", "Send a test"), Callback = UI.action("webhookTest", 3, function()
if not string.find(config.discordWebhookUrl or "", "discord", 1, true) then
return UI.notify(L("ใส่ Webhook URL ก่อน", "Enter a webhook URL first"))
end
sendDiscordWebhook("🧪 Test", HUB_NAME, 2796287, {
{ name = "👤", value = player.Name, inline = true },
{ name = "📈", value = "Lv. " .. tostring(getPlayerLevel()), inline = true },
})
UI.notify(L("ส่งแล้ว", "Sent"))
end) })
local ev = tab:Section()
ev:Header({ Name = L("แจ้งเตือนเมื่อ", "Notify when") })
ev:Toggle({ Name = L("ได้ไอเทมดรอป", "An item drops"), Default = config.discordNotifyDrop, Callback = UI.set("discordNotifyDrop") }, "discordNotifyDrop")
ev:Toggle({ Name = L("ฆ่าบอสได้", "A boss is killed"), Default = config.discordNotifyBoss, Callback = UI.set("discordNotifyBoss") }, "discordNotifyBoss")
ev:Toggle({ Name = L("เลเวลอัปทุก 50", "Every 50 levels"), Default = config.discordNotifyLevel, Callback = UI.set("discordNotifyLevel") }, "discordNotifyLevel")
ev:Toggle({ Name = L("ย้ายห้อง / หลุด", "Server hop / disconnect"), Default = config.discordNotifyHop, Callback = UI.set("discordNotifyHop") }, "discordNotifyHop")
end
local function buildGameSettingsPage(tab)
local fx = tab:Section()
fx:Header({ Name = L("ลดแล็ก & RAM", "Performance") })
fx:Toggle({ Name = L("ลดแล็ก", "FPS boost"), Description = L("ปิดเอฟเฟกต์ สั่น และคัตซีน", "Turns off effects, shake and cutscenes"), Default = config.hideVfx,
Callback = function(v)
if v ~= config.hideVfx then toggleHideVfx() end
UI.queueSave()
end }, "hideVfx")
fx:Toggle({ Name = L("ประหยัด RAM (ปิดเสียงเอฟเฟกต์)", "Save RAM (mute effect sounds)"),
Description = L("ลด RAM หมวดเสียงได้ราว 240 MB จากที่ทดสอบ; ปิดแล้วคืนเสียงได้", "Saved about 240 MB of sound memory in testing; turn off to restore sounds"),
Default = config.lowRamAudio, Callback = function(v)
if v ~= config.lowRamAudio then setLowRamAudio(v) end
UI.queueSave()
end }, "lowRamAudio")
local a = tab:Section()
a:Header({ Name = L("ลบ Artifact อัตโนมัติ", "Auto delete artifacts"), Description = L("ลบถาวร เอาคืนไม่ได้", "Deleted for good; can't be undone") })
local function deleter(key, name)
UI.settingToggle(a, "game" .. key, key, name, L("Artifact ระดับนี้ที่ได้จะถูกลบทันที", "New artifacts of this rarity are deleted right away"), true)
end
deleter("Auto_Delete_Rare_Artifacts", L("ลบ Rare", "Delete Rare"))
deleter("Auto_Delete_Epic_Artifacts", L("ลบ Epic", "Delete Epic"))
deleter("Auto_Delete_Legendary_Artifacts", L("ลบ Legendary", "Delete Legendary"))
end
local function buildSettingsPage(tab)
local sv = tab:Section()
sv:Header({ Name = L("กันหลุด / ข้ามคืน", "Stay online") })
sv:Toggle({ Name = L("กัน AFK", "Anti-AFK"), Default = config.antiAfk, Callback = UI.set("antiAfk") }, "antiAfk")
sv:Toggle({ Name = L("เข้าเกมใหม่เมื่อหลุด", "Rejoin on disconnect"), Default = config.autoRejoin, Callback = UI.set("autoRejoin") }, "autoRejoin")
sv:Toggle({ Name = L("รันสคริปต์ต่อหลังย้ายห้อง", "Keep running after teleport"), Default = config.autoReexecute, Callback = UI.set("autoReexecute", function(v)
setFlagFile(REEXEC_OFF_FILE, not v)
if v then queueReexecute("setting on") end
end) }, "autoReexecute")
sv:Buttons({
{ Name = L("ย้ายห้อง", "Server hop"), Callback = UI.action("hop", 5, function() serverHop() end) },
{ Name = L("รีจอยห้องเดิม", "Rejoin"), Callback = UI.action("rejoin", 5, function() rejoinServer() end) },
})
local menu = tab:Section()
menu:Header({ Name = L("เมนู", "Menu") })
menu:Dropdown({
Name = L("ภาษา", "Language"), Description = L("เปลี่ยนแล้วเมนูจะเปิดใหม่ ค่าที่ตั้งไว้ยังอยู่ครบ", "The menu reopens in the new language; your settings are kept"),
Options = { "ไทย", "English" }, Default = LANG == "en" and "English" or "ไทย",
Callback = function(v)
local want = v == "English" and "en" or "th"
if want == LANG then return end
pcall(writefile, DATA_DIR .. "/lang.txt", want)
DukeGUI:SaveConfig(CONFIG_NAME)
logLine("LANG", "switch to " .. want)
LANG = want
task.defer(function() safe("LANG", UI.rebuildWindow) end)
end,
})
local SCALE_AUTO = L("อัตโนมัติ (พอดีจอ)", "Auto (fit screen)")
local sizePick
sizePick = menu:Dropdown({
Name = L("ขนาดเมนู", "Menu size"), Description = L("อัตโนมัติ = ย่อให้พอดีจอ เหมาะกับมือถือ", "Auto shrinks the menu to fit the screen (good for phones)"),
Options = { SCALE_AUTO, "50%", "60%", "70%", "80%", "90%", "100%", "110%", "125%", "150%" }, Default = SCALE_AUTO,
Callback = function(v)

if v == nil then
task.defer(function() if sizePick and sizePick.Value == nil then sizePick:UpdateSelection(menuScale.auto and SCALE_AUTO or (menuScale.pct .. "%")) end end)
end
local pct = type(v) == "string" and tonumber(v:match("^(%d+)%%$"))
menuScale.auto = pct == nil
menuScale.pct = pct or menuScale.pct
applyMenuScale()
UI.queueSave()
end,
}, "menuScale")
menu:Value({ Name = L("ซ่อน / แสดงเมนู", "Hide / show menu"), Text = L("Right Ctrl · มือถือ: จุดเหลือง", "Right Ctrl · phone: yellow dot") })
menu:Button({ Name = L("ปิดสคริปต์", "Close script"), Callback = UI.action("close", 1, function()
W:Dialog({
Title = HUB_NAME, Description = L("ปิดเมนูและหยุดทุกระบบที่ทำงานอยู่?", "Close the menu and stop everything that is running?"),
Buttons = { { Name = L("ปิด", "Close"), Callback = function() W:Unload() end }, { Name = L("ยกเลิก", "Cancel") } },
})
end) })
local br = tab:Section()
br:Header({ Name = L("รายงานบั๊ก", "Bug report"), Description = L("เจอปัญหา? กดบันทึกแล้วส่งไฟล์มาพร้อมอธิบายสั้น ๆ", "Found a problem? Save a report and send the file with a short description.") })
local saved = { path = nil }
UI.statusRow(br, function()
if saved.path then return L("บันทึกแล้ว: ", "Saved: ") .. saved.path, "done" end
return L("กำลังบันทึก", "Recording"), "run"
end)
br:Button({ Name = L("บันทึกรายงานบั๊ก", "Save bug report"), Primary = true, Callback = UI.action("bugReport", 2, function()
local path = RL.Export(UI.snapshot())
if path then
saved.path = path
W:Notify({ Title = L("บันทึกรายงานแล้ว", "Bug report saved"), Lifetime = 8,
Description = path .. L(" (ในโฟลเดอร์ workspace ของ executor · คัดลอก path แล้ว)", " (in your executor's workspace folder; path copied)") })
else
UI.notify(L("บันทึกไม่ได้ (executor ไม่รองรับการเขียนไฟล์)", "Could not save (the executor can't write files)"))
end
end) })
end
local function buildWindow()
createWindow()
BOSS_TIMED = L("บอสเวลา", "Timed")
BOSS_GROUPS[#BOSS_GROUPS] = BOSS_TIMED
local tabs = { L("ดาบ", "Weapons"), L("สไตล์", "Styles"), L("อเวค", "Mastery"), L("เผ่า", "Races"), L("สุ่ม / ฮาคิ", "Gacha"), L("แลกของ", "Exchange") }
for i, v in ipairs(tabs) do MERCHANT_TABS[i] = v end
table.clear(UI.rows)
table.clear(UI.shown)
local farm = W:TabGroup({ Name = L("ฟาร์ม", "Farm") })
local tabFarm = farm:Tab({ Name = L("ฟาร์มเลเวล", "Level farm"), Title = L("ฟาร์มเลเวล", "Level farm"), Description = L("เควสต์อัตโนมัติ ข้ามเวล และตีมอนที่เลือก", "Auto quest, level skipping and a chosen monster") })
buildLevelPage(tabFarm)
local goalTab = farm:Tab({ Name = L("เป้าหมาย & ไอเทม", "Goal & items"), Title = L("เป้าหมาย & ไอเทม", "Goal & items"), Description = L("ทำสไตล์/อาวุธ/เผ่าให้จนได้ในปุ่มเดียว หรือฟาร์มไอเทมชิ้นเดียว", "Get a style/weapon/race done in one switch, or farm a single item") })
buildGoalPage(goalTab)
buildItemCards(goalTab)
buildQuestPage(farm:Tab({ Name = L("เควสต์ & Rank", "Quests & rank"), Title = L("เควสต์ & Rank", "Quests & rank"), Description = L("อัป Rank, เควสต์ Killer B และของเควสต์บนแมพ", "Rank up, the Killer B quest and quest items on the map") }))
local boss = W:TabGroup({ Name = L("บอส", "Bosses"), Separator = true })
buildWorldBossPage(boss:Tab({ Name = L("บอสโลก", "World bosses"), Title = L("บอสโลก", "World bosses"), Description = L("บอสที่เกิดเองตามเวลา และบอสที่มีคนอัญเชิญในห้อง", "Bosses that spawn on a timer, and ones someone summoned") }))
buildSummonPage(boss:Tab({ Name = L("บอสอัญเชิญ", "Summon bosses"), Title = L("บอสอัญเชิญ", "Summon bosses"), Description = L("อัญเชิญ ความยาก และบอส Pity", "Summoning, difficulty and pity") }))
local content = W:TabGroup({ Name = L("ด่าน", "Content"), Separator = true })
buildDungeonPage(content:Tab({ Name = L("ดันเจี้ยน", "Dungeon"), Title = L("ดันเจี้ยน", "Dungeon") }))
buildTowerPage(content:Tab({ Name = L("หอคอย", "Tower"), Title = L("หอคอย", "Tower") }))
buildSeaPage(content:Tab({ Name = L("ทะเล", "Sea"), Title = L("ทะเล (Sea)", "Sea") }))
local me = W:TabGroup({ Name = L("ตัวละคร", "Player"), Separator = true })
buildCharacterPage(me:Tab({ Name = L("ตัวละคร", "Character"), Title = L("ตัวละคร", "Character"), Description = L("ฮาคิ วิ่งเร็ว กระโดด ESP และสเตตัส", "Haki, speed, jump, ESP and stats") }))
buildPvPPage(me:Tab({ Name = "PvP", Title = L("วาร์ปตีผู้เล่น", "Player PvP") }))
local shop = W:TabGroup({ Name = L("ของ & ร้าน", "Items & shops"), Separator = true })
local bag = shop:Tab({ Name = L("กระเป๋า & เก็บของ", "Bag & collect"), Title = L("กระเป๋า & เก็บของ", "Bag & collect"), Description = L("เปิดกล่อง เก็บหีบ/เมล็ด และทิ้งผลไม้", "Open chests, collect chests/seeds and drop fruits") })
buildBagPage(bag)
buildCollectCard(bag)
buildGachaPage(shop:Tab({ Name = L("กาชา", "Gacha"), Title = L("กาชา", "Gacha") }))
buildTravelPage(shop:Tab({ Name = L("วาร์ป / พ่อค้า", "Travel"), Title = L("วาร์ป / พ่อค้า", "Travel") }))
local other = W:TabGroup({ Name = L("ตั้งค่า", "Settings"), Separator = true })
buildFarmSettingsPage(other:Tab({ Name = L("ตั้งค่าการฟาร์ม", "Farm settings"), Title = L("ตั้งค่าการฟาร์ม", "Farm settings"), Description = L("ใช้กับทุกโหมดฟาร์ม", "Used by every farm mode") }))
buildGameSettingsPage(other:Tab({ Name = L("ตั้งค่าเกม", "Game settings"), Title = L("ตั้งค่าเกม", "Game settings") }))
buildWebhookPage(other:Tab({ Name = L("แจ้งเตือน", "Notifications"), Title = L("แจ้งเตือน Discord", "Discord notifications") }))
buildSettingsPage(other:Tab({ Name = L("ระบบ", "System"), Title = L("ระบบ", "System"), Description = L("กันหลุด ย้ายห้อง เมนู และรายงานบั๊ก", "Stay online, server hop, menu and bug report") }))
tabFarm:Select()
W:SetStatus(L("พร้อม", "Ready"), "", "", "off")
end
function UI.rebuildWindow()
UI.configLoading = true
local old = W
old.onUnloaded(function() end)
old:Unload()
buildWindow()
UI.applyingConfig = true
DukeGUI:LoadConfig(CONFIG_NAME)
UI.applyingConfig = false
task.delay(2, function() UI.configLoading = false end)
end
do
local ok, err = xpcall(buildWindow, errHandler)
if not ok then
logError("LOAD", err)
logLine("LOAD", "menu build failed -> stop")
RL.Flush()
emergencyStop()
env.__LineageBooting = nil
pcall(function() StarterGui:SetCore("SendNotification", {Title = HUB_NAME, Text = "โหลดเมนูไม่สำเร็จ (ดู bug report)", Duration = 8}) end)
return false
end
end
local statusBar = { L("พร้อม", "Ready"), "", "", "off" }
UI.statusBar = statusBar
task.spawn(function()
while state.alive do
safe("STATUS", function()
local right = "Lv. " .. tostring(getPlayerLevel())
local mode
if config.autoPvP then mode = "PvP"
elseif config.autoNarutoQuest then mode = L("เควสต์นารูโตะ", "Naruto quest")
elseif config.autoRank then mode = L("อัป Rank", "Rank up")
elseif config.autoGoal then mode = L("ทำเป้าหมาย", "Goal")
elseif config.autoFarmWorldBoss and state.worldBossUp then mode = L("บอสโลก", "World boss")
elseif config.autoFarm then mode = L("ฟาร์มเลเวล", "Level farm")
elseif config.autoFarmSpecificItem then mode = L("ฟาร์มไอเทม", "Item farm")
elseif config.autoFarmNoQuest then mode = L("ฟาร์มมอน", "Monster farm")
elseif config.autoFarmWorldBoss then mode = L("บอสโลก", "World boss")
elseif config.autoFarmSummonedBoss or config.autoFarmPityBoss then mode = L("ตีบอส", "Boss farm")
elseif config.autoKillAllDungeon or config.autoKillAllTower or config.autoKillMobsSea or config.autoClearYhwachPillars then mode = L("เคลียร์ด่าน", "Clearing")
end
if state.collectingChests then
statusBar[1], statusBar[2], statusBar[3], statusBar[4] = L("เก็บหีบ", "Chests"), L("กำลังเก็บ", "Collecting"), right, "run"
elseif mode and state.retreat then
statusBar[1], statusBar[2], statusBar[3], statusBar[4] = mode, L("ถอยพักเลือด", "Recovering HP"), right, "wait"
elseif mode and state.statusTarget then
statusBar[1], statusBar[2], statusBar[3], statusBar[4] = mode, state.statusTarget, right, "run"
elseif mode then
statusBar[1], statusBar[2], statusBar[3], statusBar[4] = mode, L("รอเป้าหมาย", "Waiting for a target"), right, "wait"
else
statusBar[1], statusBar[2], statusBar[3], statusBar[4] = L("พร้อม", "Ready"), "", right, "off"
end
end)
task.wait(1)
end
end)
do
local since = math.huge
local conn
conn = track(RunService.Heartbeat:Connect(function(dt)
if not state.alive then conn:Disconnect() return end
since = since + dt
if since < 0.5 then return end
since = 0
local key = table.concat(statusBar, "|")
if UI.shown.bar ~= key then
UI.shown.bar = key
pcall(W.SetStatus, W, statusBar[1], statusBar[2], statusBar[3], statusBar[4])
end
for _, r in ipairs(UI.rows) do
local ok, t, tone = pcall(r.get)
if ok then
local k = tostring(t) .. "|" .. tostring(tone)
if r.shown ~= k then
r.shown = k
if r.set then pcall(r.set, tostring(t))
elseif r.value then pcall(r.row.UpdateName, r.row, tostring(t))
else pcall(r.row.Set, r.row, tostring(t), tone or "off") end
end
end
end
end))
end
function UI.snapshot()
local flags = {}
for flag, o in pairs(DukeGUI.Options) do
if flag ~= "discordWebhookUrl" then
local v = o.State
if v == nil then v = o.Value end
if type(v) == "table" then
local t = {}
for k, on in pairs(v) do t[#t + 1] = type(k) == "number" and tostring(on) or (on and tostring(k)) or nil end
v = table.concat(t, "+")
end
flags[#flags + 1] = tostring(flag) .. "=" .. tostring(v)
end
end
table.sort(flags)
local mem = 0
pcall(function() mem = game:GetService("Stats"):GetTotalMemoryUsageMb() end)
local ping = 0
pcall(function() ping = player:GetNetworkPing() * 1000 end)
return {
string.format("v=%s place=%d job=%s exec=%s lang=%s scale=%.2f", VERSION, game.PlaceId, game.JobId, execName, LANG, menuScale.now),
string.format("mem=%.0fMB lua=%.0fKB ping=%.0fms uptime=%.0fs", mem, collectgarbage("count"), ping, os.clock() - START_CLOCK),
"status: " .. table.concat(statusBar, " | "),
"flags: " .. table.concat(flags, ", "),
}
end
return true
end
if not setupMenu() then return end
local espFolder, heartbeatConn
local function startFarmLoop()
espFolder = new("Folder", {Name = HUB_NAME .. "ESP", Parent = workspace})
local function findQuestNpc(questId)
local folder = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("Quest")
for _, npc in ipairs(folder and folder:GetChildren() or {}) do
if npc:GetAttribute("QuestId") == questId then
return npc, npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart", true)
end
end
return nil
end
local function currentQuestTarget()
local attr = player:GetAttribute("QuestTarget")
if attr then return attr end
local ok, info = pcall(function() return player.PlayerGui.ScreenGui.Quest.Container.QuestFrame end)
if not ok or not info or not info.Visible then return nil end
local label = info:FindFirstChild("Info", true)
return label and label.Text:match("^Defeat%s+%d+%s+(.+)%s+%(%d+/%d+%)%s*$") or nil
end
local function acceptQuest(questId, targetName, skipped)
state.questBusy = true
safe("QUEST", function()
local npc, part = findQuestNpc(questId)
if not part then
logLine("QUEST", "quest NPC not found for id " .. tostring(questId))
return
end
local curTarget = currentQuestTarget()
local knownQuest = false
for _, q in pairs(questData) do if type(q) == "table" and q.Target == curTarget then knownQuest = true break end end
if curTarget and curTarget ~= targetName and not knownQuest then
state.questFails = (state.questFails or 0) + 1
logLine("QUEST", "unknown current quest '" .. tostring(curTarget) .. "' -> not cancelling #" .. state.questFails)
return
end

if curTarget ~= targetName then
logLine("QUEST", string.format("cancel %s -> %s", tostring(curTarget), targetName))
questRemote:FireServer("Cancel")
task.wait(0.3)
end

questRemote:FireServer("Request", {Id = questId})
task.wait(1)
local ok = currentQuestTarget() == targetName
if not ok and skipped then

Farm.lockFails[questId] = (Farm.lockFails[questId] or 0) + 1
logLine("QUEST", string.format("request %s (id %s, +%d tier) -> refused #%d", targetName, tostring(questId), skipped, Farm.lockFails[questId]))
if Farm.lockFails[questId] >= 2 then
Farm.lockFails[questId] = 0
Farm.locked[questId] = os.clock() + 600
tellPlayer("quest:lock:" .. questId, string.format(L("NPC ไม่ให้เควสต์ %s (เลเวลยังไม่ถึง) · ใช้ช่วงต่ำลง 10 นาที", "The NPC won't give the %s quest (level too low) · using a lower tier for 10 min"), targetName))
end
return
end
if ok then Farm.lockFails[questId] = 0 end
state.questFails = ok and 0 or (state.questFails or 0) + 1
logLine("QUEST", string.format("request %s (id %s) at %s -> %s", targetName, tostring(questId), npc.Name, ok and "accepted" or ("not accepted #" .. state.questFails)))
if state.questFails >= 3 then
tellPlayer("quest:" .. targetName, string.format(L("รับเควสต์ %s ไม่ได้ · ฟาร์มต่อโดยไม่มีเควสต์ ลองใหม่ใน 1 นาที", "Can't take the %s quest · farming without it, retrying in 1 min"), targetName))
end
end)
state.questBusy = false
end
local function firstLiveMob(char)
for _, name in ipairs({"Enemies", "Boss", "Live"}) do
local f = workspace:FindFirstChild(name)
for _, m in ipairs(f and f:GetChildren() or {}) do
local h = m:FindFirstChildOfClass("Humanoid")
if h and h.Health > 0 and m ~= char then return m end
end
end
return nil
end

local function defendTarget()
local mode = ReplicatedStorage:FindFirstChild("Game") and ReplicatedStorage.Game:FindFirstChild("Naruto")
local host, hp = mode and mode:FindFirstChild("Host"), mode and mode:FindFirstChild("PillarHP")
if not (host and host.Value == player.Name and hp and hp.Value > 0) then return nil end
local pillar = state.pillarPart
if not (pillar and pillar.Parent) and os.clock() - (state.pillarScan or -math.huge) > 5 then
state.pillarScan = os.clock()
pillar = nil
for _, folderName in ipairs({"Escort", "Map", "Boss"}) do
local f = workspace:FindFirstChild(folderName)
for _, d in ipairs(f and f:GetDescendants() or {}) do
if d:IsA("BasePart") and d.Name:lower():find("pillar") then pillar = d break end
end
if pillar then break end
end
state.pillarPart = pillar
logLine("DUNGEON", "chakra pillar: " .. (pillar and pillar:GetFullName() or "not found"))
end
if not (pillar and pillar.Parent) then return nil end
local best, bestDist = nil, math.huge
local f = workspace:FindFirstChild("Enemies")
for _, m in ipairs(f and f:GetDescendants() or {}) do
if m:IsA("Model") then
local h = m:FindFirstChildOfClass("Humanoid")
local r = h and h.Health > 0 and (m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart)
if r and (r.Position - pillar.Position).Magnitude < bestDist then best, bestDist = m, (r.Position - pillar.Position).Magnitude end
end
end
return best
end

local function itemFarmable(mat)
if mat.dungeon or mat.how or not (mat.mob or mat.anyMob) then return false end
return not mat.quest or player:GetAttribute("QuestlineId") == mat.quest
end
local DIFF_RANK = {Easy = 1, Medium = 2, Hard = 3, Extreme = 4}
local function itemFarmTarget(mat, reason)
if mat.anyMob then
state.itemFarmNeed = getCurrentTier()[3]
return findTargetMob(state.itemFarmNeed)
end
state.itemFarmNeed = mat.mob
local target = findTargetMob(mat.mob)
if not target and config.autoSummonForItems then
local diff = DIFF_RANK[config.itemSummonDifficulty] and config.itemSummonDifficulty or "Easy"
if mat.minDiff and DIFF_RANK[diff] < DIFF_RANK[mat.minDiff] then diff = mat.minDiff end
ensureAutoSummon(mat.mob, reason, diff)
end
return target
end
local function selectRankTarget(char)
local job = state.rankTask
if not job then return nil end
if Rank.hostedPortal() then return firstLiveMob(char) end
if job.kind ~= "item" and state.autoSummonOwned then releaseAutoSummon("rank task changed") end
if job.kind == "item" then
state.itemFarmNeed = job.info.mob
local target = job.info.isBoss and findBossTarget(job.info.mob) or findTargetMob(job.info.mob)
local summoner = Rank.SUMMONERS[job.info.mob]
if not target and summoner then

local have, cost = Rank.summonerFill(summoner)
if have and cost and have >= cost then target = Rank.spawnerBoss(summoner, job.info.mob) end
elseif not target and config.autoSummonForItems and job.info.isBoss then
ensureAutoSummon(job.info.mob, "rank item " .. tostring(job.need.key))
end
if target then return target end

if summoner and summoner.orbMob then
local orbMob = findTargetMob(summoner.orbMob)
if orbMob or (workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild(summoner.orbMob)) then return orbMob end
end
return findTargetMob(getCurrentTier()[3])
end
state.itemFarmNeed = nil
if job.kind == "boss" then
return findBossTarget("[All Spawned Bosses]") or findTargetMob(getCurrentTier()[3])
end
if job.kind == "mob" or job.kind == "blocked" then
return findTargetMob(getCurrentTier()[3])
end
return nil
end

local function worldBossTarget(now)
local picks = config.worldBosses
if #picks == 0 then return nil end
local all = table.find(picks, "[All Spawned Bosses]") ~= nil
local best, bestDist = nil, math.huge
if all then
best = findBossTarget("[All Spawned Bosses]")
else
local _, _, root = getCharParts()
for _, name in ipairs(picks) do
local m = findBossTarget(name)
local r = m and (m:FindFirstChild("HumanoidRootPart") or m.PrimaryPart)
if r and root and (state.avoidTargets[m] or 0) <= now then
local d = (r.Position - root.Position).Magnitude
if d < bestDist then best, bestDist = m, d end
end
end
end
if best or not config.autoHopBoss or IN_SEA then
state.lastBossSeenTime = now
return best
end
state.lastBossSeenTime = state.lastBossSeenTime or now
if now - state.lastBossSeenTime >= 25 and now - (state.lastHopAttempt or 0) >= 30 then
for name, t in pairs(Farm.bossTimes()) do
if (all or table.find(picks, name)) and t.eta and t.eta <= 90 then return nil end
end
state.lastHopAttempt = now
logLine("HOP", "no world boss for 25 s and none due within 90 s -> hop")
showNotification("Boss Hop", L("ไม่มีบอสในห้องนี้ และไม่มีตัวไหนจะเกิดใน 90 วิ · กำลังย้ายห้อง", "No boss here and none spawns within 90 s · hopping"), 4)
serverHop()
end
return nil
end

local function levelFarmTarget(now, tier)
local targetName = tier and tier[3] or Farm.mobName(config.selectedMonster)
local questId = tier and tier[2]
state.levelQuest = targetName
if settingEvent and now - (state.lastRepeatCheck or 0) >= 6 then
state.lastRepeatCheck = now
if player:GetAttribute("Auto_Repeat_Quest") ~= true then
safe("SETTING", function() settingEvent:FireServer("Auto_Repeat_Quest", true) end)
end
end
if questRemote and questId and not state.questBusy then
local current = currentQuestTarget()
if current == targetName then
state.questMissSince = nil
elseif now - state.lastQuest >= ((state.questFails or 0) >= 3 and 60 or 2) then
state.questMissSince = state.questMissSince or now
if current ~= nil or now - state.questMissSince >= 1.5 then
state.lastQuest = now
state.questMissSince = nil
if (state.questFails or 0) >= 3 then state.questFails = 0 end
if current then logLine("QUEST", string.format("switch %s -> %s (lv %d)", current, targetName, getPlayerLevel())) end
task.spawn(acceptQuest, questId, targetName, Farm.inUse > 0 and Farm.inUse or nil)
return nil
end
end
end
return findTargetMob(targetName)
end

local function goalTarget(now)
local job = Goal.job
state.goalTool = job and job.tool or nil
state.goalCollect = job and job.kind == "collect" and job.group or nil
if not job then return nil end
if job.kind == "kill" then
state.itemFarmNeed = job.target
local target = findTargetMob(job.target)
local data = bossesData[job.target]
if not target and config.autoSummonForItems and type(data) == "table" and data.Type == "Summon" then
ensureAutoSummon(job.target, "goal quest kill", job.diff)
end
return target
elseif job.kind == "boss" then

local target = Goal.findTypedBoss(job.bossType, job.diff ~= nil)
local pick, short = Goal.typeSummon(job.bossType, job.diff ~= nil)
state.itemFarmNeed = pick
if not target and pick and short == 0 and config.autoSummonForItems then
ensureAutoSummon(pick, "goal quest boss " .. tostring(job.bossType or "any"), job.diff)
end
return target
elseif job.kind == "item" then
if job.mat.item == "Cursed Orb" then
local target = Goal.liveOrbTarget()
state.itemFarmNeed = target and target.Name or "Cursed Orb"
return target
end

local tier = getCurrentTier()
if tier and job.mat.mob == tier[3] then
state.itemFarmNeed = job.mat.mob
Farm.inUse = 0
return levelFarmTarget(now, tier)
end
return itemFarmTarget(job.mat, "goal " .. tostring(job.mat.item))
elseif job.kind == "level" or job.kind == "money" then
state.itemFarmNeed = nil
Farm.inUse = 0
return levelFarmTarget(now, getCurrentTier())
elseif job.kind == "chaser" then

state.itemFarmNeed = Goal.chaser and Goal.chaser.mob or nil
return Goal.chaser and findTargetMob(Goal.chaser.mob) or nil
end
state.itemFarmNeed = nil
return nil
end
local function selectFarmTarget(now, char)
local targetMob = nil

if IN_SEA and not config.autoPvP then
if config.autoClearYhwachPillars then
targetMob = findTargetMob("Pillar")
if targetMob then return targetMob end
end
if config.autoKillAllDungeon or config.autoKillAllTower or config.autoKillMobsSea then
targetMob = defendTarget() or firstLiveMob(char)
if targetMob then return targetMob end
end
end

local worldBoss = config.autoFarmWorldBoss and not (config.autoPvP or config.autoNarutoQuest or config.autoRank)
and worldBossTarget(now) or nil
state.worldBossUp = worldBoss ~= nil
if config.autoPvP then
local other = findPvPPlayer()
if other and player:GetAttribute("Disable_PVP") ~= true and other:GetAttribute("Disable_PVP") ~= true
and other.Character and other.Character:GetAttribute("SafeZone") ~= true then
targetMob = livePvPCharacter(other)
end
elseif config.autoNarutoQuest then
local questlineId = player:GetAttribute("QuestlineId")
if questlineId == 190 then
targetMob = findTargetMob("Hollow") or findTargetMob("TrainingDummy")
elseif questlineId == 192 then
targetMob = findChakraFlowMob()
if not targetMob then
targetMob = findTargetMob(getCurrentTier()[3]) or findTargetMob("Bandit")
tellPlayer("naruto:chakra", L("ยังไม่พบ Chakra Flow · ตีมอนตามเลเวลเพื่อให้เกิดตัวใหม่", "Farming level-matched NPCs until Chakra Flow spawns"))
end
elseif questlineId == nil and player:GetAttribute("Questline190") ~= true then
targetMob = findTargetMob(getCurrentTier()[3])
end
elseif config.autoRank then
targetMob = selectRankTarget(char)
elseif config.autoFarmWorldBoss and worldBoss then
targetMob = worldBoss
elseif config.autoGoal then
targetMob = goalTarget(now)
elseif config.autoFarm then
targetMob = levelFarmTarget(now, Farm.selectedTier())
elseif config.autoFarmSpecificItem then
local itemInfo = ITEM_DROP_MAP[config.selectedSpecificItem]
if itemInfo and not state.inventoryInit then return nil end
local goal = tonumber(config.specificItemTarget)
local have = state.inventory[config.selectedSpecificItem] or 0
if itemInfo and goal and have >= goal then
state.itemFarmNeed = nil
logLine("ITEMFARM", string.format("specific item done: %s %d/%d -> stop", tostring(config.selectedSpecificItem), have, goal))
showNotification("🎉", string.format("%s %d/%d", tostring(config.selectedSpecificItem), have, goal), 5)
config.autoFarmSpecificItem = false
UI.mirror("autoFarmSpecificItem", false)
releaseAutoSummon("specific item complete")
return nil
end
if itemInfo then
if itemFarmable(itemInfo) then
targetMob = itemFarmTarget(itemInfo, "item " .. tostring(config.selectedSpecificItem))
else
state.itemFarmNeed = nil
tellPlayer("itemfarm:quest:" .. tostring(config.selectedSpecificItem), string.format(L("%s ดรอปเฉพาะตอนถือเควสต์ %s", "%s only drops while quest %s is active"), tostring(config.selectedSpecificItem), tostring(itemInfo.quest)))
end
end
elseif config.autoFarmNoQuest then
targetMob = findTargetMob(config.selectedMonsterNoQuest)
elseif config.autoFarmSummonedBoss then
targetMob = findTargetMob(config.selectedBoss)
elseif config.autoFarmPityBoss then
targetMob = findTargetMob(config.pitySelectPityBoss) or findTargetMob(config.pitySelectBoss)
end
return targetMob
end
local function farmTick()
local char, hum, root = getCharParts()
if not char or not hum or hum.Health <= 0 or not root then return end
if state.droppingFruits then return end
local now = os.clock()
if not state.safeSpot then
state.safeSpot = root.CFrame
end
if config.speedHack then
if hum.WalkSpeed ~= 160 then
if not state.speedOrig then state.speedOrig = hum.WalkSpeed end
hum.WalkSpeed = 160
end
elseif state.speedOrig then
hum.WalkSpeed = state.speedOrig
state.speedOrig = nil
end
if config.infinityJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
root.Velocity = Vector3.new(root.Velocity.X, 45, root.Velocity.Z)
end
local function keepHaki(enabled, attr, unlocked, lastKey, triesKey)
if enabled and unlocked == false and not state["toldLocked" .. attr] then
state["toldLocked" .. attr] = true
tellPlayer("haki:" .. attr, attr == "Haki" and L("ยังไม่ได้ปลดฮาคิเกราะ · ข้ามไป", "Buso Haki is not unlocked · skipped")
or L("ยังไม่ได้ปลดฮาคิสังเกต · ข้ามไป", "Ken Haki is not unlocked · skipped"))
end
if not enabled or not actionRemote or unlocked == false or now - state[lastKey] < 3 then return end
state[lastKey] = now
if char:GetAttribute(attr) == true or player:GetAttribute(attr) == true then state[triesKey] = 0 return end
local tries = (state[triesKey] or 0) + 1
state[triesKey] = tries
if tries <= 3 then
safe("HAKI", function() actionRemote:FireServer(attr) end)
elseif tries == 4 then
logLine("HAKI", attr .. " still off after 3 tries -> pause 60 s")
tellPlayer("hakifail:" .. attr, L("เปิดฮาคิไม่ติด · พัก 1 นาทีแล้วลองใหม่", "Haki did not turn on · retrying in 1 min"))
elseif tries >= 23 then
state[triesKey] = 0
end
end
keepHaki(config.autoHaki, "Haki", state.profile.BusoHaki, "lastHaki", "hakiTries")
keepHaki(config.autoObsHaki, "ObsHaki", state.profile.ObsHaki, "lastObsHaki", "obsTries")
if config.espPlayer and (now - state.lastESP >= 1) then
state.lastESP = now
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player and p.Character then
local hl = espFolder:FindFirstChild(p.Name) or new("Highlight", {Name = p.Name, FillColor = Color3.fromRGB(42, 170, 255), OutlineColor = Color3.fromRGB(255, 255, 255), Parent = espFolder})
if hl.Adornee ~= p.Character then hl.Adornee = p.Character end
end
end
for _, hl in ipairs(espFolder:GetChildren()) do
if not Players:FindFirstChild(hl.Name) then hl:Destroy() end
end
elseif not config.espPlayer and #espFolder:GetChildren() > 0 then
espFolder:ClearAllChildren()
end
if portalEvent and config.autoCreateDungeon and state.portalSelector and now - state.lastDungeon >= 2 then
state.lastDungeon = now
local key = dungeonKey(DNG_MAP[config.selectDungeon] or "ARTIFACT_01")
if state.inventoryInit and (state.inventory[key] or 0) <= 0 then
logLine("SPEND", "auto create portal stop: no " .. key)
showNotification("Dungeon", L("กุญแจหมด: ", "Out of keys: ") .. key, 5)
config.autoCreateDungeon = false
UI.mirror("autoCreateDungeon", false)
elseif state.inventoryInit then
if createPortal("auto") then
state.lastPortalCreate = now
task.delay(2, function() safe("DUNGEON", function() portalEvent:FireServer("EarlyStart") end) end)
end
end
elseif portalEvent and Rank.materialEvent and config.autoCreateDungeon and not IN_SEA and not state.portalSelector and state.inventoryInit
and now - (state.lastPortalKeyUse or 0) >= 15 and now - (state.lastPortalCreate or 0) >= 30 then

state.lastPortalKeyUse = now
local key = dungeonKey(DNG_MAP[config.selectDungeon] or "ARTIFACT_01")
local screen = player.PlayerGui:FindFirstChild("ScreenGui")
local selectorFrame = screen and screen:FindFirstChild("Portals") and screen.Portals:FindFirstChild("SelectorFrame")
if selectorFrame and selectorFrame.Visible then

state.portalSelector = true
elseif (state.inventory[key] or 0) > 0 then
logLine("DUNGEON", "open portal selector with " .. key)
safe("DUNGEON", function() Rank.materialEvent:FireServer("Use", {Item = key, Amount = 1}) end)
else
logLine("SPEND", "auto create portal stop: no " .. key)
showNotification("Dungeon", L("กุญแจหมด: ", "Out of keys: ") .. key, 5)
config.autoCreateDungeon = false
UI.mirror("autoCreateDungeon", false)
end
end
if portalEvent and config.autoStartDungeon and now - (state.lastEarlyStart or 0) >= 5 then
state.lastEarlyStart = now
local room = Rank.hostedPortal()
if room then

local starting = room:FindFirstChild("Starting")
local wave = room:FindFirstChild("Wave")
local replay = not (wave and wave.Value <= 1)
if not (starting and starting.Value) then
local gui = player.PlayerGui:FindFirstChild("PortalGui")
local canvas = gui and gui:FindFirstChild("StartCanvas")
if canvas and canvas.Visible and (not replay or player:GetAttribute("Auto_Replay_Portals") == true) then
local portalValue = room:FindFirstChild("Portal")
logLine(replay and "SPEND" or "DUNGEON", "dungeon Start " .. tostring(portalValue and portalValue.Value) .. (replay and " (replay)" or ""))
safe("DUNGEON", function() portalEvent:FireServer("Start") end)
end
end
elseif IN_SEA then

local gameFolder = ReplicatedStorage:FindFirstChild("Game")
for _, mode in ipairs(gameFolder and gameFolder:GetChildren() or {}) do
local host, starting = mode:FindFirstChild("Host"), mode:FindFirstChild("Starting")
if mode.Name ~= "Portal" and host and host.Value == player.Name and not (starting and starting.Value) then
local gui = player.PlayerGui:FindFirstChild(mode.Name .. "Gui")
local canvas = gui and gui:FindFirstChild("StartCanvas")
local remote = getRE(mode.Name .. "RE")
if canvas and canvas.Visible and remote then
logLine("DUNGEON", "dungeon Start " .. mode.Name)
safe("DUNGEON", function() remote:FireServer("Start") end)
end
break
end
end
elseif state.portalHostedAt and now - state.portalHostedAt < 60 then

safe("DUNGEON", function() portalEvent:FireServer("EarlyStart") end)
end
end

if portalEvent and config.autoLeaveDungeon and not config.autoRank and now - (state.lastDungeonLeave or 0) >= 10 then
local room = Rank.hostedPortal()
local starting = room and room:FindFirstChild("Starting")
local wave = room and room:FindFirstChild("Wave")
local left = room and room:FindFirstChild("EnemiesLeft")
local gui = room and player.PlayerGui:FindFirstChild("PortalGui")
local leaveCanvas = gui and gui:FindFirstChild("LeaveCanvas")
local finished = room and not (starting and starting.Value) and wave and wave.Value > 1
and not (left and left.Value > 0) and leaveCanvas and leaveCanvas.Visible
if finished and not (config.autoStartDungeon and player:GetAttribute("Auto_Replay_Portals") == true) then
state.dungeonDoneAt = state.dungeonDoneAt or now
if now - state.dungeonDoneAt >= 4 then
state.lastDungeonLeave = now
state.dungeonDoneAt = nil
logLine("DUNGEON", "run finished -> Leave")
safe("DUNGEON", function() portalEvent:FireServer("Leave") end)
end
else
state.dungeonDoneAt = nil
end
end

if IN_SEA and config.autoLeaveDungeon and not config.autoRank and now - (state.lastStoryLeave or 0) >= 10
and not (config.autoStartDungeon and player:GetAttribute("Auto_Replay_Portals") == true) then
local gameFolder = ReplicatedStorage:FindFirstChild("Game")
for _, mode in ipairs(gameFolder and gameFolder:GetChildren() or {}) do
local host, starting = mode:FindFirstChild("Host"), mode:FindFirstChild("Starting")
local gui = mode.Name ~= "Portal" and host and host.Value == player.Name and player.PlayerGui:FindFirstChild(mode.Name .. "Gui")
local leaveCanvas = gui and gui.Enabled and gui:FindFirstChild("LeaveCanvas")
local replayCanvas = gui and gui:FindFirstChild("ReplayCanvas")
if leaveCanvas and leaveCanvas.Visible and not (replayCanvas and not replayCanvas.Visible) and not (starting and starting.Value) then
state.lastStoryLeave = now
local remote = getRE(mode.Name .. "RE")
logLine("DUNGEON", "story run over (" .. mode.Name .. ") -> Leave")
if remote then safe("DUNGEON", function() remote:FireServer("Leave") end) end
break
end
end
end
if towerRemote and config.autoStartTower and not IN_SEA and now - state.lastTower >= 30 and state.inventoryInit then
state.lastTower = now
local coins = tonumber(state.currency.Coins) or 0
if coins < TOWER_COST then
tellPlayer("tower:coins", string.format(L("เริ่มหอคอยไม่ได้: ต้องใช้ %s Coins (มี %s)", "Can't start the tower: needs %s Coins (have %s)"), TOWER_COST, coins))
else
logLine("SPEND", string.format("tower Play | Coins=%s", coins))
state.lastInventorySync = 0
safe("TOWER", function() towerRemote:FireServer("Play") end)
end
end

local towerGui = IN_SEA and towerRemote and config.autoStartTower and player.PlayerGui:FindFirstChild("TowerGui")
if towerGui and towerGui.Enabled and now - (state.lastTowerStart or 0) >= 3 then
local startCanvas, replayCanvas = towerGui:FindFirstChild("StartCanvas"), towerGui:FindFirstChild("ReplayCanvas")
if startCanvas and startCanvas.Visible then
state.lastTowerStart = now
logLine("TOWER", "Start")
safe("TOWER", function() towerRemote:FireServer("Start") end)
elseif replayCanvas and replayCanvas.Visible and not config.autoLeaveTower and now - (state.lastTowerStart or 0) >= 6 then
state.lastTowerStart = now
local coins = tonumber(state.currency.Coins) or 0
if coins < TOWER_COST then
tellPlayer("tower:coins", string.format(L("เล่นหอคอยซ้ำไม่ได้: ต้องใช้ %s Coins (มี %s)", "Can't replay the tower: needs %s Coins (have %s)"), TOWER_COST, coins))
else
logLine("SPEND", string.format("tower Replay | Coins=%s", coins))
state.lastInventorySync = 0
safe("TOWER", function() towerRemote:FireServer("Replay") end)
end
end
end

local towerEndGui = IN_SEA and towerRemote and config.autoLeaveTower and player.PlayerGui:FindFirstChild("TowerGui")
local towerReplay = towerEndGui and towerEndGui.Enabled and towerEndGui:FindFirstChild("ReplayCanvas")
if towerReplay and towerReplay.Visible and now - (state.lastTowerLeave or 0) >= 10 then
state.lastTowerLeave = now
logLine("TOWER", "run ended -> Leave")
safe("TOWER", function() towerRemote:FireServer("Leave") end)
end
if seaRemote and config.autoPlaySea and not IN_SEA and now - state.lastSea >= 15 then
state.lastSea = now
local tier = math.clamp(tonumber(config.selectSeaTier) or 1, 1, 5)
logLine("SEA", "Play tier " .. tier)
safe("SEA", function() seaRemote:FireServer("Play", {HardTier = tier}) end)
end
if config.discordNotifyLevel and (now - (state.lastLevelCheck or 0) >= 3) then
state.lastLevelCheck = now
local myLvl = getPlayerLevel()
if not state.lastNotifiedLevel then
state.lastNotifiedLevel = myLvl
elseif myLvl > state.lastNotifiedLevel then
if (myLvl - state.lastNotifiedLevel >= 50) or (math.floor(myLvl / 100) > math.floor(state.lastNotifiedLevel / 100)) then
local prevLvl = state.lastNotifiedLevel
state.lastNotifiedLevel = myLvl
sendDiscordWebhook("⭐ เลเวลอัป! (Level Up Milestone)",
string.format("ผู้เล่น **%s** เลเวลอัปเป็น **Lv. %d** (เพิ่มขึ้นจาก Lv. %d)", player.Name, myLvl, prevLvl),
16776960,
{
{name = "👤 ผู้เล่น", value = player.Name, inline = true},
{name = "📈 เลเวลใหม่", value = "Lv. " .. tostring(myLvl), inline = true}
}
)
end
end
end
local needInventory = config.autoFarmSpecificItem or config.autoNarutoQuest or config.autoSummonForItems
or config.autoSummonBoss or config.autoCreateDungeon or config.autoGoal
or (config.discordNotifyDrop and config.discordWebhookUrl ~= "")
if sellerRF and not state.invSyncing and (now - (state.lastInventorySync or 0) >= (needInventory and 4 or 30)) then
state.lastInventorySync = now
state.invSyncing = true
task.spawn(function()
safe("INVENTORY", function()
local currency, profile, mats = sellerRF:InvokeServer("Request")
if type(currency) == "table" then state.currency = currency end
if type(profile) == "table" then state.profile = profile end
if type(mats) == "table" then
if config.discordNotifyDrop and state.inventoryInit then
for item, count in pairs(mats) do
local prev = state.inventory[item] or 0
if count > prev then
local gained = count - prev
sendDiscordWebhook("📦 ได้รับไอเทมดรอป! (Item Dropped)",
string.format("ผู้เล่น **%s** ได้รับ **%s** +%d ชิ้น (ในกระเป๋ามี: %d)", player.Name, item, gained, count),
5763719,
{
{name = "👤 ผู้เล่น", value = player.Name, inline = true},
{name = "🎁 ไอเทม", value = item, inline = true},
{name = "📊 จำนวน", value = "+" .. tostring(gained) .. " (รวม " .. tostring(count) .. ")", inline = true}
}
)
end
end
end
state.inventory = mats
state.inventoryInit = true
end
end)
state.invSyncing = false
end)
end
local isFarming = config.autoPvP or config.autoFarm or config.autoFarmNoQuest or config.autoFarmWorldBoss or config.autoFarmPityBoss
or config.autoFarmSummonedBoss or config.autoKillAllDungeon or config.autoKillAllTower
or config.autoKillMobsSea or config.autoClearYhwachPillars
or config.autoFarmSpecificItem or config.autoNarutoQuest or config.autoRank or config.autoGoal
if not isFarming then state.statusTarget = nil state.itemFarmNeed = nil return end
if config.autoGoal and now < (state.orbPauseUntil or 0) then
state.farmTarget = nil
state.statusTarget = nil
return
end
if config.autoNarutoQuest and (player:GetAttribute("QuestlineId") == 191 or player:GetAttribute("QuestlineId") == 193) then
state.statusTarget = nil
return
end
if state.collectingChests or state.questlineBusy or state.questBusy or state.seaBusy then return end
local tool = getActiveTool()

if config.autoGoal and state.goalTool and not IN_SEA then
local wanted = Goal.equip(state.goalTool, char, hum)
if wanted then
Goal.equipMissSince = nil
tool = wanted
else
Goal.equipMissSince = Goal.equipMissSince or now
if now - Goal.equipMissSince < 30 then return end
tellPlayer("goal:equip:" .. state.goalTool, string.format(L("หยิบ %s มาใส่มือไม่ได้ · ตีด้วยของที่ถืออยู่", "Could not equip %s · attacking with what you hold"), state.goalTool))
end
end
if config.autoNarutoQuest and player:GetAttribute("QuestlineId") == 190 then
local backpack = player:FindFirstChild("Backpack")
local combat = char:FindFirstChild("Combat") or (backpack and backpack:FindFirstChild("Combat"))
if combat and combat:IsA("Tool") then
if combat.Parent ~= char then pcall(function() hum:EquipTool(combat) end) end
tool = combat
else
tellPlayer("naruto:combat", L("ใส่หมัด Combat จาก Storage ก่อน เพื่อทำดาเมจ 3 ล้าน", "Equip Combat from Storage for the 3M damage quest"))
return
end
end
if now - (state.lastTargetScan or 0) >= 0.25 then
state.lastTargetScan = now
state.farmTarget = selectFarmTarget(now, char)
local name = state.farmTarget and state.farmTarget.Name or nil
if name ~= state.loggedTargetName then
state.loggedTargetName = name
logLine("FARM", string.format("target %s | mode=%s move=%s", tostring(name), tostring(state.itemFarmNeed or config.selectedMonster), tostring(config.farmMovement)))
end
end
local targetMob = state.farmTarget
local orbJob = config.autoGoal and Goal.job and Goal.job.kind == "item"
and Goal.job.mat and Goal.job.mat.item == "Cursed Orb"

local hpFrac = hum.Health / math.max(1, hum.MaxHealth)
local retreat = state.retreat
if not retreat and config.autoRetreat and hpFrac < 0.35 and targetMob and targetMob.Parent then
local mobPart = targetMob:FindFirstChild("HumanoidRootPart") or targetMob.PrimaryPart
local away = state.safeSpot
if not away or not mobPart or (away.Position - mobPart.Position).Magnitude < 300 then
away = CFrame.new(root.Position + Vector3.new(0, 400, 0))
end
retreat = {cf = away, at = now}
state.retreat = retreat
state.avoidTargets[targetMob] = now + 180
state.farmTarget = nil
logLine("FARM", string.format("low hp %.0f%% on %s -> retreat", hpFrac * 100, targetMob.Name))
tellPlayer("farm:retreat", L("เลือดต่ำ · ถอยไปพักจนเลือดฟื้นแล้วค่อยตีต่อ", "Low HP · backing off until health recovers"))
if targetMob.Name == state.levelQuest then Farm.dropTier("retreat") end
end
if retreat then
if hpFrac >= 0.8 or now - retreat.at > 120 then
state.retreat = nil
logLine("FARM", string.format("hp %.0f%% -> back to farming", hpFrac * 100))
else
state.statusTarget = nil
if orbJob then
if (root.Position - retreat.cf.Position).Magnitude > 8
and now - (state.lastOrbWarp or -math.huge) >= 15 then
state.lastOrbWarp = now
moveTo(retreat.cf, nil, "Teleport")
end
elseif (root.Position - retreat.cf.Position).Magnitude > 5 then
moveTo(retreat.cf, nil, "Teleport")
else
root.CFrame = retreat.cf
root.AssemblyLinearVelocity = Vector3.zero
end
return
end
end
state.statusTarget = targetMob and targetMob.Parent and targetMob.Name or nil
if not targetMob then return end
local mobRoot = targetMob:FindFirstChild("HumanoidRootPart") or targetMob:FindFirstChild("Torso") or targetMob.PrimaryPart
local mobHum = targetMob:FindFirstChildOfClass("Humanoid")
if not mobRoot or not mobHum or mobHum.Health <= 0 then return end
if not config.autoPvP and config.discordNotifyBoss and (config.autoFarmWorldBoss or config.autoFarmSummonedBoss or config.autoFarmPityBoss)
and table.find(BOSSES, targetMob.Name) and targetMob ~= state.trackingBossModel then
state.trackingBossModel = targetMob
local bName = targetMob.Name
mobHum.Died:Once(function()
if not state.alive then return end
sendDiscordWebhook("👑 สังหารบอสสำเร็จ! (Boss Defeated)",
string.format("ผู้เล่น **%s** กำราบ **%s** สำเร็จแล้ว!", player.Name, bName),
10181046,
{
{name = "👤 ผู้เล่น", value = player.Name, inline = true},
{name = "💀 บอสที่สังหาร", value = bName, inline = true},
{name = "📈 เลเวลผู้เล่น", value = "Lv. " .. tostring(getPlayerLevel()), inline = true}
}
)
end)
end
if targetMob ~= state.stallTarget then
state.stallTarget, state.stallHp, state.stallSince, state.stallLogged = targetMob, mobHum.Health, now, false
elseif mobHum.Health < state.stallHp then
state.stallHp, state.stallSince, state.stallLogged = mobHum.Health, now, false
elseif not state.stallLogged and now - state.stallSince >= 20 then
state.stallLogged = true
local ping = 0
pcall(function() ping = player:GetNetworkPing() * 1000 end)
logLine("STALL", string.format("no damage 20s on %s hp=%.0f/%.0f dist=%.1f dy=%.1f ping=%.0fms tool=%s skill=%s",
targetMob.Name, mobHum.Health, mobHum.MaxHealth, (root.Position - mobRoot.Position).Magnitude, root.Position.Y - mobRoot.Position.Y,
ping, tool and tool.Name or "none", tostring(state.lastSkillUsed)))
end
local targetPos = mobRoot.Position
local desiredCF = config.autoPvP and pvpDestination(mobRoot)
or CFrame.new(targetPos + Vector3.new(0, config.farmHeight, 0), targetPos)
local dist = (root.Position - desiredCF.Position).Magnitude
if config.autoPvP then
if dist > 1.5 and now - state.lastPvPWarp >= 0.15 then
state.lastPvPWarp = now
moveTo(desiredCF, nil, "Teleport")
end
elseif orbJob then
local flatDistance = (Vector3.new(root.Position.X, 0, root.Position.Z)
- Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
local newTarget = state.orbWarpTarget ~= targetMob
if flatDistance > 10 and now - (state.lastOrbWarp or -math.huge) >= (newTarget and 2 or 10)
and (flatDistance <= 500 or now - (state.lastOrbLongWarp or -math.huge) >= 15) then
state.lastOrbWarp = now
if flatDistance > 500 then state.lastOrbLongWarp = now end
state.orbWarpTarget = targetMob
moveTo(CFrame.new(targetPos + Vector3.new(0, 3, 0), targetPos), nil, "Teleport")
end
if flatDistance > 18 then return end
elseif dist > 6 then
if needsTravel() then
if not state.farmTraveling then task.spawn(moveToFarm, desiredCF) end
else
moveTo(desiredCF)
end
else
root.CFrame = desiredCF
root.AssemblyLinearVelocity = Vector3.zero
end
if config.autoPvP and (char:GetAttribute("SafeZone") == true or targetMob:GetAttribute("SafeZone") == true
or (root.Position - mobRoot.Position).Magnitude > 8) then
return
end
local goalSkills = config.autoGoal and Goal.job and Goal.job.skills
if tool and (config.autoSkill or goalSkills) then
requestAutoSkill(tool, goalSkills)
end
if tool then
if tool.Parent ~= char then
pcall(function() hum:EquipTool(tool) end)
end
if now - state.lastAttack >= config.attackInterval then
state.lastAttack = now
if orbJob and state.orbRound and state.orbRound.targets[targetMob] then
state.orbRound.hit[string.lower(targetMob.Name)] = true
end
pcall(function() tool:Activate() end)
pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.zero) end)
if actionRemote then
pcall(function() actionRemote:FireServer("M1", tool.Name) end)
end
end
else
if now - state.lastAttack >= config.attackInterval then
state.lastAttack = now
if orbJob and state.orbRound and state.orbRound.targets[targetMob] then
state.orbRound.hit[string.lower(targetMob.Name)] = true
end
pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.zero) end)
if actionRemote then
pcall(function() actionRemote:FireServer("M1", "Combat") end)
end
end
end
end

local function watchDeaths(char)
local h = char and char:WaitForChild("Humanoid", 10)
if not h then return end
track(h.Died:Connect(function()
if not state.alive then return end
local now = os.clock()
local recent = {}
for _, t in ipairs(state.deathTimes) do
if now - t < 180 then recent[#recent + 1] = t end
end
recent[#recent + 1] = now
state.deathTimes = recent
state.retreat = nil
if state.statusTarget and state.statusTarget == state.levelQuest then Farm.dropTier("death") end
if #recent < 3 or not config.stopOnDeaths then return end
state.deathTimes = {}
local stopped = {}
for _, flag in ipairs(Rank.FARM_MODE_FLAGS) do
if config[flag] then
config[flag] = false
UI.mirror(flag, false)
stopped[#stopped + 1] = flag
end
end
if #stopped == 0 then return end
releaseAutoSummon("death loop")
logLine("DEATH", "3 deaths in 3 min -> stopped " .. table.concat(stopped, ","))
showNotification(HUB_NAME, L("ตาย 3 ครั้งใน 3 นาที · ปิดโหมดฟาร์มทั้งหมดแล้ว", "Died 3 times in 3 minutes · every farm mode is off"), 10)
UI.queueSave()
end))
end
if player.Character then task.spawn(watchDeaths, player.Character) end
track(player.CharacterAdded:Connect(watchDeaths))
heartbeatConn = track(RunService.RenderStepped:Connect(function()
if state.alive then safe("TICK", farmTick) end
end))
end
startFarmLoop()
local function startBackgroundLoops()
local function runLoop(tag, body)
task.spawn(function()
while state.alive do
local ok, waitFor = safe(tag, body)
task.wait(ok and tonumber(waitFor) or 2)
end
end)
end
local function withBusy(flag, tag, fn)
state[flag] = true
local ok = safe(tag, fn)
state[flag] = false
return ok
end
local function pressPrompt(prompt)
if type(fireproximityprompt) == "function" then
pcall(fireproximityprompt, prompt)
else
prompt:InputHoldBegin()
task.wait(prompt.HoldDuration + 0.1)
prompt:InputHoldEnd()
end
end
local function visibleBoulderTarget(folder)
for _, group in ipairs(folder:GetChildren()) do
local target = group:FindFirstChild("Target")
if target and target:IsA("BasePart") and target.CanTouch then
return group, target
end
end
return nil, nil
end
runLoop("RANK", function()
if not Rank.event then return 30 end
local now = os.clock()
if not config.autoRank then
state.rankTask = nil
if now - state.lastRankSync >= 30 then
state.lastRankSync = now
safe("RANK", function() Rank.event:FireServer("Update") end)
end
return 5
end
if now - state.lastRankSync >= 8 then
state.lastRankSync = now
safe("RANK", function() Rank.event:FireServer("Update") end)
end
local job = Rank.pickTask()
state.rankTask = job
if job.kind == "sync" then return 2 end
if job.kind == "max" then
config.autoRank = false
UI.mirror("autoRank", false)
showNotification("Rank", L("ถึง Rank สูงสุดแล้ว", "Already at the highest rank"), 5)
return 5
end
if job.kind == "blocked" then
tellPlayer("rank:blocked:" .. job.need.key, string.format(L("Rank %s: %s %d/%d ทำอัตโนมัติไม่ได้ · ฟาร์มมอนต่อระหว่างนี้", "Rank %s: %s %d/%d can't be automated · farming mobs meanwhile"),
job.rank, job.need.key, job.need.have, job.need.need))
end
local portalFolder = Rank.hostedPortal()
if portalFolder then
local starting = portalFolder:FindFirstChild("Starting")
if starting and starting.Value then
state.rankRunActive = true
return 2
end
if state.rankRunActive then
state.rankRunActive = false
state.rankRunEndAt = now
state.lastRankSync = 0
end

if (state.rankSyncedAt or 0) < (state.rankRunEndAt or 0) + 1 then return 1 end
local portalId = portalFolder:FindFirstChild("Portal") and portalFolder.Portal.Value
local roomKey = portalId and portalsData[portalId] and portalsData[portalId].Used
local mats = state.rank.Storage and state.rank.Storage.Material or {}
if job.kind == "portal" and roomKey and (tonumber(mats[roomKey]) or 0) > 0 then
local gui = player.PlayerGui:FindFirstChild("PortalGui")
local canvas = gui and gui:FindFirstChild("StartCanvas")
if canvas and canvas.Visible and now - state.lastRankPortal >= 6 then
state.lastRankPortal = now
state.lastRankSync = 0
logLine("SPEND", string.format("rank portal Start %s | %s=%s | ClearPortals %d/%d", tostring(portalId), roomKey, tostring(mats[roomKey]), job.need.have, job.need.need))
safe("RANK", function() portalEvent:FireServer("Start") end)
end
return 2
end
if now - state.lastRankPortal >= 10 then
state.lastRankPortal = now
logLine("RANK", "portal part done (" .. job.kind .. ") -> Leave")
safe("RANK", function() portalEvent:FireServer("Leave") end)
end
return 3
end
if IN_SEA then return 5 end
if job.kind == "rankup" then
if now - state.lastRankUp < 10 then return 2 end
state.lastRankUp = now
local npc = findMerchantTarget({path = {"NPC", "Rank", "RankNPC"}})
local part = npc and npc:FindFirstChild("HumanoidRootPart")
if part then moveTo(part.CFrame + part.CFrame.LookVector * 4, nil, "Teleport") end
logLine("RANK", "RankUp -> " .. tostring(job.rank))
safe("RANK", function() Rank.event:FireServer("RankUp") end)
state.lastRankSync = now - 6
return 3
end
local summoner = job.kind == "item" and Rank.SUMMONERS[job.info.mob]

if summoner and now - state.lastRankSummon >= 30 and state.rankSyncedAt > state.lastRankSummon and not findBossTarget(job.info.mob) then
local have, cost, npc = Rank.summonerFill(summoner)
local remote = getRE(summoner.remote)
local part = npc and (npc:FindFirstChild("Torso") or npc:FindFirstChild("HumanoidRootPart"))
if have and cost and have < cost and remote and part then
local missing = cost - have
local spare = Rank.spareOrbs(summoner.orb)
if spare >= missing then
state.lastRankSummon = now
state.lastRankSync = now - 6
logLine("SPEND", string.format("rank summon %s: %d %s (%d/%d, spare %d)", job.info.mob, missing, summoner.orb, have, cost, spare))
withBusy("questlineBusy", "RANK_SUMMON", function()
if moveTo(part.CFrame + part.CFrame.LookVector * 4, nil, "Teleport") then
task.wait(0.5)
remote:FireServer(summoner.action, {Amount = missing})
task.wait(0.5)
end
end)
else
tellPlayer("rank:orbs:" .. summoner.orb, string.format(L("%s ไม่พอให้อัญเชิญ %s (เหลือใช้ได้ %d · ต้องเก็บไว้ทำ Rank) · รอบอสเกิดเอง", "Not enough %s to summon %s (%d spare · the rest is kept for the rank) · waiting for a natural spawn"),
summoner.orb, job.info.mob, math.max(spare, 0)))
end
end
end
if job.kind == "portal" and portalEvent and Rank.materialEvent then
local wantType = portalsData[job.portal].Type
if state.portalSelector and (state.portalSelector == true or state.portalSelector == wantType) then
if now - state.lastRankPortal >= 30 then
state.lastRankPortal = now
state.portalSelector = nil
logLine("SPEND", string.format("rank portal Select %s Easy | %s=%s", job.portal, job.key, tostring(state.rank.Storage.Material[job.key])))
safe("RANK", function() portalEvent:FireServer("Select", {Difficulty = "Easy", Portal = job.portal, FriendOnly = false}) end)
task.delay(2, function() safe("RANK", function() portalEvent:FireServer("EarlyStart") end) end)
end
elseif now - state.lastRankKeyUse >= 15 and now - state.lastRankPortal >= 30 then
state.lastRankKeyUse = now
logLine("RANK", "open portal selector with " .. job.key)
safe("RANK", function() Rank.materialEvent:FireServer("Use", {Item = job.key, Amount = 1}) end)
end
return 2
end
return 3
end)

if questlineRemote then
track(questlineRemote.OnClientEvent:Connect(function(action, payload)
if action ~= "ConfirmReq" or not config.autoGoal or type(payload) ~= "table" or not Goal.starting then return end
if (payload.Id == Goal.starting or Goal.head(payload.Id) == Goal.starting) and os.clock() - Goal.lastStart < 20 then
logLine("SPEND", "goal questline entry cost -> Confirm " .. tostring(payload.Id) .. " | " .. costText(nil))
safe("GOAL", function() questlineRemote:FireServer("Confirm", {Id = payload.Id}) end)
end
end))
end
local function goalStop(reason, text)
logLine("GOAL", "stop: " .. reason)
if text then showNotification(HUB_NAME, text, 8) end
config.autoGoal = false
UI.mirror("autoGoal", false)
Goal.job, Goal.status, Goal.chaser = nil, nil, nil
Goal.applyModes(nil)
releaseAutoSummon("goal " .. reason)
UI.queueSave()
end
runLoop("GOAL", function()
if not config.autoGoal then
if Goal.job or Goal.status then
Goal.job, Goal.status = nil, nil
Goal.applyModes(nil)
end
return 3
end
local orbPause = (state.orbPauseUntil or 0) - os.clock()
if orbPause > 0 then return math.min(orbPause, 1) end

if IN_SEA then return 3 end
if not state.inventoryInit or not state.profile.Race then
Goal.status = { L("กำลังอ่านกระเป๋า...", "Reading inventory..."), "wait" }
return 2
end
local key = config.goalTarget
local s = Goal.sellers[key]
local job = Goal.doneKey == key and {kind = "done", text = L("ซื้อแล้ว", "Bought")} or Goal.analyze(key, 0)

for _ = 1, 3 do
local fallback = Goal.summonFallback(job)
if fallback == job then break end
job = fallback
end

local function jobId(j)
if not j then return nil end
local what = j.head or j.target or j.key or (j.mat and j.mat.item) or j.item or j.portal or j.group
return j.kind .. "|" .. tostring(what or ((j.kind == "money" or j.kind == "level") and "" or j.text))
end
local was = jobId(Goal.job)
Goal.job = job
if was ~= jobId(job) then logLine("GOAL", job.kind .. " | " .. tostring(job.text)) end
Goal.applyModes(job)
Goal.status = { job.text or job.kind, job.kind == "blocked" and "bad" or "run" }
if job.kind == "done" then
local name = s and s.Sell and s.Sell.Name or tostring(key)
if config.discordNotifyDrop then
sendDiscordWebhook("🎯 " .. name, string.format(L("**%s** ได้ %s แล้ว", "**%s** got %s"), player.Name, name), 5763719, {})
end
goalStop("done " .. name, string.format(L("ได้ %s แล้ว · ปิดทำเป้าหมาย", "Got %s · goal finished"), name))
return 3
end
if job.kind == "blocked" then
tellPlayer("goal:" .. tostring(job.text), job.text)
return 5
end
if job.kind == "qstart" then
if os.clock() - Goal.lastStart < 20 then return 2 end
Goal.lastStart = os.clock()
local npc = Goal.questlineNpc(job.head)
local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
local prompt = npc and npc:FindFirstChildWhichIsA("ProximityPrompt", true)
if not part or not prompt then
tellPlayer("goal:npc:" .. job.head, string.format(L("หา NPC ของเควสต์ %d ไม่เจอ (อาจอยู่ไกลเกินโหลด) · ลองวาร์ปไปเกาะใกล้ ๆ", "Can't find the NPC for quest %d (maybe not loaded) · try teleporting near it"), job.head))
return 5
end
withBusy("questlineBusy", "GOAL_QUEST", function()
state.token = state.token + 1
if moveTo(part.CFrame + part.CFrame.LookVector * 4, state.token, "Teleport") then
task.wait(0.5)
Goal.starting = job.head
pressPrompt(prompt)
task.wait(2)
logLine("GOAL", string.format("talked to %s for quest %d -> active=%s", npc.Name, job.head, tostring(player:GetAttribute("QuestlineId"))))
end
end)
return 2
end

if job.kind == "chaser" then
Goal.chaserSeen = Goal.chaserSeen or {}
local progress = tonumber(player:GetAttribute("QuestlineProgress")) or 0
local maxProgress = tostring(player:GetAttribute("QuestlineMaxProgress"))
local fight = Goal.chaser
if fight then
if progress > fight.progress then
logLine("GOAL", string.format("flame chaser %s done -> %d/%s", fight.npc.Name, progress, maxProgress))
Goal.chaser, Goal.chaserRound = nil, nil
return 1
end
if findTargetMob(fight.mob) then
fight.mobSeenAt = os.clock()
Goal.status = { string.format(L("ตี %s · Flame Chaser %d/%s", "Fighting %s · Flame Chaser %d/%s"), fight.mob, progress, maxProgress), "run" }
return 2
end

if os.clock() - (fight.mobSeenAt or fight.talkedAt) < 25 then return 2 end
logLine("GOAL", "flame chaser " .. fight.npc.Name .. " -> no mobs, no progress")
Goal.chaser = nil
return 1
end
local root = workspace:FindFirstChild("NPC")
local folder = root and root:FindFirstChild("ChaserNPC")
local _, _, me = getCharParts()
if not folder or not me then
tellPlayer("goal:chaser", L("หา Flame Chaser ไม่เจอบนแมพนี้", "No Flame Chasers on this map"))
return 5
end

for n = 1, #folder:GetChildren() do
if findTargetMob("Chaser" .. n .. "Mob") then
Goal.chaser = {npc = folder:FindFirstChild(n .. "ChaserNPC") or {Name = n .. "ChaserNPC"}, mob = "Chaser" .. n .. "Mob", talkedAt = os.clock(), progress = progress}
return 1
end
end
local best, bestPrompt, bestPos, bestDist = nil, nil, nil, math.huge
for _, m in ipairs(folder:GetChildren()) do
if m:IsA("Model") and os.clock() - (Goal.chaserSeen[m] or -math.huge) > 45 then
local prompt = m:FindFirstChildWhichIsA("ProximityPrompt", true)
local part = prompt and promptBasePart(prompt)

if not prompt or prompt.Enabled then
local pos = part and part.Position or m:GetPivot().Position
local d = (pos - me.Position).Magnitude
if d < bestDist then best, bestPrompt, bestPos, bestDist = m, prompt, pos, d end
end
end
end
if not best then
Goal.chaserSeen = {}
return 5
end

if not Goal.chaserRound or progress > Goal.chaserRound.progress then Goal.chaserRound = {progress = progress, talks = 0} end
if Goal.chaserRound.talks >= #folder:GetChildren() then
Goal.chaserRound = nil
goalStop("flame chaser not counting", L("คุยกับ Flame Chaser ครบรอบแล้วเควสต์ไม่ขึ้น · หยุดทำเป้าหมายไว้ก่อน ลองคุยเองสักตัว", "Talked to every Flame Chaser and the quest did not move · goal stopped; try talking to one yourself"))
return 5
end

local wait = 15 - (os.clock() - (state.lastInstantWarp or -math.huge))
if bestDist > INSTANT_RANGE and wait > 0 then
Goal.status = { string.format(L("รอ %d วิ ก่อนวาร์ปไป Flame Chaser ตัวถัดไป (%s/%s)", "Waiting %d s before warping to the next Flame Chaser (%s/%s)"),
math.ceil(wait), tostring(progress), tostring(player:GetAttribute("QuestlineMaxProgress"))), "wait" }
return math.min(wait, 3)
end
withBusy("questlineBusy", "GOAL_CHASER", function()
state.token = state.token + 1
if bestDist > INSTANT_RANGE then state.lastInstantWarp = os.clock() end
if moveTo(CFrame.new(bestPos + Vector3.new(0, 3, 0)), state.token, "Teleport") then

task.wait(1.5)
local prompt = bestPrompt or best:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt and prompt.Enabled then
local mob = "Chaser" .. tostring(best.Name:match("^(%d+)") or "") .. "Mob"
pressPrompt(prompt)
task.wait(1.5)
if not findTargetMob(mob) and prompt.Parent and prompt.Enabled then

prompt:InputHoldBegin()
task.wait(prompt.HoldDuration + 0.25)
prompt:InputHoldEnd()
task.wait(1.5)
end
Goal.chaserRound.talks = Goal.chaserRound.talks + 1
Goal.chaser = {npc = best, mob = mob, talkedAt = os.clock(), progress = progress}
logLine("GOAL", string.format("flame chaser %s talked -> %s %s", best.Name, mob, findTargetMob(mob) and "spawned" or "not seen"))
end
end
end)
Goal.chaserSeen[best] = os.clock()
return 1
end
if job.kind == "merchant" then
if os.clock() - (Goal.lastMerchant or -math.huge) < 15 then return 2 end
Goal.lastMerchant = os.clock()
local root = workspace:FindFirstChild("NPC")
local npc = root and root:FindFirstChild("Merchant") and root.Merchant:FindFirstChild("MerchantNPC")
local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
if not part or not Goal.merchantEvent then
tellPlayer("goal:merchant", L("หาพ่อค้าพเนจรไม่เจอ", "Can't find the travelling merchant"))
return 5
end
local before = tonumber(state.inventory[job.item]) or 0
withBusy("questlineBusy", "GOAL_MERCHANT", function()
state.token = state.token + 1
if moveTo(part.CFrame + part.CFrame.LookVector * 4, state.token, "Teleport") then
task.wait(0.5)
logLine("SPEND", string.format("merchant buy %s x%d for %s | %s %s=%d", job.item, job.amount, tostring(job.via), costText(nil), job.item, before))
Goal.merchantEvent:FireServer("Buy", {Item = job.item, Amount = job.amount})
task.wait(1)
end
end)
state.lastInventorySync = 0
task.wait(3)
local after = tonumber(state.inventory[job.item]) or 0
logLine("GOAL", string.format("merchant %s %d -> %d", job.item, before, after))
if after <= before then

Goal.merchant.window = nil
end
return 2
end
if job.kind == "buy" and job.key == key and config.goalNoBuy then
local name = s and s.Sell and s.Sell.Name or tostring(key)
goalStop("ready " .. name, string.format(L("ของครบแล้ว · ไปซื้อ %s ที่ NPC ได้เลย", "Everything is ready · buy %s at its NPC"), name))
return 3
end
if job.kind == "buy" then
local target = Goal.sellers[job.key]
if not target then return 5 end
if job.race and not Goal.raceOk[job.key] then
if not Goal.raceAsked[job.key] then
Goal.raceAsked[job.key] = true
UI.confirm(L("เปลี่ยนเผ่า?", "Change race?"), string.format(L("ซื้อเผ่า %s แทนเผ่า %s ที่ใช้อยู่ · เผ่าเดิมจะหายไป", "Buy race %s instead of your current %s · the old race is gone"),
target.Sell.Name, tostring(state.profile.Race)), function()
Goal.raceOk[job.key] = true
end, function()
goalStop("race declined", L("ไม่เปลี่ยนเผ่า · หยุดทำเป้าหมาย", "Race change declined · goal stopped"))
end)
end
Goal.status = { L("รอคุณกดยืนยันการเปลี่ยนเผ่า", "Waiting for you to confirm the race change"), "wait" }
return 2
end
if os.clock() - Goal.lastBuy < 12 then return 2 end
Goal.lastBuy = os.clock()
local npc = Goal.sellerNpc(job.key)
local part = npc and (npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true))
if not part or not sellerEvent then
tellPlayer("goal:seller:" .. job.key, string.format(L("หาร้าน %s ไม่เจอ", "Can't find the %s seller"), target.Sell.Name))
return 5
end
local req = type(target.Req) == "table" and target.Req or {}
local firstMat = nil
for item in pairs(type(req.Materials) == "table" and req.Materials or {}) do firstMat = firstMat or item end
local before = { tonumber(state.currency.Coins) or 0, tonumber(state.currency.Gems) or 0, firstMat and (tonumber(state.inventory[firstMat]) or 0) or 0 }
withBusy("questlineBusy", "GOAL_BUY", function()
state.token = state.token + 1
if moveTo(part.CFrame + part.CFrame.LookVector * 4, state.token, "Teleport") then
task.wait(0.5)
logLine("SPEND", string.format("goal buy %s (%s %s) | %s", job.key, tostring(target.Sell.Type), tostring(target.Sell.Name), costText(nil)))
sellerEvent:FireServer("Buy", {Name = job.key, Amount = 1})
task.wait(1)
end
end)
state.lastInventorySync = 0
task.wait(3.5)
local coins, gems = tonumber(state.currency.Coins) or 0, tonumber(state.currency.Gems) or 0
local bought = Goal.has(target.Sell)
or (req.Coins and coins <= before[1] - req.Coins * 0.9) or (req.Gems and gems <= before[2] - req.Gems * 0.9)
or (firstMat and (tonumber(state.inventory[firstMat]) or 0) < before[3])
logLine("GOAL", string.format("buy %s -> %s | %s", job.key, bought and "ok" or "no change", costText(nil)))
if bought then
Goal.buyFails[job.key] = 0

if job.key == key and not Goal.has(target.Sell) then Goal.doneKey = key end
else
Goal.buyFails[job.key] = (Goal.buyFails[job.key] or 0) + 1
if Goal.buyFails[job.key] >= 3 then
goalStop("buy failed " .. job.key, string.format(L("ซื้อ %s ไม่สำเร็จ 3 ครั้ง · หยุดทำเป้าหมาย (ดูเงื่อนไขในแผน)", "Buying %s failed 3 times · goal stopped (check the plan)"), target.Sell.Name))
end
end
return 2
end
return 2
end)
runLoop("NARUTO_QUEST", function()
if not config.autoNarutoQuest then return 3 end
if config.autoPvP or state.collectingChests or state.questlineBusy or state.questBusy or state.seaBusy then return 2 end
local questlineId = player:GetAttribute("QuestlineId")
if questlineId == 192 then
local now = os.clock()
local progress = player:GetAttribute("QuestlineProgress") or 0
if progress ~= state.narutoLastProgress then
state.narutoLastProgress = progress
state.narutoLastProgressAt = now
state.narutoNoMobSince = nil
end
local gameFolder = ReplicatedStorage:FindFirstChild("Game")
local cycle = gameFolder and gameFolder:FindFirstChild("Cycle")
if cycle and cycle.Value == "Night" and not findChakraFlowMob() then
state.narutoNoMobSince = state.narutoNoMobSince or now
if now - state.narutoNoMobSince >= 8 and now - state.narutoLastProgressAt >= 8
and not state.narutoHopPending and now - (state.lastHopAttempt or 0) >= 30 then
local autoloadOk = LOADER_URL ~= "" or (type(isfile) == "function" and type(readfile) == "function" and isfile(AUTOLOAD_FILE)
and readfile(AUTOLOAD_FILE):find('local VERSION = "' .. VERSION .. '"', 1, true) ~= nil)
if not (config.autoReexecute and queueTeleport and autoloadOk) then
tellPlayer("naruto:hop-setup", L("ย้ายห้องอัตโนมัติไม่ได้: ต้องเปิดโหลดสคริปต์ต่อและติดตั้ง autoload รุ่นล่าสุด", "Night hop needs auto re-execute and the current autoload file"))
return 10
end
if not saveNarutoHopResume() then
tellPlayer("naruto:hop-file", L("บันทึกสถานะย้ายห้องไม่สำเร็จ", "Could not save night hop state"))
return 10
end
state.lastHopAttempt = now
state.narutoHopPending = true
logLine("NARUTO", "night with no Chakra Flow mob for 8s -> server hop")
showNotification("Killer B", L("กลางคืนไม่พบมอน Chakra Flow · กำลังย้ายห้อง", "Night with no Chakra Flow NPC · hopping servers"), 4)
serverHop(state.narutoVisitedServers)
task.delay(30, function() state.narutoHopPending = false end)
return 5
end
else
state.narutoNoMobSince = nil
end
return 2
else
state.narutoNoMobSince = nil
state.narutoLastProgress = nil
end
if questlineId == 191 then
local folder = workspace:FindFirstChild("Questline") and workspace.Questline:FindFirstChild("Boulder")
if not folder then return 5 end
withBusy("questlineBusy", "NARUTO_BOULDER", function()
local char = player.Character
if not char then return end
local group, target = visibleBoulderTarget(folder)
if not target then
local prompt, part
for _, candidate in ipairs(folder:GetChildren()) do
local stone = candidate:FindFirstChild("Stone")
local hand = stone and stone:FindFirstChild("HAND")
local p = hand and hand:FindFirstChildOfClass("ProximityPrompt")
if p and p.Enabled and hand.Transparency < 1 then
prompt, part = p, hand
break
end
end
if not prompt or os.clock() - state.lastNarutoPickup < 3 then return end
state.lastNarutoPickup = os.clock()
state.token = state.token + 1
local token = state.token
if not moveTo(part.CFrame + Vector3.new(0, 3, 0), token, "Tween") or not config.autoNarutoQuest then return end
pressPrompt(prompt)
task.wait(0.8)
group, target = visibleBoulderTarget(folder)
if not target and char:GetAttribute("CarryBoulder") == nil and prompt.Enabled then
prompt:InputHoldBegin()
task.wait(prompt.HoldDuration + 0.1)
prompt:InputHoldEnd()
task.wait(0.8)
group, target = visibleBoulderTarget(folder)
end
if not target then
logLine("NARUTO", "boulder did not lift")
return
end
logLine("NARUTO", "lifted boulder " .. group.Name)
end
if not config.autoNarutoQuest or player:GetAttribute("QuestlineId") ~= 191 then return end
local before = player:GetAttribute("QuestlineProgress") or 0
state.token = state.token + 1
if moveTo(target.CFrame + Vector3.new(0, 2, 0), state.token, "Tween") then
task.wait(1.5)
local after = player:GetAttribute("QuestlineProgress") or 0
logLine("NARUTO", string.format("boulder %s progress %d -> %d", group.Name, before, after))
if after <= before then
tellPlayer("naruto:boulder", L("ถึงจุดส่งหินแล้วแต่เควสต์ยังไม่เพิ่ม · ลองเดินแตะวงสีเหลือง", "Reached the boulder marker but progress did not increase · walk through the yellow marker"))
end
end
end)
return 2
end
if questlineId == 193 then
local char = player.Character
if char and char:GetAttribute("Meditating") ~= nil then return 5 end
if os.clock() - state.lastNarutoMeditate < 10 then return 3 end
local carpet = workspace:FindFirstChild("Questline") and workspace.Questline:FindFirstChild("Carpet")
carpet = carpet and carpet:FindFirstChild("carpet")
if not carpet then return 5 end
for _, part in ipairs(carpet:GetChildren()) do
local prompt = part:IsA("BasePart") and part:FindFirstChildOfClass("ProximityPrompt")
if prompt and prompt.Enabled then
state.lastNarutoMeditate = os.clock()
withBusy("questlineBusy", "NARUTO_MEDITATE", function()
state.token = state.token + 1
if moveTo(part.CFrame + Vector3.new(0, 3, 0), state.token, "Tween") and config.autoNarutoQuest then
pressPrompt(prompt)
end
end)
break
end
end
return 5
end
if questlineId == nil and player:GetAttribute("Questline190") ~= true then
local coins = tonumber(state.currency.Coins) or 0
local gems = tonumber(state.currency.Gems) or 0
if coins < 7500000 or gems < 27500 then return 5 end
if not questlineRemote or os.clock() - state.lastNarutoStart < 30 then return 5 end
local npc = findMerchantTarget({path = {"NPC", "QuestlineAndSeller", "BeastTailNPC"}})
local part = npc and npc:FindFirstChild("HumanoidRootPart")
local prompt = npc and npc:FindFirstChildWhichIsA("ProximityPrompt", true)
if part then
state.lastNarutoStart = os.clock()
withBusy("questlineBusy", "NARUTO_START", function()
state.token = state.token + 1
if moveTo(part.CFrame + part.CFrame.LookVector * 4, state.token, "Tween") and config.autoNarutoQuest then
if prompt then pressPrompt(prompt) end
task.wait(0.4)
questlineRemote:FireServer("Confirm", {Id = 190})
logLine("NARUTO", "requested Killer B quest start")
end
end)
end
return 5
end
if player:GetAttribute("Questline193") == true then
config.autoNarutoQuest = false
UI.mirror("autoNarutoQuest", false)
UI.notify(L("เควสต์ Killer B ครบแล้ว · หา Darkness Fragment 2 ชิ้นเพื่อซื้อเผ่า", "Killer B quests complete · collect 2 Darkness Fragments for Jinchuriki"))
return 10
end
return 5
end)
local function newEnemyNear(before, pos, range)
local en = workspace:FindFirstChild("Enemies")
for _, d in ipairs(en and en:GetDescendants() or {}) do
if d:IsA("Model") and not before[d] then
local h = d:FindFirstChildOfClass("Humanoid")
local r = d:FindFirstChild("HumanoidRootPart")
if h and h.Health > 0 and r and (r.Position - pos).Magnitude <= range then return d end
end
end
return nil
end
runLoop("CHEST", function()
if not config.autoChests or config.autoPvP or state.collectingChests then return 1 end
local chestFolder = workspace:FindFirstChild("Chest") or workspace:FindFirstChild("Chests")
local _, hum, root = getCharParts()
if not (chestFolder and hum and hum.Health > 0 and root) then return 1 end
withBusy("collectingChests", "CHEST", function()
local tried = {}
while config.autoChests and not config.autoPvP and state.alive do
local _, h, r = getCharParts()
if not (h and h.Health > 0 and r) then break end
local prompt, part, best
for _, chest in ipairs(chestFolder:GetChildren()) do
local p = not tried[chest] and chest:FindFirstChildWhichIsA("ProximityPrompt", true)
local bp = p and p.Enabled and (p.Parent:IsA("BasePart") and p.Parent or chest:FindFirstChildWhichIsA("BasePart", true))
if bp then
local d = (bp.Position - r.Position).Magnitude
if not best or d < best then prompt, part, best = p, bp, d end
end
end
if not prompt then break end
tried[prompt:FindFirstAncestorOfClass("Model") or prompt] = true
state.token = state.token + 1
local arrived = moveTo(CFrame.new(part.Position + Vector3.new(0, 3, 0)), state.token)
if arrived and state.alive and config.autoChests and not config.autoPvP then
local before = {}
local en = workspace:FindFirstChild("Enemies")
for _, d in ipairs(en and en:GetDescendants() or {}) do before[d] = true end
task.wait(0.2)
pressPrompt(prompt)
local mimic
for _ = 1, 6 do
task.wait(0.5)
mimic = newEnemyNear(before, part.Position, 60)
if mimic then break end
end
if mimic then
state.chestMimics = (state.chestMimics or 0) + 1
logLine("CHEST", "mimic at chest -> skip (" .. mimic.Name .. ") #" .. state.chestMimics)
tellPlayer("chest:mimic", L("หีบนี้เป็นมอน (Mimic) · ข้ามไปใบถัดไป", "This chest was a Mimic · moving on"))
else
state.chestsOpened = (state.chestsOpened or 0) + 1
logLine("CHEST", string.format("opened #%d (%.0f studs away)", state.chestsOpened, best))
task.wait(math.max(7, tonumber(config.chestDelay) or 7) - 3)
end
end
end
end)
return 5
end)
runLoop("SEEDS", function()
if not config.autoSeeds or config.autoPvP or state.collectingChests or state.questlineBusy then return 2 end
local seedFolder = workspace:FindFirstChild("Seed")
local _, hum, root = getCharParts()
if not (seedFolder and hum and hum.Health > 0 and root) then return 2 end
local ready, best, bestPrompt, bestPart = 0, nil, nil, nil
for _, seed in ipairs(seedFolder:GetChildren()) do
local prompt = seed:FindFirstChildWhichIsA("ProximityPrompt", true)
local part = prompt and (prompt.Parent:IsA("BasePart") and prompt.Parent or promptBasePart(prompt))
if prompt and part and seed:GetAttribute("Ready") == true then
ready = ready + 1
if prompt.Enabled then
local d = (part.Position - root.Position).Magnitude
if not best or d < best then best, bestPrompt, bestPart = d, prompt, part end
end
end
end
if ready > 0 and not bestPrompt then
tellPlayer("seeds:locked", L("เก็บเมล็ดคริสตัลไม่ได้: เกมให้เก็บเฉพาะคนที่ทำเควสต์สายเมล็ดจบแล้ว", "Can't pick crystal seeds: the game only allows it after finishing their questline"))
return 10
end
if not bestPrompt then return 5 end
withBusy("collectingChests", "SEEDS", function()
state.token = state.token + 1
local arrived = moveTo(CFrame.new(bestPart.Position + Vector3.new(0, 3, 0)), state.token)
if arrived and config.autoSeeds and not config.autoPvP and bestPrompt.Parent and bestPrompt.Enabled then
task.wait(0.2)
pressPrompt(bestPrompt)
logLine("SEEDS", string.format("picked seed (%.0f studs away)", best))
task.wait(2)
end
end)
return 1
end)
runLoop("QUESTLINE", function()
local active = hasActiveQuestline()
local questline = active and not config.autoPvP and not state.collectingChests and workspace:FindFirstChild("Questline")
if questline then
for _, groupName in ipairs(QUESTLINE_GROUPS) do
if not state.alive or config.autoPvP or state.collectingChests then break end

local function wanted()
return (config.autoCollectQuestline and config.questlineAuto[groupName]) or (config.autoGoal and state.goalCollect == groupName)
end
local group = wanted() and not (config.autoNarutoQuest and groupName == "Boulder") and questline:FindFirstChild(groupName)
if group then
for _, prompt in ipairs(group:GetDescendants()) do
if not state.alive or config.autoPvP or not wanted() then break end
if prompt:IsA("ProximityPrompt") and prompt.Enabled and os.clock() - (questlineLastPrompt[prompt] or 0) >= 30 then
local part = promptBasePart(prompt)
if part then
withBusy("questlineBusy", "QUESTLINE", function()
state.token = state.token + 1
local arrived = moveTo(part.CFrame + Vector3.new(0, 3, 0), state.token)
if arrived and not config.autoPvP and prompt.Parent and prompt.Enabled and wanted() then
prompt:InputHoldBegin()
task.wait(prompt.HoldDuration + 0.15)
prompt:InputHoldEnd()
questlineLastPrompt[prompt] = os.clock()
task.wait(1.5)
if prompt.Parent and prompt.Enabled then
questlineLastPrompt[prompt] = os.clock() + 570
logLine("QUESTLINE", groupName .. " did not take -> skip 10 min")
tellPlayer("questline:" .. groupName, string.format(L("เก็บ %s ไม่ติด · อาจต้องรับเควสต์ของสายนี้ก่อน · ข้าม 10 นาที", "%s did not collect · you may need that questline first · skipping 10 min"), groupName))
else
state.questlineAttempts = state.questlineAttempts + 1
logLine("QUESTLINE", "collected " .. groupName .. " #" .. state.questlineAttempts)
end
end
end)
end
end
end
end
end
end
for prompt in pairs(questlineLastPrompt) do
if not prompt.Parent then questlineLastPrompt[prompt] = nil end
end
return active and 2 or 6
end)
do
local lastBannerPull, previousPity = 0, nil
runLoop("BANNER", function()
updatePityLabels()
if not (config.autoRollBanner and bannerEvent) then
previousPity = nil
return 5
end
local currentPity, tickets = pityInfo.bannerPity, pityInfo.tickets
if currentPity >= 80 or (previousPity and currentPity < previousPity) or tickets < 10 then
logLine("SPEND", string.format("auto roll stop | pity=%d tickets=%d", currentPity, tickets))
config.autoRollBanner = false
UI.mirror("autoRollBanner", false)
elseif os.clock() - lastBannerPull >= 8 then
previousPity = currentPity
logLine("SPEND", string.format("auto roll TenPull | pity=%d tickets=%d", currentPity, tickets))
bannerEvent:FireServer("TenPull", {Banner = "Miyabi"})
lastBannerPull = os.clock()
end
return 1.5
end)
end
do
local lastTool, lastSync = nil, 0
runLoop("SKILL", function()
local character = player.Character
local equipped = character and character:FindFirstChildOfClass("Tool")
if config.autoSkill and (equipped ~= lastTool or os.clock() - lastSync >= 3) then
syncNativeAutoSkills()
lastSync = os.clock()
end
lastTool = equipped
return config.autoSkill and 1 or 4
end)
end
do
local STAT_BARS = {Power = "PowerBar", Strength = "StrBar", Defense = "DefenseBar", Weapon = "WeaponBar"}
local statCap = 7000
pcall(function() statCap = require(ReplicatedStorage.Game.GAME_CONFIG).MaxStatsCap or statCap end)
local noProgress, pausedUntil = 0, 0
local function readStats()
local statsUp
pcall(function() statsUp = player.PlayerGui.ScreenGui.HUD.StatsFrame.Main.StatsUP end)
local pointsLabel = statsUp and statsUp:FindFirstChild("statspoingot")
if not pointsLabel then return nil end
local points = tonumber((pointsLabel.Text or ""):match("(%d+)%s*$"))
local values = {}
for stat, bar in pairs(STAT_BARS) do
local lbl = statsUp:FindFirstChild(bar) and statsUp[bar]:FindFirstChild("var")
values[stat] = lbl and tonumber(tostring(lbl.Text):match("%d+")) or nil
end
return points, values
end
runLoop("STATS", function()
if not (config.autoStats and statsRemote) or os.clock() < pausedUntil then return 5 end
local points, values = readStats()
if not points or points <= 0 then return 2 end
local eligible = {}
for stat, on in pairs(config.statTargets) do
if on and values[stat] and values[stat] < statCap then table.insert(eligible, stat) end
end
if #eligible == 0 then return 2 end
table.sort(eligible, function(a, b) return values[a] < values[b] end)
local stat = eligible[1]
local amount = math.min(points, statCap - values[stat], math.max(1, math.ceil(points / #eligible)))
statsRemote:FireServer(stat, amount)
task.wait(1)
local after = readStats()
if after and after < points then
noProgress = 0
logLine("STATS", string.format("+%d %s (%d -> %d) | แต้มเหลือ %d", amount, stat, values[stat], values[stat] + amount, after))
else
noProgress = noProgress + 1
logLine("STATS", string.format("ส่ง +%d %s แล้วแต้มไม่ลด (%s -> %s) ครั้งที่ %d", amount, stat, tostring(points), tostring(after), noProgress))
if noProgress >= 3 then
noProgress = 0
pausedUntil = os.clock() + 120
showNotification("Auto Stats", "พัก 2 นาที: เซิร์ฟเวอร์ไม่รับการลงแต้ม (ดู log)", 5)
end
end
return 2
end)
end
runLoop("SEA_DOOR", function()
if not (IN_SEA and config.autoStartSea) or config.autoPvP or state.seaBusy then return 2 end
local doors = workspace:FindFirstChild("Door")
if not doors or #doors:GetChildren() == 0 then return 2 end
local en = workspace:FindFirstChild("Enemies")
for _, d in ipairs(en and en:GetDescendants() or {}) do
local h = d:IsA("Model") and d:FindFirstChildOfClass("Humanoid")
if h and h.Health > 0 then return 2 end
end
local pick, pickPrompt
local want = tostring(config.seaDoor or "Combat")
for _, door in ipairs(doors:GetChildren()) do
local p = door:FindFirstChildWhichIsA("ProximityPrompt", true)
if p and p.Enabled and (not pick or door.Name == want) then pick, pickPrompt = door, p end
end
if not pickPrompt then return 2 end
local part = pickPrompt.Parent:IsA("BasePart") and pickPrompt.Parent or pick:FindFirstChildWhichIsA("BasePart", true)
withBusy("seaBusy", "SEA_DOOR", function()
state.token = state.token + 1
local arrived = moveTo(CFrame.new(part.Position + Vector3.new(0, 3, 0)), state.token)
if arrived and not config.autoPvP and pickPrompt.Parent and pickPrompt.Enabled then
logLine("SEA", "enter door " .. pick.Name .. (pick.Name ~= want and (" (wanted " .. want .. ")") or ""))
pressPrompt(pickPrompt)
task.wait(4)
end
end)
return 2
end)
runLoop("SUMMON", function()
if config.autoSummonBoss and not UI.configLoading then
setAutoSummon(config.selectedBoss, true, "boss page", config.bossDifficulty)
end
return 5
end)
end
startBackgroundLoops()
destroyHub = function()
if not state.alive then return end
if state.autoSummonOwned then pcall(setAutoSummon, nil, false, "hub closed") end
state.alive = false
cancelMotion()
if heartbeatConn then heartbeatConn:Disconnect() end
if state.deathLogConn then state.deathLogConn:Disconnect() end
pcall(function()
local _, hum = getCharParts()
if hum and state.speedOrig then hum.WalkSpeed = state.speedOrig end
end)
logLine("STOP", "Hub destroyed")
if espFolder then espFolder:Destroy() end
if config.hideVfx then pcall(restoreVisualSettings) end
if config.lowRamAudio then pcall(restoreLowRamAudio) end
if W then pcall(W.Unload, W) end
for i = #trash, 1, -1 do
local x = trash[i]
pcall(function()
if typeof(x) == "RBXScriptConnection" then x:Disconnect()
elseif typeof(x) == "Instance" then x:Destroy()
elseif type(x) == "function" then x() end
end)
end
table.clear(trash)
env.LineageHubInstance = nil
env.LineageAdvantage = nil
end
env.LineageHubInstance = { Destroy = destroyHub }
env.LineageAdvantage = { Destroy = destroyHub }
do
UI.applyingConfig = true
local ok, err = DukeGUI:LoadConfig(CONFIG_NAME)
UI.applyingConfig = false
logLine("CONFIG", ok and "loaded" or ("not loaded: " .. tostring(err)))
task.delay(2, function() UI.configLoading = false end)
end
local narutoHopResume = readNarutoHopResume()
if narutoHopResume then
task.spawn(function()
for _ = 1, 20 do
if not state.alive then return end
if player:GetAttribute("QuestlineId") == 192 then
state.narutoVisitedServers = type(narutoHopResume.visited) == "table" and narutoHopResume.visited or {}
clearNarutoHopResume()
UI.mirror("autoNarutoQuest", true)
logLine("NARUTO", "resumed Killer B quest after night hop")
return
end
task.wait(1)
end
clearNarutoHopResume()
logLine("NARUTO", "night hop resume skipped: quest is no longer Chakra Flow")
end)
end
setFlagFile(REEXEC_OFF_FILE, not config.autoReexecute)
pcall(function() local clear = clear_teleport_queue or cleartpqueue if clear then clear() end end)
queueReexecute("startup")
logLine("LOAD", "ready v" .. VERSION)
env.__LineageBooting = nil
