-- Вебхук-ссылка (замените на вашу ссылку)
local webhook = "https://discord.com/api/webhooks/1323066038778069104/aw-JU7tPlGWcZMUQR08rMU9RhNgIY3eZnH7726xNwHC6_2g48pllg5FQORbNmQ9xkf6y"
-- Метод для отправки HTTP-запросов
local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
-- Служба для работы с HTTP
local HttpService = game:GetService("HttpService")
-- Функция для отправки вебхука с сообщением
local function sendWebhook(embed)
    if not webhook then return end
    httprequest({
        Url = webhook,
        Body = HttpService:JSONEncode({
            username = "PS99 Logger",
            embeds = {embed}
        }),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end
-- Логирование функции
local function log(message)
    print(message)
end
-- Ждем загрузки игры и необходимых элементов интерфейса
repeat
    wait()
until game:IsLoaded() and
    game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and
    game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainLeft") and
    game:GetService("Players").LocalPlayer.PlayerGui.MainLeft.Left.Currency.Diamonds.Diamonds.Visible == true and
    not game:GetService("Players").LocalPlayer:FindFirstChild("GUIFX Holder")
log("Начало выполнения скрипта")

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
pressKey(Enum.KeyCode.Right, 0.1)      -- Нажать стрелку вправо
pressKey(Enum.KeyCode.Right, 0.1)      -- Нажать стрелку вправо
pressKey(Enum.KeyCode.Return, 0.1)     -- Нажать Enter
pressKey(Enum.KeyCode.BackSlash, 0.1) -- Нажать \
wait(1)

-- Получаем данные игрока
local plr = game.Players.LocalPlayer
local data = {
    Gem = 0,
    Rank = 1,
    Huge = 0,
    Titanic = 0,
    Gargantuan = 0,
    MiniHuge = 0  -- Инициализируем MiniHuge
}
-- Обновление значения Gem
if plr.leaderstats:FindFirstChild("\240\159\146\142 Diamonds") then
    data.Gem = plr.leaderstats["\240\159\146\142 Diamonds"].Value
    log(string.format("Получено значение Gems: %d", data.Gem))
else
    log("Не удалось найти Gems в leaderstats")
end
-- Обновление значения Rank
if plr.leaderstats:FindFirstChild("\226\173\144 Rank") then
    data.Rank = plr.leaderstats["\226\173\144 Rank"].Value
    log(string.format("Получено значение Rank: %d", data.Rank))
else
    log("Не удалось найти Rank в leaderstats")
end
-- Обновление значений Huge, Titanic, Gargantuan и MiniHuge
local equippedPets = game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets.EquippedPets
if equippedPets then
    log("Найдена папка EquippedPets")
    for _, petFolder in ipairs(equippedPets:GetChildren()) do
        log(string.format("Найден элемент внутри EquippedPets: %s", petFolder.Name))
        if petFolder:IsA("Folder") then
            log(string.format("Элемент %s является папкой", petFolder.Name))
            local strengthText = petFolder:FindFirstChild("Strength")
            if strengthText and strengthText:IsA("TextLabel") then
                log(string.format("Найден Strength в элементе %s: %s", petFolder.Name, strengthText.Text))
                local questionCount = #strengthText.Text:gsub("[^?]", "")
                log(string.format("Количество знаков вопроса в Strength: %d", questionCount))
                if questionCount == 1 then
                    data.Huge = data.Huge + 1
                    log("Добавлен +1 к Huge")
                elseif questionCount == 2 then
                    data.Titanic = data.Titanic + 1
                    log("Добавлен +1 к Titanic")
                elseif questionCount == 3 then
                    data.Gargantuan = data.Gargantuan + 1
                    log("Добавлен +1 к Gargantuan")
                elseif questionCount == 0 then  -- Предположим, что MiniHuge имеет 0 знаков вопроса
                    data.MiniHuge = data.MiniHuge + 1
                    log("Добавлен +1 к MiniHuge")
                else
                    log("Количество знаков вопроса не соответствует известным категориям")
                end
            else
                log(string.format("Не найден Strength в элементе %s", petFolder.Name))
            end
        else
            log(string.format("Элемент %s не является папкой", petFolder.Name))
            -- Проверяем, содержит ли элемент дочерний объект Strength
            local strengthText = petFolder:FindFirstChild("Strength")
            if strengthText and strengthText:IsA("TextLabel") then
                log(string.format("Найден Strength в элементе %s: %s", petFolder.Name, strengthText.Text))
                local questionCount = #strengthText.Text:gsub("[^?]", "")
                log(string.format("Количество знаков вопроса в Strength: %d", questionCount))
                if questionCount == 2 then  -- Предположим, что MiniHuge имеет 0 знаков вопроса
                    data.MiniHuge = data.MiniHuge + 1
                    log("Добавлен +1 к MiniHuge")
                elseif questionCount == 3 then
                    data.Huge = data.Huge + 1
                    log("Добавлен +1 к Huge")
                elseif questionCount == 4 then
                    data.Titanic = data.Titanic + 1
                    log("Добавлен +1 к Titanic")
                elseif questionCount == 5 then
                    data.Gargantuan = data.Gargantuan + 1
                    log("Добавлен +1 к Gargantuan")
                else
                    log("Количество знаков вопроса не соответствует известным категориям")
                end
            else
                log(string.format("Не найден Strength в элементе %s", petFolder.Name))
            end
        end
    end
else
    log("Не найдена папка EquippedPets")
end
-- Функция для создания эмбеда
local function createEmbed(playerName, data)
    local embed = {
        title = string.format("%s PS99:", playerName),
        color = 3447003, -- MM2 стиль синий
        fields = {
            {
                name = "Gem",
                value = tostring(data.Gem),
                inline = true
            },
            {
                name = "Rank",
                value = tostring(data.Rank),
                inline = true
            },
            {
                name = "MiniHuge",
                value = tostring(data.MiniHuge),
                inline = true
            },
            {
                name = "Huge",
                value = tostring(data.Huge),
                inline = true
            },
            {
                name = "Titanic",
                value = tostring(data.Titanic),
                inline = true
            },
            {
                name = "Gargantuan",
                value = tostring(data.Gargantuan),
                inline = true
            }
        },
        footer = {
            text = "Данные собраны через скрипт",
            icon_url = "https://i.imgur.com/MM2Logo.png" -- Добавьте логотип MM2
        }
    }
    return embed
end
-- Создаем эмбед и отправляем его в вебхук
local playerName = plr.Name
local embed = createEmbed(playerName, data)
sendWebhook(embed)
log("Сообщение отправлено в вебхук")

local TeleportService = game:GetService("TeleportService")
local placeId = 2753915549
TeleportService:Teleport(placeId, game.Players.LocalPlayer)
