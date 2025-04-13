local QBCore = exports['qb-core']:GetCoreObject()

-- Function to enable ghost mode
local function EnableGhostMode(playerPed)
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if playerVeh ~= 0 then
        -- Loop through all active players and disable collision between their vehicles and the player's vehicle
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                local targetPed = GetPlayerPed(i)
                if targetPed ~= playerPed then
                    local targetVeh = GetVehiclePedIsIn(targetPed, false)
                    if targetVeh ~= 0 then
                        SetEntityNoCollisionEntity(playerVeh, targetVeh, true)
                    end
                end
            end
        end
    end
end

-- Function to disable ghost mode
local function DisableGhostMode(playerPed)
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    if playerVeh ~= 0 then
        -- Loop through all active players and enable collision between their vehicles and the player's vehicle
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) then
                local targetPed = GetPlayerPed(i)
                if targetPed ~= playerPed then
                    local targetVeh = GetVehiclePedIsIn(targetPed, false)
                    if targetVeh ~= 0 then
                        SetEntityNoCollisionEntity(playerVeh, targetVeh, false)
                    end
                end
            end
        end
    end
end

-- Command to toggle ghost mode
RegisterCommand("ghostmode", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        if args[1] == "on" then
            EnableGhostMode(playerPed)
            QBCore.Functions.Notify("Ghost mode enabled", "success")
        elseif args[1] == "off" then
            DisableGhostMode(playerPed)
            QBCore.Functions.Notify("Ghost mode disabled", "error")
        else
            QBCore.Functions.Notify("Usage: /ghostmode [on/off]", "error")
        end
    else
        QBCore.Functions.Notify("You need to be in a vehicle to use this command", "error")
    end
end, false)

-- Add the command to the qb-core command list
QBCore.Commands.Add("ghostmode", "Toggle ghost mode to prevent collisions with other players' vehicles", {}, false, function(source, args)
    TriggerClientEvent("ghostmode", source, args)
end)
