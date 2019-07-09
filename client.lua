-- Original Code by MikeTheMadKiwi, Modified for ESX & GCPhone by MrMallenby
-- https://forum.fivem.net/u/mikethemadkiwi/summary
-- https://twitter.com/MrMallenby
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local notifyformelee = true
local notifyforballistic = true
local PlayerData              = {}
--
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

function notifyCops(ped, type)
    local ped = GetPlayerPed(ped)
    local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
    local weaponUsed = GetSelectedPedWeapon(ped)
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
        if PlayerData.job ~= 'police' then
        if type == 0 then -- melee attack
            TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('Attack In Progress'), PlayerCoords, {

                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
            Citizen.Wait(6000) --stops messages from being spammed
        end
        if type == 1 then -- ballistic attack
            TriggerServerEvent('esx_addons_gcphone:startCall', 'police', ('Shots Fired'), PlayerCoords, {

                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
            Citizen.Wait(1000)  --stops messages from being spammed
        end
    end 
    print('Ped: '..tostring(ped)..'used '..tostring(weaponUsed)..' at location.' )
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local isarmed = IsPedArmed(ped, 7) -- wil only be true if user is holding something OTHER than fists
        if isarmed then
            if notifyformelee == true then
                if IsPedInMeleeCombat(ped) then
                    notifyCops(ped, 0)
                end
            end
            if notifyforballistic == true then
                if IsPedShooting(ped) then
                    notifyCops(ped, 1)
                end
            end
        end
    end
end)
