local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Win = Rayfield:CreateWindow({Name="CHEST HUB VIP - LỮ TÀI",LoadingTitle="by Lữ Tài",ConfigurationSaving={Enabled=false}})
pcall(function() if game.Players.LocalPlayer.Team==nil then game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("SetTeam","Pirates") end end)
local Main = Win:CreateTab("Chính",4483362458)
_G.AutoChest = false
Main:CreateToggle({Name="Bật/Tắt Nhặt Rương",CurrentValue=false,Callback=function(v)
    _G.AutoChest = v
    if v then task.spawn(function()
        while _G.AutoChest do
            local f = false
            pcall(function()
                for _,v in pairs(game:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Name:find("Chest") then
                        f = true
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                        task.wait(0.15)
                        if not _G.AutoChest then break end
                    end 
                end 
            end)
            if not f then task.wait(1) end
            task.wait(0.1)
        end 
    end) end 
end})
Main:CreateButton({Name="Nhảy Server (Hop)",Callback=function()
    local Http = game:GetService("HttpService")
    local Tp = game:GetService("TeleportService")
    local S = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _,s in pairs(S.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            Tp:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end 
    end 
end})
Main:CreateSection("Nhấn nút tròn để ẩn/hiện Menu")
Rayfield:Notify({Title="LỮ TÀI HUB",Content="Đã kích hoạt!",Duration=3})
