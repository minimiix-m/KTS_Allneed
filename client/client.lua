local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTMOUSE"] = 24,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

ESX = nil
local canSlide = true
local resourceName = GetCurrentResourceName()

RegisterNetEvent(('%s:useScuba'):format(resourceName), function()
    pcall(function()
        exports['azael_ui-diving']:UseScuba()
    end)
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
        Wait(100) 
    end
end)

Citizen.CreateThread(function() 
  while true do
    N_0xf4f2c0d4ee209e20() 
    Wait(100)
  end
end)

local isPlayerInVehicle = false
local isMinimapVisible = true
local toggleKey = 'Q'  


local function hideMinimap()
    DisplayRadar(false)
    isMinimapVisible = false
	exports.nc_notify:PushNotification({
		title = "คุณได้ปิดการแสดงแมพเรียบร้อยแล้ว",
		description = '',
		icon = '',
		type = 'info',
		duration = 5000,
	})
end


local function showMinimap()
    DisplayRadar(true)
    isMinimapVisible = true
	exports.nc_notify:PushNotification({
		title = "คุณได้เปิดการแสดงแมพเรียบร้อยแล้ว",
		description = '',
		icon = '',
		type = 'info',
		duration = 3000,
	})
end

RegisterCommand("toggleminimap", function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        if isMinimapVisible then
            hideMinimap()
        else
            showMinimap()
        end
    end
end)


RegisterKeyMapping('toggleminimap', 'Toggle Minimap', 'keyboard', toggleKey)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = PlayerId()
        local playerPed = PlayerPedId()


        if IsPedInAnyVehicle(playerPed, false) then
            if not isPlayerInVehicle then

                isPlayerInVehicle = true
                showMinimap()
            end
        else
            if isPlayerInVehicle then

                isPlayerInVehicle = false
                hideMinimap()
            end
        end
    end
end)


local hurt = false
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if GetEntityHealth(GetPlayerPed(-1)) <= 130 then
            setHurt()
        elseif hurt and GetEntityHealth(GetPlayerPed(-1)) > 131 then
            setNotHurt()
        end
    end
end)

function setHurt()
    hurt = true
    RequestAnimSet("move_m@injured")
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
end

function setNotHurt()
    hurt = false
    ResetPedMovementClipset(GetPlayerPed(-1))
    ResetPedWeaponMovementClipset(GetPlayerPed(-1))
    ResetPedStrafeClipset(GetPlayerPed(-1))
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if canSlide then
			if IsPedOnFoot(GetPlayerPed(-1)) then
				if not IsPedRagdoll(GetPlayerPed(-1)) then
					if IsControlPressed(0, 21) then
						Citizen.Wait(100)
						if IsControlPressed(0, 104) and not IsEntityInWater(GetPlayerPed(-1)) then
							while (not HasAnimDictLoaded("missheistfbi3b_ig6_v2")) do RequestAnimDict("missheistfbi3b_ig6_v2") Citizen.Wait(5) end							
							SetPedMoveRateOverride(GetPlayerPed(-1), 1.25)
							ClearPedSecondaryTask(GetPlayerPed(-1))
							TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig6_v2", "rubble_slide_gunman", 3.0, 1.0, -1, 01, 0, 0, 0, 0)
							ApplyForceToEntityCenterOfMass(GetPlayerPed(-1), 1, 0, 12.8, 0.8, true, true, true, true)
							Citizen.Wait(250)
							TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig6_v2", "exit", 3.0, 1.0, -1, 01, 0, 0, 0, 0)
							ClearPedSecondaryTask(GetPlayerPed(-1))
							Citizen.Wait(10000)	

							exports.nc_notify:PushNotification({
								title = "สไลด์ได้แล้ว",
								description = '',
								icon = '',
								type = 'info',
								duration = 3000,
							})
						end
					else
						Citizen.Wait(1000)				
					end
				end
			end
		else
			Citizen.Wait(1000)			
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		SetPedCanLosePropsOnDamage(PlayerPedId(),false,0)
		Citizen.Wait(1000)
	end
  end)

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Citizen.Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

-- local count = 0
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(7)
--         if IsControlPressed(0, 22) then  -- เปลี่ยนปุ่ม
--             count = count + 0.1
--         end
--         if IsDisabledControlJustReleased(0, 22) then -- เปลี่ยน
--             count = 0
--         end
--         if count >= 5 then 
--             NotiftextSpacebar()
--             DisableAllControlActions(0)
--         end
--     end
-- end)



-- local count = 0
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(7)
--         if IsControlPressed(0, 24) then  -- เปลี่ยนปุ่ม
--             count = count + 0.1
--         end
--         if IsDisabledControlJustReleased(0, 24) then -- เปลี่ยน
--             count = 0
--         end
--         if count >= 5 then 
--             NotiftextLeftMouse()
-- 			-- Citizen.Wait(7)
--             DisableAllControlActions(0)
--         end
--     end
-- end)



local once = false
local oldval = false
local oldvalped = false

RegisterKeyMapping('point', 'point', 'keyboard', 'B')
RegisterCommand('point', function()
if not IsPedInAnyVehicle(PlayerPedId(), true) then
	if not once then
		once = true
		while true do
			Citizen.Wait(0)

				if not keyPressed then
					if  not mp_pointing and IsPedOnFoot(PlayerPedId()) then

						Citizen.Wait(200)
						if not IsControlPressed(0, 29) then
							keyPressed = true
							startPointing()
							mp_pointing = true
						else
							keyPressed = true
							while IsControlPressed(0, 29) do
								Citizen.Wait(50)
							end
						end
					elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
						keyPressed = true
						mp_pointing = false
						stopPointing()
					end
				end

				if keyPressed then
					if not IsControlPressed(0, 29) then
						keyPressed = false
					end
				end
				if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
					stopPointing()
				end
				if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
					if not IsPedOnFoot(PlayerPedId()) then
						stopPointing()
					else
						local ped = PlayerPedId()
						local camPitch = GetGameplayCamRelativePitch()
						if camPitch < -70.0 then
							camPitch = -70.0
						elseif camPitch > 42.0 then
							camPitch = 42.0
						end
						camPitch = (camPitch + 70.0) / 112.0

						local camHeading = GetGameplayCamRelativeHeading()
						local cosCamHeading = Cos(camHeading)
						local sinCamHeading = Sin(camHeading)
						if camHeading < -180.0 then
							camHeading = -180.0
						elseif camHeading > 180.0 then
							camHeading = 180.0
						end
						camHeading = (camHeading + 180.0) / 360.0

						local blocked = 0
						local nn = 0

						local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
						local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
						nn,blocked,coords,coords = GetRaycastResult(ray)

						Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
						Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
						Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
						Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
					end
				end	
				if not once then
					break
				end
		end
	else
		once = false
	
	end
end
end)

local handsup = false
RegisterKeyMapping('handsup', 'Hands Up', 'keyboard', 'X')
RegisterCommand('handsup', function()
    local player = PlayerPedId()
    local incarkeyx = IsPedInAnyVehicle(player, true)
    if not incarkeyx then             
        if not handsup then
            handsup = true
            local dict = "missminuteman_1ig_2"    
            RequestAnimDict(dict)
            if not HasAnimDictLoaded(dict) then
                Citizen.Wait(100)
            end       
            TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
        else
            ClearPedTasks(GetPlayerPed(-1))                    
            handsup = false                                     
        end

    end
end, false)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)		
		else
			Citizen.Wait(100)
        end
    end
end)

Config = {}
Config.WeaponList = {
	"WEAPON_ANGE",
	"WEAPON_WOODLAND",
	"WEAPON_VIRTUAL",
	"WEAPON_DARKEAGLEFIRE",
	"WEAPON_ROCKERPUNK",
	"WEAPON_TOXICKITTY",
	"WEAPON_SKELETON",
	"WEAPON_REDRIDING",
	"WEAPON_WINGEDFURY",
	"WEAPON_TOWERSENTINEL",
	"WEAPON_DARKELF",
	"WEAPON_STARWALKER",
	"WEAPON_JUMPSTART",
	"WEAPON_STUNGUN",
}

Config.PedAbleToWalkWhileSwapping = true
Config.UnarmedHash = "WEAPON_UNARMED"


Citizen.CreateThread(function()
	local animDict = 'reaction@intimidation@1h'

	local animIntroName = 'intro'
	local animOutroName = 'outro'

	local animFlag = 0

	RequestAnimDict(animDict)
	  
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	local lastWeapon = nil
	local sleep = true

	while true do
		Citizen.Wait(0)
		sleep = true	
		if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			if Config.PedAbleToWalkWhileSwapping then
				animFlag = 48
			else
				animFlag = 0
			end

			for i=1, #Config.WeaponList do
				if lastWeapon ~= nil and lastWeapon ~= GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey(Config.WeaponList[i]) then
					sleep = false
					SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(Config.UnarmedHash), true)
					TaskPlayAnim(GetPlayerPed(-1), animDict, animIntroName, 8.0, -8.0, 2700, animFlag, 0.0, false, false, false)
					Citizen.Wait(1000)
					SetCurrentPedWeapon(GetPlayerPed(-1), Config.WeaponList[i], true)
				end

				if lastWeapon ~= nil and lastWeapon == GetHashKey(Config.WeaponList[i]) and GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey(Config.UnarmedHash) then
					sleep = false
					TaskPlayAnim(GetPlayerPed(-1), animDict, animOutroName, 8.0, -8.0, 2100, animFlag, 0.0, false, false, false)
					Citizen.Wait(1000)
					SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey(Config.UnarmedHash), true)
				end
			end
		end
		lastWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
		if sleep then
			Citizen.Wait(500)
		end
	end
end)


function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false 

    repeat
        if DoesEntityExist(ped) then
            if not IsEntityDead(ped) or IsEntityDead(ped) then
                SetPedDropsWeaponsWhenDead(ped, false)
            end
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30)
        SetWeaponDrops()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if GetEntityMaxHealth(GetPlayerPed(-1)) ~= 200 then
			SetEntityMaxHealth(GetPlayerPed(-1), 200)
			SetEntityHealth(GetPlayerPed(-1), 200)
		end
	end
end)


Citizen.CreateThread(function() -- WAYPOINT COLOR
	ReplaceHudColourWithRgba(
	  142, -- PARAM
	  255, -- R
	  64, -- G
	  163, -- B
	  255 -- A
	)
  end)