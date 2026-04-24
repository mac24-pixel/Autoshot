--// CLEAN
for _,a1 in pairs(game:GetService("CoreGui"):GetChildren())do
    if a1.Name==string.char(77,86,83,95,70,105,110,97,108,95,80,114,111)then a1:Destroy()end
end

local a2=Instance.new("ScreenGui",game:GetService("CoreGui"))
a2.Name=string.char(77,86,83,95,70,105,110,97,108,95,80,114,111)

--// UI
local a3=Instance.new("Frame",a2)
a3.Size=UDim2.new(0,110,0,60)
a3.Position=UDim2.new(0.5,-55,0.15,0)
a3.BackgroundColor3=Color3.fromRGB(15,15,15)
a3.BorderSizePixel=0
a3.Active=true
a3.Draggable=true

local a4=Instance.new("TextButton",a3)
a4.Size=UDim2.new(0.9,0,0.8,0)
a4.Position=UDim2.new(0.05,0,0.1,0)
a4.BackgroundColor3=Color3.fromRGB(35,35,35)
a4.Text="ON"
a4.TextColor3=Color3.fromRGB(50,255,50)
a4.Font=Enum.Font.SourceSansBold
a4.TextSize=18

--// CFG
getgenv()._0xA=true
local a5=0.18

local function a6()
    local a7=nil
    local a8=200
    local a9=game:GetService("UserInputService"):GetMouseLocation()
    local a10=workspace.CurrentCamera

    for _,a11 in pairs(game:GetService("Players"):GetPlayers())do
        if a11~=game:GetService("Players").LocalPlayer and a11.Character and a11.Character:FindFirstChild("HumanoidRootPart")then
            local a12,a13=a10:WorldToViewportPoint(a11.Character.HumanoidRootPart.Position)
            if a13 then
                local a14=(Vector2.new(a12.X,a12.Y)-a9).Magnitude
                if a14<a8 then
                    a7=a11
                    a8=a14
                end
            end
        end
    end
    return a7,a8
end

--// HOOK
local a15=getrawmetatable(game)
local a16=a15.__index
setreadonly(a15,false)

a15.__index=newcclosure(function(a17,a18)
    if getgenv()._0xA and a18=="Hit" then
        local a19,a20=a6()
        if a19 then
            local a21=game:GetService("Players").LocalPlayer
            local a22=a21.Character and a21.Character:FindFirstChildOfClass("Tool")
            local a23=a22 and (string.lower(a22.Name):find("knife") or string.lower(a22.Name):find("cuchillo"))

            local a24=(a21.Character.HumanoidRootPart.Position-a19.Character.HumanoidRootPart.Position).Magnitude

            local a25=0

            if a23 then
                a25=100
            else
                if a24>60 then
                    if a20<40 then
                        a25=70
                    elseif a20<120 then
                        a25=30
                    end
                else
                    if a20<60 then
                        a25=95
                    elseif a20<150 then
                        a25=60
                    end
                end
            end

            if math.random(1,100)<=a25 then
                local a26=a19.Character.HumanoidRootPart.Position
                if a23 then
                    a26=a26+(a19.Character.HumanoidRootPart.Velocity*a5)
                end
                return CFrame.new(a26)
            end
        end
    end
    return a16(a17,a18)
end)

setreadonly(a15,true)

a4.MouseButton1Click:Connect(function()
    getgenv()._0xA=not getgenv()._0xA
    a4.Text=getgenv()._0xA and "ON" or "OFF"
    a4.TextColor3=getgenv()._0xA and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)
