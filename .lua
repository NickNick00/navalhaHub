local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NavalhaHub",
   Icon = nil, -- ou assetId válido em string
   LoadingTitle = "NavalhaHub",
   LoadingSubtitle = "by kyuzzy",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "NavalhaHub"
   },

   Discord = {
      Enabled = true,
      Invite = "",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "Navalha Keys",
      Subtitle = "Key System",
      Note = "Key da NavalhaHub.. kyukk",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"kyukk", "Navalha", "k"}
   }
})

local NavalhaHub = Window:CreateTab("Navalha Hub", 4483362458)
local Visuals = Window:CreateTab("Visuals", 4483362458)
local Combat = Window:CreateTab("Combat", 4483362458)

-- Variáveis globais
local nomeFeraManual = ""
local ESPJogadoresAtivado = false
local ESPComputadoresAtivado = false
local ESPHighlightAtivado = false
local ESPSaidasCapsulasAtivado = false
local jogadoresComESP = {}
local computadoresComESP = {}
local highlightsJogadores = {}
local highlightsSaidasCapsulas = {}

-- Seções
local SectionMain = NavalhaHub:CreateSection("Funções Principais")
local SectionNPC = Combat:CreateSection("NPCs")
local SectionExtra = NavalhaHub:CreateSection("Extras")

-- Input para nome da Fera (manual)
local InputFeraManual = Visuals:CreateInput({
   Name = "Nome da Fera (manual)",
   PlaceholderText = "Digite parte do nome da Fera...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      nomeFeraManual = string.lower(Text or "")
   end
})

-- Função para matar jogador
local function MatarJogador()
   local player = game.Players.LocalPlayer
   if player and player.Character and player.Character:FindFirstChild("Humanoid") then
      player.Character.Humanoid.Health = 0
   end
end

local ButtonKill = Combat:CreateButton({
   Name = "Matar Jogador",
   Callback = MatarJogador
})

local SliderJump = Combat:CreateSlider({
   Name = "Pulo (JumpPower)",
   Range = {0, 100},
   Increment = 1,
   Suffix = "",
   CurrentValue = 50,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.JumpPower = Value
      end
   end
})

local InputNPC = Combat:CreateInput({
   Name = "Nome do NPC",
   PlaceholderText = "Digite um NPC...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- aqui você pode adicionar ação para o texto digitado
   end
})

local DropdownNPC = Combat:CreateDropdown({
   Name = "Selecionar NPC",
   Options = {"Npc 1", "Npc 2", "Npc 3"},
   CurrentOption = "Npc 1",
   Callback = function(Option)
      -- ação para opção selecionada
   end
})

-- Funções ESP
local ESPVisuals = {}

-- Função para criar ESP de jogadores
local function criarESPJogadores()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local nomeJogador = string.lower(player.Name)
            local isBeastManual = nomeFeraManual ~= "" and string.find(nomeJogador, nomeFeraManual) ~= nil

            local status = isBeastManual and "🔴 FERA" or "🟢 Survivor"
            local corStatus = isBeastManual and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
            local corNome = Color3.fromRGB(255, 255, 255)

            if not jogadoresComESP[player] then
                local esp = Instance.new("BillboardGui")
                esp.Name = "JogadorESP"
                esp.Parent = player.Character
                esp.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
                esp.Size = UDim2.new(0, 65, 0, 30)
                esp.AlwaysOnTop = true

                -- Frame para organizar o conteúdo
                local frame = Instance.new("Frame")
                frame.Name = "ESPFrame"
                frame.Parent = esp
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundTransparency = 0.5
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BorderSizePixel = 0
                
                -- Cantos arredondados
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 3)
                corner.Parent = frame

                -- Label do status
                local labelStatus = Instance.new("TextLabel")
                labelStatus.Name = "StatusLabel"
                labelStatus.Parent = frame
                labelStatus.Size = UDim2.new(1, 0, 0.7, 0)
                labelStatus.Position = UDim2.new(0, 0, 0, 0)
                labelStatus.BackgroundTransparency = 1
                labelStatus.Font = Enum.Font.SourceSansBold
                labelStatus.TextScaled = true
                labelStatus.TextStrokeTransparency = 0.2
                labelStatus.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                -- Label do nome
                local labelNome = Instance.new("TextLabel")
                labelNome.Name = "NomeLabel"
                labelNome.Parent = frame
                labelNome.Size = UDim2.new(1, 0, 0.3, 0)
                labelNome.Position = UDim2.new(0, 0, 0.7, 0)
                labelNome.BackgroundTransparency = 1
                labelNome.Font = Enum.Font.SourceSans
                labelNome.TextScaled = true
                labelNome.TextStrokeTransparency = 0.2
                labelNome.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
           
                jogadoresComESP[player] = {
                    esp = esp, 
                    statusLabel = labelStatus, 
                    nomeLabel = labelNome
                }
            end

            local espData = jogadoresComESP[player]
            if espData and espData.statusLabel and espData.nomeLabel then
                espData.statusLabel.Text = status
                espData.statusLabel.TextColor3 = corStatus
                espData.nomeLabel.Text = player.Name
                espData.nomeLabel.TextColor3 = corNome
            end
        end
    end
end

-- Função para criar Highlight nos jogadores
local function criarHighlightJogadores()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local nomeJogador = string.lower(player.Name)
            local isBeastManual = nomeFeraManual ~= "" and string.find(nomeJogador, nomeFeraManual) ~= nil

            if not highlightsJogadores[player] then
                local highlight = Instance.new("Highlight")
                highlight.Name = "JogadorHighlight"
                highlight.Parent = player.Character
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0.3
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                
                highlightsJogadores[player] = highlight
            end

            local highlight = highlightsJogadores[player]
            if highlight then
                if isBeastManual then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                end
            end
        end
    end
end

-- Função para limpar Highlights
local function limparHighlightJogadores()
    for player, highlight in pairs(highlightsJogadores) do
        if highlight then
            highlight:Destroy()
        end
    end
    highlightsJogadores = {}
end

-- Função para toggle ESP de computadores
function ESPVisuals.toggleComputerESP()
   ESPComputadoresAtivado = not ESPComputadoresAtivado
   if ESPComputadoresAtivado then
      print("ESP de Computadores ativado.")
   else
      print("ESP de Computadores desativado.")
      limparESPComputadores()
   end
end

-- Função para toggle Highlight de jogadores
function ESPVisuals.toggleHighlightJogadores()
   ESPHighlightAtivado = not ESPHighlightAtivado
   if ESPHighlightAtivado then
      print("Highlight de Jogadores ativado.")
   else
      print("Highlight de Jogadores desativado.")
      limparHighlightJogadores()
   end
end

-- Função para limpar ESP de jogadores
local function limparESPJogadores()
    for player, espData in pairs(jogadoresComESP) do
        if espData and espData.esp then
            espData.esp:Destroy()
        end
    end
    jogadoresComESP = {}
end

-- Função para toggle ESP de jogadores
function ESPVisuals.toggleJogadoresESP()
   ESPJogadoresAtivado = not ESPJogadoresAtivado
   if ESPJogadoresAtivado then
      print("ESP de Jogadores ativado.")
   else
      print("ESP de Jogadores desativado.")
      limparESPJogadores()
   end
end

-- Função para ESP de computadores
local function criarESPComputadores()
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Busca especificamente por ComputerTable
        local isComputerTable = false
        local targetPart = nil
        
        -- Verifica se é um modelo com nome "ComputerTable"
        if obj:IsA("Model") then
            if obj.Name == "ComputerTable" then
                isComputerTable = true
                targetPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part")
            end
        end
        
        -- Verifica se é uma parte com nome "ComputerTable"
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            if obj.Name == "ComputerTable" then
                isComputerTable = true
                targetPart = obj
            end
        end
        
        if isComputerTable and targetPart and not computadoresComESP[obj] then
            local esp = Instance.new("BillboardGui")
            esp.Name = "ComputadorESP"
            esp.Parent = targetPart
            esp.Adornee = targetPart
            esp.Size = UDim2.new(0, 60, 0, 20)
            esp.AlwaysOnTop = true

            local frame = Instance.new("Frame")
            frame.Parent = esp
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 0.3
            frame.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            frame.BorderSizePixel = 0
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 3)
            corner.Parent = frame

            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSans
            label.TextScaled = true
            label.TextStrokeTransparency = 0.2
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Text = "💻"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)

            computadoresComESP[obj] = esp
        end
    end
end

-- Função para ESP de saídas e cápsulas
local function criarESPSaidasCapsulas()
    for _, obj in pairs(workspace:GetDescendents()) do
        local isTarget = false
        local targetPart = nil
        local cor = nil
        
        -- Verifica se é uma saída ou cápsula
        if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local name = obj.Name
            
            -- Saídas (Exit Doors)
            if name == "Exit Door" or name == "ExitDoor" then
                isTarget = true
                cor = Color3.fromRGB(0, 255, 0) -- Verde para saídas
                if obj:IsA("Model") then
                    targetPart = obj.PrimaryPart or obj:FindFirstChildOfClass("Part")
                else
                    targetPart = obj
                end
            end
            
            -- Cápsulas (Freezer Pods)
            if name == "Freezer Pod" or name == "FreezerPod" then
                isTarget = true  
                cor = Color3.fromRGB(255, 165, 0) -- Laranja para cápsulas
                if obj:IsA("Model") then
                    targetPart = obj.PrimaryPart or obj:FindFirstChildOfClass("Part")
                else
                    targetPart = obj
                end
            end
        end
        
        if isTarget and targetPart and not highlightsSaidasCapsulas[obj] then
            local highlight = Instance.new("Highlight")
            highlight.Name = "SaidaCapsulasHighlight"
            highlight.Parent = targetPart
            highlight.FillColor = cor
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = cor
            highlight.OutlineTransparency = 0.2
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            highlightsSaidasCapsulas[obj] = highlight
        end
    end
end

-- Função para limpar ESP de saídas e cápsulas
local function limparESPSaidasCapsulas()
    for obj, highlight in pairs(highlightsSaidasCapsulas) do
        if highlight then
            highlight:Destroy()
        end
    end
    highlightsSaidasCapsulas = {}
end

-- Loop principal do ESP
task.spawn(function()
    while true do
        if ESPJogadoresAtivado then
            criarESPJogadores()
        end
        if ESPComputadoresAtivado then
            criarESPComputadores()
        end
        if ESPHighlightAtivado then
            criarHighlightJogadores()
        end
        if ESPSaidasCapsulasAtivado then
            criarESPSaidasCapsulas()
        end
        task.wait(0.1) -- atualiza a cada 0.1 segundos
    end
end)

-- Botões ESP lado a lado
local BotaoESP = Visuals:CreateButton({
   Name = "ESP Computadores",
   Callback = function()
      ESPVisuals.toggleComputerESP()
   end
})

local BotaoESPJogadoresManual = Visuals:CreateButton({
   Name = "ESP Jogadores (Manual)",
   Callback = function()
      ESPVisuals.toggleJogadoresESP()
   end
})

local BotaoHighlightJogadores = Visuals:CreateButton({
   Name = "Highlight Jogadores",
   Callback = function()
      ESPVisuals.toggleHighlightJogadores()
   end
})

local BotaoESPSaidasCapsulas = Visuals:CreateButton({
   Name = "ESP Saídas e Cápsulas",
   Callback = function()
      ESPVisuals.toggleSaidasCapsulasESP()
   end
})

-- Extras
local KeybindExample = NavalhaHub:CreateKeybind({
   Name = "Atalho de Teclado",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Callback = function(Key)
      -- ação ao pressionar a tecla
   end
})

local ParagraphCreator = NavalhaHub:CreateParagraph({
   Title = "Criador",
   Content = "NavalhaHub by kyuzzy"
})

-- Limpar ESP quando jogadores saem
game.Players.PlayerRemoving:Connect(function(player)
    if jogadoresComESP[player] then
        if jogadoresComESP[player].esp then
            jogadoresComESP[player].esp:Destroy()
        end
        jogadoresComESP[player] = nil
    end
    
    if highlightsJogadores[player] then
        highlightsJogadores[player]:Destroy()
        highlightsJogadores[player] = nil
    end
end)

Rayfield:LoadConfiguration()
