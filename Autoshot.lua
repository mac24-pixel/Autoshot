-- // LIMPIEZA
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "MVS_Final_Pro" then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MVS_Final_Pro"

-- // INTERFAZ "EASY-MOVE"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 110, 0, 60)
Main.Position = UDim2.new(0.5, -55, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local ToggleBtn = Instance.new("TextButton", Main)
ToggleBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.Text = "ON"
ToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18

-- // CONFIGURACIÓN
getgenv().SilentEnabled = true
local PredictionValue = 0.18 

local function GetBestTarget()
    local closest = nil
    local shortestDist = 200 -- FOV Máximo en píxeles
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    local cam = workspace.CurrentCamera

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = cam:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    closest = v
                    shortestDist = dist
                end
            end
        end
    end
    return closest, shortestDist
end

-- // MOTOR DE DISPARO OPTIMIZADO
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(t, k)
    if getgenv().SilentEnabled and k == "Hit" then
        local target, pixelDist = GetBestTarget()
        
        if target then
            local lp = game.Players.LocalPlayer
            local tool = lp.Character and lp.Character:FindFirstChildOfClass("Tool")
            local isKnife = tool and (tool.Name:lower():find("knife") or tool.Name:lower():find("cuchillo"))
            
            -- Calculamos la distancia real en el mapa (studs)
            local realDist = (lp.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
            
            -- LÓGICA DE PROBABILIDADES
            local chance = 0
            
            if isKnife then
                chance = 100 -- El cuchillo sigue siendo infalible
            else
                -- Si el enemigo está LEJOS (más de 60 studs)
                if realDist > 60 then
                    if pixelDist < 40 then
                        chance = 70 -- Tocaste cerca: 70%
                    elseif pixelDist < 120 then
                        chance = 30 -- Tocaste alejado: 30%
                    end
                else
                    -- Si el enemigo está CERCA (combate normal)
                    if pixelDist < 60 then
                        chance = 95
                    elseif pixelDist < 150 then
                        chance = 60
                    end
                end
            end

            -- Ejecución del disparo
            if math.random(1, 100) <= chance then
                local tPos = target.Character.HumanoidRootPart.Position
                if isKnife then
                    tPos = tPos + (target.Character.HumanoidRootPart.Velocity * PredictionValue)
                end
                return CFrame.new(tPos)
            end
        end
    end
    return old(t, k)
end)

setreadonly(mt, true)

ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().SilentEnabled = not getgenv().SilentEnabled
    ToggleBtn.Text = getgenv().SilentEnabled and "ON" or "OFF"
    ToggleBtn.TextColor3 = getgenv().SilentEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)
