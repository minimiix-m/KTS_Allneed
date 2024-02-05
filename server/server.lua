ESX = nil

-- TriggerEvent(
--     "esx:getSharedObject",
--     function(a)
--         ESX = a
--     end
-- )


local resourceName = GetCurrentResourceName()
local ESX = exports['es_extended']:getSharedObject()

local jobs = {
    ['police'] = true,
    ['ambulance'] = true,
    ['mechanic'] = true,
    ['council'] = true,
    ['off_ambulance'] = true,
    ['off_council'] = true,
    ['off_police'] = true
}

ESX.RegisterUsableItem('scuba_gear_agency', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if jobs[xPlayer.job.name] then
        TriggerClientEvent(('%s:useScuba'):format(resourceName), xPlayer.source)
    else
        -- TriggerClientEvent('esx:showNotification', xPlayer.source, 'คุณไม่ได้รับอนุญาตให้ใช้งาน')
        exports.nc_notify:PushNotification(xPlayer.source,{
        title = "คุณไม่ได้รับอนุญาตให้ใช้งาน",
        -- description = '',
        -- icon = '',
        -- type = 'warning',
        duration = 3000,
    })
    end
end)


RegisterServerEvent("checkq:log")
AddEventHandler("checkq:log",function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local massage = "ผู้เล่น "..  xPlayer.name .."  ID  ".. id .."   กำลังใช้หมัด Q"
	sendToDiscord(massage,color,source,"https://discord.com/api/webhooks/926891133974503454/GC4ES70W6i18rSrDYtOZ5Px-OB9xrRHTElbdwbnjqG-7_m1zohZY36Bfk")
    end
)

function sendToDiscord(name, color, src, discord_webhook)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    local ids = ExtractIdentifiers(src)

    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = "Identifier:** ".. identifiers.steam .."**\nLink Steam: **https://steamcommunity.com/profiles/".. tonumber(ids.steam:gsub("steam:", ""),16) .."**\n Rockstar: **".. identifiers.license .."**\n Discord: <@".. ids.discord:gsub("discord:", "") .."> |  Discord ID: **".. identifiers.discord .."** \n IP Address: **".. GetPlayerEndpoint(src) .."**",
              ["footer"] = {
                  ["text"] = "เวลา: ".. os.date ("%X") .." - ".. os.date ("%x") .."",
              },
          }
      }
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end



function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

-- function isSpecifiedTime()
--     local specifiedTimes = {
--         {hour = 05, minute = 55}, 
--         {hour = 11, minute = 55},
--         {hour = 17, minute = 55},
--         {hour = 23, minute = 55},
--     }

--     local currentTime = os.date("*t")
--     for _, time in ipairs(specifiedTimes) do
--         if currentTime.hour == time.hour and currentTime.min == time.minute then
--             return true
--         end
--     end

--     return false
-- end

-- function deleteCacheFolder()
--     local cacheFolderPath = 'C:/Users/valhalla/Desktop/ServerFivem/cache'
--     local deleteCommand = 'rmdir /s /q "' .. cacheFolderPath .. '"'
--     local success = os.execute(deleteCommand)
--     if success then
--         print("Cache folder deleted successfully!")
--     else
--         print("Failed to delete cache folder.")
--     end
-- end

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(60000)

--         if isSpecifiedTime() then
--             deleteCacheFolder()
--         end
--     end
-- end)

-- RegisterCommand("deletecache", function()
--     deleteCacheFolder()
-- end, false)



-- TriggerEvent('es:addGroupCommand', 'checkping', 'admin', function(source, args, user)
-- 	if args[1] ~= nil then
-- 		if GetPlayerName(tonumber(args[1])) ~= nil then
-- 			-- local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
-- 			local ping = GetPlayerPing(tonumber(args[1]))
-- 			-- TriggerClientEvent('dopeNotify2:Alert', source, "",ping, 5000, 'info')			
-- 		end
-- 	end
-- end)

-- ESX.RegisterUsableItem("reskin", function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     TriggerClientEvent('esx_skin:openSaveableMenu',source)
--     xPlayer.removeInventoryItem('reskin', 1)
-- end)
