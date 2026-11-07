-- TDS LIVE LOADER (auto-sync จาก Supabase; fallback ไฟล์ mirror บน GitHub)
local SUPA_HTTP = "https://ajcqqfrvumyxupufnesd.supabase.co/rest/v1/scripts?select=code,version&id=eq.main&limit=1"
local SUPA_FALLBACK_URL = "https://raw.githubusercontent.com/SightBob/tds-live-report/refs/heads/main/live_report.lua"
local KEY = "sb_publishable_k2UQNK0MJsJP0roEPFH0Qw_7wOe-VhG"
local HttpService = game:GetService("HttpService")

local function fetchBody(url, headers)
    local ok, res = pcall(function()
        return HttpService:RequestAsync({ Url = url, Method = "GET", Headers = headers })
    end)
    if ok and res and res.Success then return res.Body end
    local rf = http_request or request or (syn and syn.request)
    if rf then
        local ok2, res2 = pcall(rf, { Url = url, Method = "GET", Headers = headers })
        if ok2 and res2 then return res2.Body or res2.body end
    end
    -- ทางสุดท้าย
    local ok3, res3 = pcall(function() return game:HttpGet(url) end)
    if ok3 and res3 and #res3 > 0 then return res3 end
    return nil
end

local src, ver = nil, "?"
local body = fetchBody(SUPA_HTTP, { apikey = KEY, Authorization = "Bearer " .. KEY })
if body then
    local ok, rows = pcall(function() return HttpService:JSONDecode(body) end)
    if ok and typeof(rows) == "table" and rows[1] and rows[1].code and #rows[1].code > 100 then
        src = rows[1].code
        ver = tostring(rows[1].version or 1)
    end
end
if not src then
    src = fetchBody(SUPA_FALLBACK_URL, {})
    if src then ver = "gh-mirror" end
end

if not src or #src < 100 then
    warn("[TDS-LOADER] โหลดโค้ดไม่สำเร็จ (Supabase+GitHub ล้มเปล) — ลองใหม่ภายหลัง")
    return
end

local fn, err = loadstring(src, "tds-script-main-v" .. ver)
if not fn then
    warn("[TDS-LOADER] โค้ดพัง (syntax): " .. tostring(err))
    return
end
print("[TDS-LOADER] เริ่ม script main v" .. ver .. " (" .. #src .. " chars)")
fn()
