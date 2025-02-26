if not getgenv().scriptExecuted then
    -- Определение таблицы с CreatorId и URL для загрузки скриптов
    local scripts = {
        --- CreatorID
        -- Фиш
        [7381705] = "https://nousigi.com/loader.lua", 
        -- АС
        [33781793] = "https://raw.githubusercontent.com/ZaRdoOx/Fazium-files/main/Loader",
        -- АР
        [33820338] = "https://nousigi.com/loader.lua",
        -- Flop
        [33799733] = "https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Loader.lua",
        -- АА
        [10611639] = "https://raw.githubusercontent.com/HOSTI1315/autoscript/refs/heads/main/buang.lua",
        -- BF
        [4372130] = "https://raw.githubusercontent.com/HOSTI1315/autoscript/refs/heads/main/BF.lua",
        -- JoJo
        [15557357] = "https://raw.githubusercontent.com/HOSTI1315/autoscript/refs/heads/main/JoJoINF.lua",
        --СпанчБобек
        [34990762] = "https://raw.githubusercontent.com/couldntBeT/Main/refs/heads/main/Main.lua",
        -- Шары
        [32380537] = "https://raw.githubusercontent.com/couldntBeT/Main/refs/heads/main/BallTowerDefense.lua"
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
