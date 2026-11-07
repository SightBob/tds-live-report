# TDS Live Report
ระบบรายงานสถานะการเล่น TDS เรียลไทม์จากหลายแอคเคานต์/หลายจอ

## ไฟล์
- `live_loader.lua` — ตัวที่กด Run ในทุกจอ (โหลด live_report.lua ล่าสุดจาก repo นี้)
- `live_report.lua` — ตัวหลัก (สถานะ, coin/gems, tower owned/missing, ส่งขึ้น Supabase + Discord)
- `dashboard/index.html` — เว็บ dashboard (deploy บน Vercel / เปิดจากเครื่องก็ได้)

## วิธีใช้
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/SightBob/tds-live-report/refs/heads/main/live_loader.lua"))()
```
