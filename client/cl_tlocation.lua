ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.Events["esx:getSharedObject"], function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local locationEnCours = false
local displayLocation = false

RegisterNetEvent("tLocation:LocationApproved")
AddEventHandler('tLocation:LocationApproved', function(vehicle)
    ESX.Game.SpawnVehicle(vehicle, Config.SpawnPosition, Config.SpawnHeading, function(vehicleLocation)
      SetVehicleNumberPlateText(vehicleLocation, "LOCATION")
      TaskWarpPedIntoVehicle(PlayerPedId(), vehicleLocation, -1)
  end)
end)

RegisterNetEvent("tLocation:openMenuLocation")
AddEventHandler('tLocation:openMenuLocation', function()
	SetDisplay(not displayLocation)
end)

RegisterNUICallback("close", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("1", function(data)
  SetResourceKvp("ChoosedLocation", "choix1")
  ChoosedLocation = GetResourceKvpString("ChoosedLocation")
  SetDisplay(false)
end)

RegisterNUICallback("2", function(data)
  SetResourceKvp("ChoosedLocation", "choix2")
  ChoosedLocation = GetResourceKvpString("ChoosedLocation")
  SetDisplay(false)
end)

function SetDisplay(bool)
  displayLocation = bool
  SetNuiFocus(bool, bool)
  SendNUIMessage({
      type = "openLocation",
      status = bool
  })
end

CreateThread(function()
  while true do
      if ChoosedLocation == "choix1" then
        if locationEnCours then
          ESX.ShowHelpNotification("~r~Vous avez déjà une location en cours !")
        else
          TriggerServerEvent("tLocation:pay", Config.PriceCar1, Config.Car1)
          locationEnCours = true
        end
        ChoosedLocation = nil
      elseif ChoosedLocation == "choix2" then
        if locationEnCours then
          ESX.ShowHelpNotification("~r~Vous avez déjà une location en cours !")
        else
          TriggerServerEvent("tLocation:pay", Config.PriceCar2, Config.Car2)
          locationEnCours = true
        end
        ChoosedLocation = nil
      end
      Citizen.Wait(80)
  end
end)

Citizen.CreateThread(function()
  while true do
      local interval = 750
      
      local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
      local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Position)

      if dist <= 2 then
          interval = 1
          draw2dText(("Appuyez sur [~r~E~s~] pour louer un véhicule"), { 0.424, 0.955 } )
          --ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour ~b~intéragir")
          if IsControlJustPressed(1,51) then
            TriggerServerEvent('tLocation:openMenuLocationServer')
          end
   
      end

      Citizen.Wait(interval)

  end

end)

-- Création du ped
Citizen.CreateThread(function()
  LoadModel(Config.Ped)
  ped = CreatePed(2, GetHashKey(Config.Ped), Config.PedPosition, Config.PedHeading, 0, 0)
  DecorSetInt(ped, "Yay", 5431)
  FreezeEntityPosition(ped, 1)
  SetEntityInvincible(ped, true)
  SetBlockingOfNonTemporaryEvents(ped, 1)
  TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", 0, 1) 
end)

function LoadModel(model)
while not HasModelLoaded(model) do
  RequestModel(model)
  Wait(1)
end
end

Citizen.CreateThread(function()
  local blip = AddBlipForCoord(Config.Position)
  SetBlipSprite(blip,620)
  SetBlipDisplay(blip,4)
  SetBlipScale(blip,0.7)
  SetBlipColour(blip,5)
  SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("~y~Location~s~")
  EndTextCommandSetBlipName(blip)
end)

function draw2dText(text, pos)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.55, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end