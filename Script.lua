local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "KayyMaster_Config_V11.json"
local settings = {
    key = "K",
    auto_enabled = false,
    gui_visible_on_start = true,
    global_mesh = "136273049724604",
    global_tex = "128312481343540",
    auto_profile = "Default",
    presets = {
        ["Default"] = {y = 0.2, h = true, k = true}
    }
}

local function save()
    if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(settings)) end
end

local function load()
    if isfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if success then settings = data end
    end
end

load()

local offset_Y = 0.2
local headless_active = false
local korblox_active = false

local function cargarPerfilEnSesion(nombre)
    local data = settings.presets[nombre] or settings.presets["Default"]
    offset_Y = data.y
    headless_active = data.h
    korblox_active = data.k
end

if settings.auto_enabled then
    cargarPerfilEnSesion(settings.auto_profile)
end

local function AplicarSkin(char)
    if not char then return end
    
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 2)
    local rUpper = char:FindFirstChild("RightUpperLeg") or char:WaitForChild("RightUpperLeg", 2)
    
    if head then
        head.Transparency = headless_active and 1 or 0
        local decal = head:FindFirstChildOfClass("Decal")
        if decal then decal.Transparency = headless_active and 1 or 0 end
    end

    if rUpper then
        local partes = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
        for _, n in pairs(partes) do
            local p = char:FindFirstChild(n)
            if p then p.Transparency = korblox_active and 1 or 0 end
        end

        local palito = rUpper:FindFirstChild("VisualLeg")
        if korblox_active then
            if not palito then
                palito = Instance.new("Part")
                palito.Name = "VisualLeg"
                palito.Parent = rUpper
                palito.CanCollide = false
                palito.Massless = true
                Instance.new("SpecialMesh", palito)
                Instance.new("Weld", palito)
            end
            
            local mesh = palito:FindFirstChildOfClass("SpecialMesh")
            local weld = palito:FindFirstChildOfClass("Weld")
            
            mesh.MeshId = "rbxassetid://" .. tostring(settings.global_mesh):gsub("%D", "")
            mesh.TextureId = "rbxassetid://" .. tostring(settings.global_tex):gsub("%D", "")
            palito.Transparency = 0
            
            local scaleRatio = rUpper.Size.Y / 1.217
            mesh.Scale = Vector3.new(scaleRatio, scaleRatio, scaleRatio)
            
            weld.Part0, weld.Part1 = palito, rUpper
            weld.C0 = CFrame.new(0, -(rUpper.Size.Y / 2) + offset_Y, 0)
        elseif palito then
            palito:Destroy()
        end
    end
end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "KayyV11_Instant"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 480, 0, 400)
main.Position = UDim2.new(0.5, -240, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = settings.gui_visible_on_start
Instance.new("UICorner", main)

local pagePrincipal = Instance.new("Frame", main)
pagePrincipal.Size, pagePrincipal.Position = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 50)
pagePrincipal.BackgroundTransparency = 1

local pageAjustes = Instance.new("Frame", main)
pageAjustes.Size, pageAjustes.Position = UDim2.new(1, 0, 1, -50), UDim2.new(0, 0, 0, 50)
pageAjustes.BackgroundTransparency, pageAjustes.Visible = 1, false

local function CreateBtn(text, pos, size, color, parent)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position, b.Text, b.BackgroundColor3 = size, pos, text, color
    b.TextColor3, b.Font, b.TextSize = Color3.new(1,1,1), Enum.Font.GothamBold, 10
    Instance.new("UICorner", b)
    return b
end

local btnP = CreateBtn("PRINCIPAL", UDim2.new(0.05, 0, 0.02, 5), UDim2.new(0.44, 0, 0, 35), Color3.fromRGB(30,30,30), main)
local btnA = CreateBtn("AJUSTES", UDim2.new(0.51, 0, 0.02, 5), UDim2.new(0.44, 0, 0, 35), Color3.fromRGB(30,30,30), main)

btnP.MouseButton1Click:Connect(function() pagePrincipal.Visible = true pageAjustes.Visible = false end)
btnA.MouseButton1Click:Connect(function() pagePrincipal.Visible = false pageAjustes.Visible = true end)

local bKorb = CreateBtn("KORBLOX", UDim2.new(0.05, 0, 0.05, 0), UDim2.new(0.4, 0, 0, 35), Color3.fromRGB(40,40,40), pagePrincipal)
local bHead = CreateBtn("HEADLESS", UDim2.new(0.05, 0, 0.17, 0), UDim2.new(0.4, 0, 0, 35), Color3.fromRGB(40,40,40), pagePrincipal)
local bUp = CreateBtn("SUBIR (+)", UDim2.new(0.05, 0, 0.3, 0), UDim2.new(0.18, 0, 0, 35), Color3.fromRGB(50, 100, 50), pagePrincipal)
local bDown = CreateBtn("BAJAR (-)", UDim2.new(0.27, 0, 0.3, 0), UDim2.new(0.18, 0, 0, 35), Color3.fromRGB(100, 50, 50), pagePrincipal)
local inputName = Instance.new("TextBox", pagePrincipal)
inputName.Size, inputName.Position = UDim2.new(0.4, 0, 0, 35), UDim2.new(0.05, 0, 0.65, 0)
inputName.PlaceholderText, inputName.BackgroundColor3, inputName.TextColor3 = "Nombre Perfil...", Color3.fromRGB(25,25,25), Color3.new(1,1,1)
Instance.new("UICorner", inputName)
local bSave = CreateBtn("GUARDAR NUEVO PERFIL", UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.4, 0, 0, 40), Color3.fromRGB(46, 204, 113), pagePrincipal)

local list = Instance.new("ScrollingFrame", pagePrincipal)
list.Size, list.Position = UDim2.new(0.45, 0, 0, 320), UDim2.new(0.5, 0, 0, 5)
list.BackgroundColor3, list.BorderSizePixel = Color3.fromRGB(20,20,20), 0
Instance.new("UICorner", list)

local function CreateLabel(text, pos, parent)
    local l = Instance.new("TextLabel", parent)
    l.Text, l.Size, l.Position = text, UDim2.new(0.4,0,0,20), pos
    l.TextColor3, l.BackgroundTransparency, l.Font, l.TextXAlignment = Color3.new(1,1,1), 1, Enum.Font.GothamBold, Enum.TextXAlignment.Left
    return l
end

CreateLabel("ID MALLA:", UDim2.new(0.05,0,0,10), pageAjustes)
local inMesh = Instance.new("TextBox", pageAjustes)
inMesh.Size, inMesh.Position, inMesh.Text = UDim2.new(0.4,0,0,35), UDim2.new(0.05,0,0,35), settings.global_mesh
inMesh.BackgroundColor3, inMesh.TextColor3 = Color3.fromRGB(25,25,25), Color3.new(1,1,1)
Instance.new("UICorner", inMesh)

CreateLabel("ID TEXTURA:", UDim2.new(0.05,0,0,85), pageAjustes)
local inTex = Instance.new("TextBox", pageAjustes)
inTex.Size, inTex.Position, inTex.Text = UDim2.new(0.4,0,0,35), UDim2.new(0.05,0,0,110), settings.global_tex
inTex.BackgroundColor3, inTex.TextColor3 = Color3.fromRGB(25,25,25), Color3.new(1,1,1)
Instance.new("UICorner", inTex)

local bAutoG = CreateBtn("AUTO-EXEC: OFF", UDim2.new(0.05, 0, 0.45, 0), UDim2.new(0.4, 0, 0, 35), Color3.fromRGB(40,40,40), pageAjustes)
local bGuiG = CreateBtn("GUI AL INICIO: ON", UDim2.new(0.05, 0, 0.58, 0), UDim2.new(0.4, 0, 0, 35), Color3.fromRGB(40,40,40), pageAjustes)
local bSaveSettings = CreateBtn("GUARDAR AJUSTES", UDim2.new(0.05, 0, 0.8, 0), UDim2.new(0.4, 0, 0, 40), Color3.fromRGB(60, 120, 200), pageAjustes)

local function updateUI()
    bKorb.BackgroundColor3 = korblox_active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    bHead.BackgroundColor3 = headless_active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
    bAutoG.Text = settings.auto_enabled and "AUTO-EXEC: ON" or "AUTO-EXEC: OFF"
    bAutoG.BackgroundColor3 = settings.auto_enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60,60,60)
    bGuiG.Text = settings.gui_visible_on_start and "GUI AL INICIO: ON" or "GUI AL INICIO: OFF"
    bGuiG.BackgroundColor3 = settings.gui_visible_on_start and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60,60,60)
end

local function refresh()
    for _, v in pairs(list:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local count = 0
    for name, data in pairs(settings.presets) do
        local f = Instance.new("Frame", list)
        f.Size, f.Position, f.BackgroundTransparency = UDim2.new(0.9, 0, 0, 40), UDim2.new(0.05, 0, 0, count * 45), 1
        local b = CreateBtn(name, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 1, 0), (settings.auto_profile == name and Color3.fromRGB(60, 120, 200) or Color3.fromRGB(40,40,40)), f)
        b.MouseButton1Click:Connect(function() cargarPerfilEnSesion(name) updateUI() AplicarSkin(Player.Character) end)
        local bSet = CreateBtn("AUTO", UDim2.new(0.55, 0, 0, 0), UDim2.new(0.25, 0, 1, 0), (settings.auto_profile == name and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60,60,60)), f)
        bSet.MouseButton1Click:Connect(function() settings.auto_profile = name save() refresh() end)
        local bD = CreateBtn("X", UDim2.new(0.85, 0, 0, 0), UDim2.new(0.15, 0, 1, 0), Color3.fromRGB(150, 50, 50), f)
        bD.MouseButton1Click:Connect(function() if name ~= "Default" then settings.presets[name] = nil save() refresh() end end)
        count = count + 1
    end
    list.CanvasSize = UDim2.new(0,0,0, count * 45)
end

bKorb.MouseButton1Click:Connect(function() korblox_active = not korblox_active updateUI() AplicarSkin(Player.Character) end)
bHead.MouseButton1Click:Connect(function() headless_active = not headless_active updateUI() AplicarSkin(Player.Character) end)
bUp.MouseButton1Click:Connect(function() offset_Y = offset_Y + 0.1 AplicarSkin(Player.Character) end)
bDown.MouseButton1Click:Connect(function() offset_Y = offset_Y - 0.1 AplicarSkin(Player.Character) end)
bAutoG.MouseButton1Click:Connect(function() settings.auto_enabled = not settings.auto_enabled updateUI() end)
bGuiG.MouseButton1Click:Connect(function() settings.gui_visible_on_start = not settings.gui_visible_on_start updateUI() end)

bSaveSettings.MouseButton1Click:Connect(function()
    settings.global_mesh, settings.global_tex = inMesh.Text, inTex.Text
    save() AplicarSkin(Player.Character)
    bSaveSettings.Text = "¡GUARDADO!"
    task.wait(1) bSaveSettings.Text = "GUARDAR AJUSTES"
end)

bSave.MouseButton1Click:Connect(function()
    local n = inputName.Text ~= "" and inputName.Text or "Set_"..os.time()
    settings.presets[n] = {y = offset_Y, h = headless_active, k = korblox_active}
    save() refresh()
end)

Player.CharacterAppearanceLoaded:Connect(function(c)
    if settings.auto_enabled then cargarPerfilEnSesion(settings.auto_profile) end
    AplicarSkin(c)
end)

Player.CharacterAdded:Connect(function(c)
    if settings.auto_enabled then cargarPerfilEnSesion(settings.auto_profile) end
    repeat task.wait() until c:FindFirstChild("Head") and c:FindFirstChild("RightUpperLeg")
    AplicarSkin(c)
end)

local d, m, f; main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d,m,f = true,i.Position,main.Position end end)
main.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and d then local del = i.Position-m main.Position = UDim2.new(f.X.Scale, f.X.Offset+del.X, f.Y.Scale, f.Y.Offset+del.Y) end end)
UserInputService.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode[settings.key] then main.Visible = not main.Visible end end)

if Player.Character then AplicarSkin(Player.Character) end
updateUI() refresh()
