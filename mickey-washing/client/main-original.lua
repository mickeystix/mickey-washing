RepentzFW = nil
isLoggedIn = false

Citizen.CreateThread(function()
	while RepentzFW == nil do
		TriggerEvent('RepentzFW:GetObject', function(obj) RepentzFW = obj end)
		Citizen.Wait(300)
	end
end)
local sellItemsSet = false
local sellPrice = 0
local sellHardwareItemsSet = false
local sellHardwarePrice = 0

Citizen.CreateThread(function()
	--[[local blip = AddBlipForCoord(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z)
	SetBlipSprite(blip, 431)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 5)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Casino Manager")
	EndTextCommandSetBlipName(blip)]]
	while true do 
		Citizen.Wait(1)
		local inRange = false
		local pos = GetEntityCoords(PlayerPedId())
		if #(pos - vector3(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z)) < 350.0 then
			if not DoesEntityExist(trader) then
				RequestModel("s_m_m_movprem_01")
				while not HasModelLoaded("s_m_m_movprem_01") do
					Wait(10)
				end

				trader = CreatePed(26, "s_m_m_movprem_01", Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z, Config.TraderLocation.h, false, false)
				SetEntityHeading(trader, Config.TraderLocation.h)
				SetBlockingOfNonTemporaryEvents(trader, true)
				SetEntityCanBeDamaged(trader, 0)
				TaskStartScenarioInPlace(trader, "WORLD_HUMAN_DRINKING", 0, false)
			end
		else
			Citizen.Wait(1500)
		end

		if #(pos - vector3(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z)) < 5.0 then
			inRange = true
			if #(pos - vector3(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z)) < 1.5 then
				if not sellItemsSet then 
					sellPrice = GetSellingPrice()
					sellItemsSet = true
				elseif sellItemsSet and sellPrice ~= 0  then -- add and not CheckWeight() when its ready
					DrawText3D(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z, "~g~E~w~ - Trade Marked Bills for Casino Tokens ($"..sellPrice..")")
					if IsControlJustReleased(0, 38) then
						created_ped = TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
						SetEntityInvincible(created_ped, true)
						RepentzFW.Functions.Progressbar("sell_pawn_items", "Selling Items", 5000, false, true, {}, {}, {}, {}, function() -- Done
							ClearPedTasks(PlayerPedId())
							TriggerServerEvent("mickey-washing:server:sellPawnItems")
							sellItemsSet = false
							sellPrice = 0
						end, function() -- Cancel
							ClearPedTasks(PlayerPedId())
							RepentzFW.Functions.Notify("Canceled..", "error")
						end)
					end
				--[[elseif CheckWeight() then
					DrawText3D(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z, "'You can't carry all of this. Lose some baggage.'")
				end]]
				else
					DrawText3D(Config.TraderLocation.x, Config.TraderLocation.y, Config.TraderLocation.z, "'You have nothing I need'")
				end
			end
		end
		if not inRange then
			sellPrice = 0
			sellItemsSet = false
			Citizen.Wait(2500)
		end
	end
end)

--Use this callback to get if player is overweight or not. finish up on server side
function CheckWeight()
	RepentzFW.Functions.TriggerCallback('mickey-washing:server:checkWeight', function(result)
		overweight = result
	end)
	Citizen.Wait(500)
	return overweight
end


function GetSellingPrice()
	local price = 0
	RepentzFW.Functions.TriggerCallback('mickey-washing:server:getSellPrice', function(result)
		price = result
	end)
	Citizen.Wait(500)
	return price
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end