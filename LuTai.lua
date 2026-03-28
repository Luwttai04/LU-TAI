-- 1. CHỐNG BỊ KÍCH (ANTI-IDLE)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. TỰ ĐỘNG RESET MỖI 30 GIÂY (DÙNG BREAKJOINTS ĐỂ FIX LỖI)
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char:BreakJoints() -- Buộc nhân vật phải Reset
            end
        end)
    end
end)

-- 3. MENU RAYFIELD
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({Name="CHEST HUB VIP - LỮ TÀI",LoadingTitle="Đã Fix Auto Reset!",ConfigurationSaving={Enabled=false}})
local Main = Win:CreateTab("Chính", 4483362458)

-- 4. NHẶT RƯƠNG SIÊU NHANH (TELEPORT)
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
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                task.wait(0.1) -- Tốc độ tối đa
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

-- 5. NHẢY SERVER
Main:CreateButton({
    Name = "Nhảy Server",
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

Rayfield:Notify({Title="LỮ TÀI HUB", Content="Auto Reset 30s đang chạy ngầm!", Duration=5})
