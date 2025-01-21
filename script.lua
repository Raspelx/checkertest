local HttpService = game:GetService("HttpService")

local versionURL = "https://raw.githubusercontent.com/Raspelx/checkertest/refs/heads/main/version.json"

local currentVersion = "1.1.0"

local function getLatestVersion()
    local success, response = pcall(function()
        return HttpService:GetAsync(versionURL)
    end)
    if success then
        return HttpService:JSONDecode(response)
    else
        warn("Sürüm bilgisi alınamadı: " .. response)
        return nil
    end
end

local function compareVersions(current, latest)
    local currentParts = {}
    for part in string.gmatch(current, "%d+") do
        table.insert(currentParts, tonumber(part))
    end

    local latestParts = {}
    for part in string.gmatch(latest, "%d+") do
        table.insert(latestParts, tonumber(part))
    end

    for i = 1, math.max(#currentParts, #latestParts) do
        local currentPart = currentParts[i] or 0
        local latestPart = latestParts[i] or 0
        if currentPart < latestPart then
            return -1 -- Güncel değil
        elseif currentPart > latestPart then
            return 1 -- Daha yeni
        end
    end
    return 0 -- Güncel
end

local latestData = getLatestVersion()

if latestData then
    local comparison = compareVersions(currentVersion, latestData.version)
    if comparison == -1 then
        local player = game.Players.LocalPlayer
        player:Kick("Script'iniz güncel değil! Lütfen en son sürümü indirin: " .. latestData.download_url)
    elseif comparison == 0 then
        print("Script'iniz güncel!")
    else
        warn("Script'iniz en son sürümden daha yeni.")
    end
else
    warn("Güncelleme kontrolü başarısız. İnternet bağlantınızı kontrol edin.")
end
