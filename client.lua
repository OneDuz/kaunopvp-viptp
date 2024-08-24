local cloudOpacity = 0.01
local muteSound = true
local cooldowns = {
    ["Pistol Only Zone"] = 0,
    ["Third Person Zone"] = 0,
    ["Turfas Micheal"] = 0,
    ["Turfas Vespucci"] = 0,
    ["Random Pistol Zone"] = 0,
    ["Random Stambiu Redzone"] = 0,
    ["Nelegali Parduotuve"] = 0,
    ["Pinigu Plovimas"] = 0,
}
local cooldownTime = 60000 -- 30 seconds in milliseconds
local teleportCooldownMessage = "Ši parinktis nepasiekiama. Palaukite %d sekundžių."

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE")
    else
        StopAudioScene("MP_LEADERBOARD_SCENE")
    end
end

function InitialSetup()
    SetManualShutdownLoadingScreenNui(true)
    ToggleSound(muteSound)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end
end

function ClearScreen()
    SetCloudHatOpacity(cloudOpacity)
    HideHudAndRadarThisFrame()
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

function switchCharacter(endCoords, option)
    local currentTime = GetGameTimer()
    if cooldowns[option] and currentTime < cooldowns[option] then
        local remainingCooldown = math.ceil((cooldowns[option] - currentTime) / 1000)
        local message = string.format(teleportCooldownMessage, remainingCooldown)
        print(message)
        return
    end

    cooldowns[option] = currentTime + cooldownTime

    local playerPed = PlayerPedId()
    local startCoords = GetEntityCoords(playerPed)

    Citizen.CreateThread(function()
        InitialSetup()
        SetEntityInvincible(playerPed, true)
        SetEntityVisible(playerPed, false, false)
        
        while GetPlayerSwitchState() ~= 5 do
            Citizen.Wait(0)
            ClearScreen()
        end
        
        ClearScreen()
        Citizen.Wait(0)
        DoScreenFadeOut(0)

        ClearScreen()
        Citizen.Wait(0)
        ClearScreen()
        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Citizen.Wait(0)
            ClearScreen()
        end
        
        local timer = GetGameTimer()

        ToggleSound(false)
        
        while true do
            ClearScreen()
            Citizen.Wait(0)
            
            if GetGameTimer() - timer > 1000 then
                local playerPed = PlayerPedId()
                local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                
                SetCamCoord(cam, startCoords.x, startCoords.y, startCoords.z + 1.0)
                PointCamAtCoord(cam, startCoords.x, startCoords.y, startCoords.z)
                SetCamActive(cam, true)
                RenderScriptCams(true, false, 0, true, true)

                for i = 1, 50 do
                    SetCamCoord(cam, startCoords.x, startCoords.y, startCoords.z + i)
                    Citizen.Wait(20)
                end
                
                local destinationValid = true

                -- if IsPointOnRoad(endCoords.x, endCoords.y, endCoords.z, 10.0) then
                --     destinationValid = true
                -- end

                if destinationValid then
                    for i = 1, 100 do
                        local x = startCoords.x + (endCoords.x - startCoords.x) * (i / 100)
                        local y = startCoords.y + (endCoords.y - startCoords.y) * (i / 100)
                        local z = startCoords.z + 50.0 + ((endCoords.z + 50.0) - (startCoords.z + 50.0)) * (i / 100)
                        SetCamCoord(cam, x, y, z)
                        PointCamAtCoord(cam, endCoords.x, endCoords.y, endCoords.z)
                        Citizen.Wait(20)
                    end
                else
                    print("Destination area not valid. Waiting...")
                    Citizen.Wait(1000)
                    DestroyCam(cam, false)
                    break
                end
                
                FreezeEntityPosition(playerPed, true)
                SetEntityCoordsNoOffset(playerPed, endCoords.x, endCoords.y, endCoords.z, false, false, false, true)
                --SetPlayerInvincible(playerPed, true)
                --SetPlayerVisibleLocally(playerPed, false)

                Citizen.Wait(1000) -- Wait for stability
                
                -- Restore player control and visibility after teleportation
                --SetPlayerInvincible(playerPed, false)
                --SetPlayerVisibleLocally(playerPed, true)
                
                Citizen.Wait(2000)
                
                for i = 50, 1, -1 do
                    SetCamCoord(cam, endCoords.x, endCoords.y, endCoords.z + i)
                    Citizen.Wait(20)
                end
                
                RenderScriptCams(false, true, 500, true, true)
                DestroyCam(cam, false)
                
                SwitchInPlayer(playerPed)
                
                ClearScreen()
                
                while GetPlayerSwitchState() ~= 12 do
                    Citizen.Wait(0)
                    ClearScreen()
                end
                break
            end
        end
        SetEntityInvincible(playerPed, false)
        SetEntityVisible(playerPed, true, false)
        FreezeEntityPosition(playerPed, false)
        ClearDrawOrigin()
    end)
end



RegisterCommand("vtp", function ()
    local options = {
        {
            title = 'Pistol Only Zone',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(-490.0133, -993.5602, 52.4761), 'Pistol Only Zone')
            end,
        },
        {
            title = 'Third Person Zone',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(147.9335, -1358.5874, 40.6817), 'Third Person Zone')
            end,
        },
        {
            title = 'Turfas Micheal',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(-734.7729, 181.2985, 72.7014), 'Turfas Micheal')
            end,
        },
        {
            title = 'Turfas Vespucci',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(-728.1525, -816.0424, 23.4382), 'Turfas Vespucci')
            end,
        },
        {
            title = 'Random Pistol Zone',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(88.5825, -1738.4767, 47.6886), 'Random Pistol Zone')
            end,
        },
        {
            title = 'Random Stambiu Redzone',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(54.1846, -379.0250, 73.9416), 'Random Stambiu Redzone')
            end,
        },
        {
            title = 'Nelegali Parduotuve',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(98.3624, 175.9343, 104.6157), 'Nelegali Parduotuve')
            end,
        },
        {
            title = 'Pinigu Plovimas',
            description = '',
            disabled = false,
            onSelect = function()
                switchCharacter(vec3(-1878.8180, -323.8600, 49.3672), 'Pinigu Plovimas')
            end,
        },
    }

    local currentTime = GetGameTimer()
    for _, option in ipairs(options) do
        if cooldowns[option.title] and currentTime < cooldowns[option.title] then
            option.disabled = true
            option.description = string.format(teleportCooldownMessage, math.ceil((cooldowns[option.title] - currentTime) / 1000))
        end
    end

    lib.registerContext({
        id = 'vtp',
        title = 'VIP TP',
        options = options
    })
    lib.showContext('vtp')
end)
