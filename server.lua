ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local xPlayer = ESX.GetPlayerFromId(source)