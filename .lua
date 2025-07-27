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
local SectionMain = NavalhaHub:CreateSection("Funções Principais")


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
   Suffix = "", -- sem '%'
   CurrentValue = 50,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.JumpPower = Value
      end
   end
})

local SectionNPC = Combat:CreateSection("NPCs")

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

local SectionExtra = NavalhaHub:CreateSection("Extras")

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

Rayfield:LoadConfiguration()
