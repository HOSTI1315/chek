wait(2)
game.Loaded:Wait()

local args = {
    [1] = "SetTeam",
    [2] = "Pirates"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
wait(2)
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer

-- Функция для имитации нажатия клавиши
function pressKey(keyCode, duration)
    VirtualInputManager:SendKeyEvent(true, keyCode, false, nil)
    task.wait(duration)
    VirtualInputManager:SendKeyEvent(false, keyCode, false, nil)
end

-- Запуск последовательности нажатий
pressKey(Enum.KeyCode.BackSlash, 0.1)  -- Нажать \
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Return, 0.1)     -- Нажать Enter
pressKey(Enum.KeyCode.Right, 0.1)      -- Нажать стрелку вправо
pressKey(Enum.KeyCode.Up, 0.1)         -- Нажать стрелку вверх
pressKey(Enum.KeyCode.Return, 0.1)     -- Нажать Enter
pressKey(Enum.KeyCode.Right, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1) 
pressKey(Enum.KeyCode.Left, 0.1) 
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)       -- Нажать стрелку вниз
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Down, 0.1)
pressKey(Enum.KeyCode.Return, 0.1)
pressKey(Enum.KeyCode.BackSlash, 0.1)
wait(1)
-- Вебхук-ссылка (замените на вашу ссылку)
local webhook = "https://discord.com/api/webhooks/1323066038778069104/aw-JU7tPlGWcZMUQR08rMU9RhNgIY3eZnH7726xNwHC6_2g48pllg5FQORbNmQ9xkf6y" 
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")

local function sendWebhook(embed)
    if not webhook then return end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            username = "Inventory Logger",
            embeds = {embed}
        }),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

local function collectInventoryData()
    local inventory = {}
    local basePath = game.Players.LocalPlayer.PlayerGui.Main.InventoryContainer.Right.Content.ScrollingFrame.Frame
    for i = 1, 16 do
        local slot = basePath[tostring(i)]
        if slot and slot.Filled then
            local itemName = slot.Filled.ItemInformation.ItemName.Text
            local itemCount = slot.Filled.ItemInformation.Counter.Shadow.TextLabel.Text
            inventory[itemName] = itemCount
        end
    end
    return inventory
end

local function createEmbed(playerName, inventory)
    local embed = {
        title = string.format("%s BF:", playerName),
        color = 1752220,
        fields = {}
    }
    
    for name, count in pairs(inventory) do
        table.insert(embed.fields, {
            name = name,
            value = count,
            inline = true
        })
    end
    
    return embed
end

-- Execution
local playerName = game.Players.LocalPlayer.Name
local inventoryData = collectInventoryData()

if next(inventoryData) then
    local embed = createEmbed(playerName, inventoryData)
    sendWebhook(embed)
else
    sendWebhook({
        title = "Ошибка",
        description = "Инвентарь пуст",
        color = 13632027
    })
end

wait(2)
local TeleportService = game:GetService("TeleportService")
local placeId = 142823291
TeleportService:Teleport(placeId, game.Players.LocalPlayer)

-- Ждем загрузки игры
game.Loaded:Connect(onGameLoaded)
