----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNCIONALIDADE DE ITENS DO INVENTARIO
-----------------------------------------------------------------------------------------------------------------------------------------
local oxygen = 0
local in_scuba = false
local attachedProp = 0
local scubaMask = 0
local scubaTank = 0

function API.setScuba(status)
    if status then
        attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
        attachProp("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
        in_scuba = true
        oxygen = 100
    else
        in_scuba = false
        DeleteEntity(scubaMask)
        DeleteEntity(scubaTank)
    end
end

function API.checkScuba()
    return in_scuba
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	local attachModel = GetHashKey(attachModelSent)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)

	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
    end

    if tonumber(attachModel) == 1569945555 then
        attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
        scubaTank = attachedProp
    elseif tonumber(attachModel) == 138065747 then
        attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
        scubaMask = attachedProp
    end

    SetEntityCollision(attachedProp, false, 0)
    AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

Citizen.CreateThread(function()
	while true do
		local time = 1000
        if IsPedSwimmingUnderWater(GetPlayerPed(-1)) and in_scuba then
            time = 5
            if oxygen > 50 then
                drawTxt("VOCÊ POSSUI ~g~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen > 30 then
                drawTxt("VOCÊ POSSUI ~b~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen > 0 then
                drawTxt("VOCÊ POSSUI ~r~"..oxygen.."% ~w~ DE OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), false)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            elseif oxygen <= 0 then
                drawTxt("~r~VOCÊ NÃO POSSUI MAIS OXIGÊNIO.",4,0.5,0.96,0.50,255,255,255,100)
                SetPedDiesInWater(GetPlayerPed(-1), true)
                SetPedMaxTimeUnderwater(GetPlayerPed(-1), 0.0)
                oxygen = 0
            end
        elseif IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not in_scuba then
            SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.0)
            SetPedDiesInWater(GetPlayerPed(-1), true)
        end
        Citizen.Wait(time)
    end
end)

Citizen.CreateThread(function()
	while true do
		local time = 5000
        if IsPedSwimmingUnderWater(GetPlayerPed(-1)) and in_scuba then
            oxygen = oxygen - 1
        end
        Citizen.Wait(time)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE USAR BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = false
local tempoBandagem = 0
local oldHealth = 0

function API.useBandagem()
	bandagem = true
	tempoBandagem = 60
	oldHealth = GetEntityHealth(PlayerPedId())
end

Citizen.CreateThread(function()
	while true do
		local time = 1000
		if bandagem then
			if GetEntityHealth(PlayerPedId()) > 300 then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify", "negado", "<b>Você Não Pode Utilizar a [BANDAGEM]</b> Pois Sua Vida Está Cheia.", 4000)
			end

			tempoBandagem = tempoBandagem - 1

			if tempoBandagem <= 0 then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify", "negado", "<b>Sua Bandagem acabou</b>", 5000)
			end

			if oldHealth > GetEntityHealth(PlayerPedId()) and bandagem then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify", "negado", "<b>A [BANDAGEM]</b> Foi Cancelada Pois Você sofreu algum dano.", 60000)
			end

			if GetEntityHealth(PlayerPedId()) <= 101 and bandagem then
				tempoBandagem = 0
				bandagem = false
				TriggerEvent("Notify", "negado", "A Bandagem Foi Cancelada pois Você morreu.", 4000)
			end

			if GetEntityHealth(PlayerPedId()) > 105 and bandagem and GetEntityHealth(PlayerPedId()) < 250 then
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
			end

			if GetEntityHealth(PlayerPedId()) >= 300 and bandagem then
				tempoBandagem = 0
				bandagem = false
				SetEntityHealth(PlayerPedId(), 300)
				TriggerEvent("Notify", "negado", "<b>A Bandagem Foi Cancelada pois sua Vida já está cheia.", 4000)
			end

			if GetEntityHealth(PlayerPedId()) < 300 and bandagem then
				if oldHealth > GetEntityHealth(PlayerPedId()) then
					tempoBandagem = 0
					bandagem = false
					TriggerEvent("Notify", "negado", "A Bandagem Foi Cancelada pois Você sofreu algum dano.", 5000)
				elseif GetEntityHealth(PlayerPedId()) >= 300 then
					tempoBandagem = 0
					bandagem = false
					SetEntityHealth(PlayerPedId(), 300)
					TriggerEvent("Notify", "negado", "<b>[BANDAGEM]</b> acabou a bandagem..", 5000)
				elseif GetEntityHealth(PlayerPedId()) < 300 then
					SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 2)
				end
			end
		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function()
	while true do
		local time = 5000
		if bandagem then
			oldHealth = GetEntityHealth(PlayerPedId())
		end
		Citizen.Wait(time)
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE USAR BURFLEX
-----------------------------------------------------------------------------------------------------------------------------------------
local burflex = false
local tempoBurflex = 30 -- Metade do tempo da bandagem (15 segundos, considerando 500ms por ciclo)
local oldHealthBurflex = 0
local burflexAcumulado = 0.0  -- Variável para acumular os pontos de cura fracionados

function API.useBurflex()
    burflex = true
    tempoBurflex = 30
    oldHealthBurflex = GetEntityHealth(PlayerPedId())
    burflexAcumulado = 0.0
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        local waitTime = 500 -- Intervalo de 500ms

        if burflex then
            -- Cancelamento se a vida já estiver cheia
            if health >= 400 then
                tempoBurflex = 0
                burflex = false
                TriggerEvent("Notify", "negado", "<b>Você Não Pode Utilizar o [BURFLEX]</b> Pois Sua Vida Está Cheia.", 4000)
            -- Cancelamento se o tempo acabar
            elseif tempoBurflex <= 0 then
                tempoBurflex = 0
                burflex = false
                TriggerEvent("Notify", "negado", "<b>Seu Burflex acabou</b>", 5000)
            -- Cancelamento se a saúde estiver muito baixa ou o jogador estiver morto
            elseif health <= 101 then
                tempoBurflex = 0
                burflex = false
                TriggerEvent("Notify", "negado", "O Burflex Foi Cancelado pois Você morreu.", 4000)
            else
                if health < 400 then
                    -- Acumula a cura fracionada (70 pontos divididos por 25 ciclos ≈ 2,8 por ciclo)
                    burflexAcumulado = burflexAcumulado + (70 / 25)
                    local incremento = math.floor(burflexAcumulado)
                    if incremento > 0 then
                        SetEntityHealth(ped, math.min(health + incremento, 400))
                        burflexAcumulado = burflexAcumulado - incremento
                    end
                end
            end

            -- Reduz o tempo do efeito e atualiza a saúde anterior
            tempoBurflex = tempoBurflex - 1
            oldHealthBurflex = health
        end

        Citizen.Wait(waitTime)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("repairVehicle")
AddEventHandler("repairVehicle",function(index,status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			local fuel = GetVehicleFuelLevel(v)
			if status then
				SetVehicleFixed(v)
				SetVehicleDeformationFixed(v)
			end
			SetVehicleBodyHealth(v,1000.0)
			SetVehicleEngineHealth(v,1000.0)
			SetVehiclePetrolTankHealth(v,1000.0)
			SetVehicleFuelLevel(v,fuel)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCKPICKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:lockpickVehicle")
AddEventHandler("vrp_inventory:lockpickVehicle",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,true,true)
			if GetVehicleDoorsLockedForPlayer(v,PlayerId()) == 1 then
				SetVehicleDoorsLocked(v,false)
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLocked(v,true)
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
			Wait(200)
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
local blockButtons = false
function API.blockButtons(status)
	blockButtons = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if blockButtons then
			timeDistance = 4
			DisableControlAction(1,73,true)
			DisableControlAction(1,75,true)
			DisableControlAction(1,29,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,105,true)
			DisableControlAction(1,187,true)
			DisableControlAction(1,189,true)
			DisableControlAction(1,190,true)
			DisableControlAction(1,188,true)
			DisableControlAction(1,311,true)
			DisableControlAction(1,245,true)
			DisableControlAction(1,257,true)
			DisableControlAction(1,288,true)
			DisableControlAction(1,37,true)
			DisablePlayerFiring(PlayerPedId(),true)
		end
		Citizen.Wait(timeDistance)
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsEntityDead(playerPed) and not IsPedInAnyVehicle(playerPed, true) then
            SetPedDropsWeaponsWhenDead(playerPed, false)
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE ENERGETICO
-----------------------------------------------------------------------------------------------------------------------------------------
local energetico = false

function API.setEnergetico(status)
	if status then
		SetRunSprintMultiplierForPlayer(PlayerId(),1.30)
		energetico = true
	else
		SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
		RestorePlayerStamina(PlayerId(),1.0)
		energetico = false
	end
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE ENCHER A GARRAFA
-----------------------------------------------------------------------------------------------------------------------------------------
function API.checkFountain()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler"),true) or DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler_dark"),true) then
		return true,"fountain"
	end

	if IsEntityInWater(ped) then
		return true,"floor"
	end

	return false
end

function API.startAnimHotwired()
	while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
		RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
		Citizen.Wait(10)
	end
	TaskPlayAnim(PlayerPedId(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",3.0,3.0,-1,49,5.0,0,0,0)
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- SISTEMA DE ENCHER A GARRAFA
-----------------------------------------------------------------------------------------------------------------------------------------
function API.checkFountain()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler"),true) or DoesObjectOfTypeExistAtCoords(coords,0.7,GetHashKey("prop_watercooler_dark"),true) then
		return true,"fountain"
	end

	if IsEntityInWater(ped) then
		return true,"floor"
	end

	return false
end

function API.startAnimHotwired()
	while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
		RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
		Citizen.Wait(10)
	end
	TaskPlayAnim(PlayerPedId(),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",3.0,3.0,-1,49,5.0,0,0,0)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reparar')
AddEventHandler('reparar',function(vehicle)
	TriggerServerEvent("tryreparar",VehToNet(vehicle))
end)

RegisterNetEvent('repararMotor')
AddEventHandler('repararMotor',function(vehicle)
	TriggerServerEvent("tryrepararMotor",VehToNet(vehicle))
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				SetEntityAsMissionEntity(v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)

RegisterNetEvent('syncrepararMotor')
AddEventHandler('syncrepararMotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
                SetVehicleEngineHealth(v, 1000 + 0.0)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REPARAR PNEUS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('repararpneus')
AddEventHandler('repararpneus',function(vehicle)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryrepararpneus",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncrepararpneus')
AddEventHandler('syncrepararpneus',function(index)
	if NetworkDoesNetworkIdExist(index) then
        local v = NetToEnt(index)
        if DoesEntityExist(v) then
            for i = 0,8 do
                SetVehicleTyreFixed(v,i)
            end
        end
    end
end)


-- local isUsingOxygen = false
-- local oxygenEndTime = 0

-- RegisterNetEvent("applyOxygen")
-- AddEventHandler("applyOxygen", function(duration)
--     isUsingOxygen = true
--     oxygenEndTime = GetGameTimer() + duration

--     -- Cria uma thread para gerenciar o oxigênio
--     Citizen.CreateThread(function()
--         while isUsingOxygen do
--             Citizen.Wait(1000)

--             -- Calcula o tempo restante
--             local remainingTime = (oxygenEndTime - GetGameTimer()) / 1000

--             if remainingTime <= 0 then
--                 isUsingOxygen = false
--                 TriggerEvent("Notify", "importante", "Seu oxigênio acabou. Volte à superfície!", 5000)
--             else
--                 -- Aplica o tempo restante de oxigênio ao jogador
--                 SetPlayerUnderwaterTimeRemaining(PlayerId(), remainingTime)
--             end
--         end
--     end)
-- end)


local isUsingOxygen = false
local oxygenEndTime = 0

-- Função para iniciar o oxigênio
RegisterNetEvent("startOxygen")
AddEventHandler("startOxygen", function(duration)
    if isUsingOxygen then return end -- Impedir o uso de múltiplos cilindros ao mesmo tempo
    isUsingOxygen = true
    oxygenEndTime = GetGameTimer() + duration

    -- Tornar o jogador invencível ao afogamento
    SetEntityInvincible(PlayerPedId(), true)

    -- Criar uma thread para controlar o oxigênio
    Citizen.CreateThread(function()
        while isUsingOxygen do
            Citizen.Wait(1000) -- Verificar a cada segundo
            local remainingTime = (oxygenEndTime - GetGameTimer()) / 1000

            if remainingTime <= 0 then
                isUsingOxygen = false

                -- Tornar o jogador vulnerável novamente
                 SetEntityInvincible(PlayerPedId(), false)
                TriggerEvent("Notify", "importante", "Seu oxigênio acabou. Volte à superfície!", 5000)
            end
        end
    end)
end)

-- Para quando o player morre
AddEventHandler('onPlayerDied', function()
   isUsingOxygen = false
   SetEntityInvincible(PlayerPedId(), false)
end)



-- 187