-- ==========================================
-- SCRIPT: LỮ TÀI HUB - VIP EDITION
-- TÍNH NĂNG: AUTO CHEST (SPEED), ANTI-KICK, AUTO RESET 30S
-- ==========================================

-- 1. CHỨC NĂNG CHỐNG BỊ KÍCH (ANTI-IDLE)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. TỰ ĐỘNG RESET (HỒI SINH) MỖI 30 GIÂY (FIX LỖI)
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char:BreakJoints() -- Phá hủy nhân vật để Reset
            end
        end)
    end
end)

-- 3. KHỞI TẠO MENU RAYFIELD (ĐÃ SỬA TÊN LỮ TÀI)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({
    Name = "LỮ TÀI HUB - VIP",
    LoadingTitle = "Chào Lữ Tài! Đang tải...",
    ConfigurationSaving = {Enabled = false}
})

-- Tự động chọn phe Pirates
pcall(function() 
    if game.Players.LocalPlayer.Team == nil then 
        game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("SetTeam","Pirates") 
    end 
end)

local Main = Win:CreateTab("Chính", 4483362458)

-- 4. TÍNH NĂNG NHẶT RƯƠNG TỐC ĐỘ CAO (BỎ AN TOÀN)
_G.AutoChest = false
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
                                -- Dịch chuyển tức thời đến rương
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                -- Chỉ đợi cực ngắn để server kịp nhận rương
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

Main:CreateSection("Lưu ý: Nhân vật sẽ tự Reset mỗi 30s!")

-- Thông báo chào "ngầu" cho Lữ Tài
Rayfield:Notify({
    Title = "LỮ TÀI HUB",
    Content = "Chào! Script nhặt rương VIP đã sẵn sàng.",
    Duration = 5
})
