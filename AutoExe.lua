if not getgenv().scriptExecuted then
    -- Определение таблицы с CreatorId и URL для загрузки скриптов
    local scripts = {
        --- CreatorID
        -- PS99
        [19717956] = "https://raw.githubusercontent.com/HOSTI1315/chek/refs/heads/main/PS99.lua", 
        -- БФ
        [4372130] = "https://raw.githubusercontent.com/HOSTI1315/chek/refs/heads/main/BF.lua",
        -- mm2
        [33820338] = "https://raw.githubusercontent.com/HOSTI1315/chek/refs/heads/main/MM2.lua",
        -- BB
        [32380537] = "https://raw.githubusercontent.com/HOSTI1315/chek/refs/heads/main/BB.lua"
    }

    -- Функция для загрузки и выполнения скрипта по URL
    local function loadAndRunScript(url)
        local success, script = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            -- Выполнение скрипта
            loadstring(script)()
        else
            warn("Ошибка при загрузке скрипта: " .. script)
        end
    end

    -- Основной блок для проверки текущего CreatorId и выполнения соответствующего скрипта
    local function runScriptForCreator()
        -- Дожидаемся, пока игра полностью загрузится
        game.Loaded:Wait()
        
        -- Получаем текущий CreatorId
        local currentCreatorId = game.CreatorId
        local scriptUrl = scripts[currentCreatorId]

        if scriptUrl then
            -- Если для данного CreatorId есть соответствующий скрипт, загружаем и выполняем его
            loadAndRunScript(scriptUrl)
        else
            warn("Для данного CreatorId (" .. currentCreatorId .. ") не найдено подходящего скрипта.")
        end
    end

    -- Запуск основной функции
    runScriptForCreator()

    -- Устанавливаем флаг, чтобы избежать повторного запуска
    getgenv().scriptExecuted = true
else
    warn("Скрипт уже был выполнен.")
end
