-- ==========================================
-- SCRIPT: LỮ TÀI HUB - VIP EDITION
-- TÍNH NĂNG: AUTO CHEST, ANTI-KICK, RESET 10S
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
    LoadingTitle = "Xin Chào! Menu Đang tải...",
    LoadingSubtitle = "Antiban Loading...", -- ĐÃ ĐỔI DÒNG CHỮ NHỎ Ở ĐÂY
    ConfigurationSaving = {Enabled = false}
}) -- CHỖ NÀY LÚC NÃY ÔNG THIẾU DẤU NÀY NÊN MENU KHÔNG CHẠY

local Main = Win:CreateTab("Chính", 4483362458)
_G.AutoChest = false

-- 3. TỰ ĐỘNG RESET MỖI 10 GIÂY (CHỈ CHẠY KHI BẬT NHẶT RƯƠNG)
task.spawn(function()
    while true do
        task.wait(10) -- ĐÃ CHỈNH THÀNH 10 GIÂY
        if _G.AutoChest then 
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char:BreakJoints()
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
                                task.wait(0.2)
                                if not _G.AutoChest then break end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- 5. TÍNH NĂNG NHẢY SERVER (BẢN FIX LỖI "KHÔNG TÌM THẤY SERVER")
Main:CreateButton({
    Name = "Hop Server (Ngẫu Nhiên)",
    Callback = function()
        local Http = game:GetService("HttpService")
        local Tp = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        
        Rayfield:Notify({Title = "Lữ Tài Hub", Content = "Đang quét server mới...", Duration = 2})

        local function NhayServer()
            local Success, Error = pcall(function()
                -- Lấy danh sách server ngẫu nhiên để không bị trùng cái cũ
                local Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?limit=100&cursor="
                local Raw = game:HttpGet(Url)
                local Servers = Http:JSONDecode(Raw)
                
                if Servers and Servers.data then
                    local ServerList = {}
                    for _, s in pairs(Servers.data) do
                        if s.id ~= game.JobId and tonumber(s.playing) < tonumber(s.maxPlayers) then
                            table.insert(ServerList, s.id)
                        end
                    end
                    
                    if #ServerList > 0 then
                        local RandomServer = ServerList[math.random(1, #ServerList)]
                        Tp:TeleportToPlaceInstance(PlaceId, RandomServer)
                    else
                        -- Nếu không tìm thấy trong 100 cái đầu, thử nhảy cầu may bằng hệ thống
                        Tp:Teleport(PlaceId)
                    end
                end
            end)
            
            if not Success then
                Rayfield:Notify({Title = "Lỗi", Content = "Đang thử lại...", Duration = 2})
                task.wait(1)
                NhayServer()
            end
        end
        
        NhayServer()
    end
})

-- THÔNG BÁO KHI LOAD XONG
Rayfield:Notify({
    Title = "LỮ TÀI CHEST HUB",
    Content = "Xin Chào, Script Đã Sẵn Sàng.",
    Duration = 5
})
