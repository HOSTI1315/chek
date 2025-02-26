-- Вебхук-ссылка (замените на вашу ссылку)
local webhook = "https://discord.com/api/webhooks/1323066038778069104/aw-JU7tPlGWcZMUQR08rMU9RhNgIY3eZnH7726xNwHC6_2g48pllg5FQORbNmQ9xkf6y"
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local HttpService = game:GetService("HttpService")

local function sendWebhook(embed)
    if not webhook then return end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            username = "BB Logger",
            embeds = {embed}
        }),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

local function findChildByName(parent, childName)
    return parent:FindFirstChild(childName) or parent:WaitForChild(childName)
end

local function gatherItems(folder, exceptions, nameLabelKey, stackLabelKey, checkNumber)
    local items = {}
    for _, item in pairs(folder:GetChildren()) do
        if exceptions[item.Name] then continue end
        
        if checkNumber then
            local delimiterPos = item.Name:find("|")
            if not delimiterPos then continue end
            
            local prefix = item.Name:sub(1, delimiterPos - 1)
            local numberStr = prefix:gsub("%D", "")
            local num = tonumber(numberStr) or 0
            
            if num < 5 then continue end
        end
        
        local nameLabel = item:FindFirstChild(nameLabelKey)
        local stack = item:FindFirstChild("Stack")
        local stackLabel = stack and stack:FindFirstChild(stackLabelKey) or nil
        
        if nameLabel then
            local name = nameLabel.Text
            local quantity = stackLabel and stackLabel.Text or "1"
            table.insert(items, { name = name, quantity = quantity })
        else
            warn("NameLabel не найден для элемента: " .. item.Name)
        end
    end
    return items
end

local function createEmbed(playerName, data)
    local embed = {
        title = string.format("%s BB:", playerName),
        color = 15548997, -- Оранжевый цвет для BB
        fields = {},
        footer = {
            text = "Данные собраны через скрипт",
            icon_url = "https://i.imgur.com/BBLogo.png" -- Добавь логотип BB
        }
    }
    
    for category, items in pairs(data) do
        local formattedItems = {}
        for _, item in ipairs(items) do
            table.insert(formattedItems, string.format("%s: %s", item.name, item.quantity))
        end
        
        table.insert(embed.fields, {
            name = category,
            value = table.concat(formattedItems, "\n") ~= "" and table.concat(formattedItems, "\n") or "Нет предметов",
            inline = false
        })
    end
    
    return embed
end

-- Сбор данных
local explosionOwnedFolder = game:GetService("Players").LocalPlayer.PlayerGui.Shop.Holder.Pages.Explosion.Owned
local explosionExceptions = {
    ["!Random"] = true,
    ["UIGridLayout"] = true,
    ["UIPadding"] = true
}
local explosions = gatherItems(explosionOwnedFolder, explosionExceptions, "NameLabel", "Label", true)

local swordOwnedFolder = game:GetService("Players").LocalPlayer.PlayerGui.Shop.Holder.Pages.Sword.Owned
local swordExceptions = {
    ["!Random"] = true,
    ["UIGridLayout"] = true,
    ["UIPadding"] = true
}
local swords = gatherItems(swordOwnedFolder, swordExceptions, "NameOfWeapon", "Label", true)

local emoteContentFolder = game:GetService("Players").LocalPlayer.PlayerGui.EmoteWheel.Wheel.Holder
local emoteExceptions = {
    ["UIGridLayout"] = true,
    ["UIPadding"] = true
}
local emotes = gatherItems(emoteContentFolder, emoteExceptions, "EmoteName", "Label", false)

-- Формирование эмбеда
local playerName = game.Players.LocalPlayer.Name
local data = {
    ["Эффекты"] = explosions,
    ["Мечи"] = swords,
    ["Эмоции"] = emotes
}

local embed = createEmbed(playerName, data)
sendWebhook(embed)
