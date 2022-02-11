ESX = nil

TriggerEvent(Config.Events["esx:getSharedObject"], function(obj) ESX = obj end)

RegisterServerEvent("tLocation:openMenuLocationServer")
AddEventHandler("tLocation:openMenuLocationServer", function()
    TriggerClientEvent('tLocation:openMenuLocation', source)
end)

RegisterServerEvent("tLocation:pay")
AddEventHandler("tLocation:pay", function(price, vehicle)
    local xPlayer = ESX.GetPlayerFromId(source)  
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent(Config.Events["esx:showNotification"], source, "~g~Votre véhicule de location est arrivé !")
        TriggerClientEvent('tLocation:LocationApproved', source, vehicle)
    else
         TriggerClientEvent(Config.Events["esx:showNotification"], source, "Vous n'avez assez ~r~d\'argent")
    end
end)

print("")
print("[^5tLocation^7] - Made by TrapZed#1725^7")
print("")