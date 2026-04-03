-- ==========================================
-- SCRIPT: LỮ TÀI HUB - VIP EDITION (RAW GITHUB)
-- TÍNH NĂNG: AUTO CHEST, ANTI-KICK, RESET 12S
-- ==========================================

-- 1. CHỨC NĂNG CHỐNG BỊ KÍCH (ANTI-IDLE)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. KHỞI TẠO MENU RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({
    Name = "LỮ TÀI CHEST HUB - VIP",
    LoadingTitle = "Antiban Loading...", -- ĐÃ CẬP NHẬT
    ConfigurationSaving = {Enabled = false}
})

local Main = Win:CreateTab("Chính", 4483362458)
_G.AutoChest = false

-- 3. TỰ ĐỘNG RESET MỖI 12 GIÂY (CHỈ CHẠY KHI BẬT NHẶT RƯƠNG)
task.spawn(function()
    while true do
        task.wait(12) -- ĐÃ CHỈNH THÀNH 12 GIÂY
        if _G.AutoChest then 
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char:BreakJoints() -- Hồi sinh nhân vật
                end
            end)
        end
    end
end)

-- 4. TÍNH NĂNG NHẶT RƯƠNG TỐC ĐỘ CAO
Main:CreateToggle({
    Name = "Bật/Tắt Nhặt Rương (SIÊU NHANH)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoChest = v
        if v then
            task.spawn(function()
                while _G.AutoChest do
                    pcall(function()
                        for _,v in pairs(game:GetDescendants()) do
                            if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Name:find("Chest") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                task.wait(0.1)
                                if not _G.AutoChest then break end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- 5. TÍNH NĂNG NHẢY SERVER
Main:CreateButton({
    Name = "Nhảy Server (Khi hết rương)",
    Callback = function()
        local Http = game:GetService("HttpService")
        local Tp = game:GetService("TeleportService")
        local S = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _,s in pairs(S.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                Tp:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
})

-- THÔNG BÁO KHI LOAD XONG
Rayfield:Notify({
    Title = "LỮ TÀI HUB",
    Content = "Xin Chào, Script Đã Sẵn Sàng.",
    Duration = 5
})
