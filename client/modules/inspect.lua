

function API.openInspect(data)
    SendNUIMessage({
        route = "OPEN_INSPECT",
        payload = data
    })
    SetNuiFocus(true,true)
end

--TODO: paste carry function
function API.toggleCarry(target)

end

RegisterNetEvent('body_armor_vest')
AddEventHandler('body_armor_vest',function (source)
    
    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
      
end)


RegisterNetEvent("getNearestVehicleInfo")
AddEventHandler("getNearestVehicleInfo", function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)

    if DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        local model = GetEntityModel(vehicle)
        local netId = VehToNet(vehicle)
        local locked = GetVehicleDoorLockStatus(vehicle)
        
        -- print("🚗 Veículo encontrado: Placa:", plate, "Modelo:", model, "NetID:", netId, "Locked:", locked)
        -- Envia as informações para o servidor
        TriggerServerEvent("receiveVehicleInfo", plate, model, netId, locked)
    else
        print("⚠ Nenhum veículo próximo encontrado.")
        TriggerServerEvent("receiveVehicleInfo", nil, nil, nil, nil)
    end
end)


RegisterNetEvent("unlockVehicle")
AddEventHandler("unlockVehicle", function(netId)
    local vehicle = NetToVeh(netId)

    if DoesEntityExist(vehicle) then
        print("🔓 Tentando destrancar veículo com Network ID:", netId)
        SetVehicleDoorsLocked(vehicle, 1) -- Destranca o veículo
        TriggerEvent("vrp_sounds:source", "lock", 0.1)
        TriggerEvent("Notify", "sucesso", "Você destrancou o veículo!", 6000)
    else
        -- print("❌ Erro ao tentar destrancar o veículo! Network ID inválido. Tentando destrancar pelo método alternativo.")
        
        -- Alternativa: Destrancar veículo mais próximo se netId for inválido
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 71)

        if DoesEntityExist(vehicle) then
            print("🔓 Método alternativo: Destrancando veículo mais próximo.")
            SetVehicleDoorsLocked(vehicle, 1)
            TriggerEvent("vrp_sounds:source", "lock", 0.1)
            TriggerEvent("Notify", "sucesso", "Você destrancou o veículo!", 6000)
        else
            print("❌ Nenhum veículo encontrado para destrancar.")
            TriggerEvent("Notify", "negado", "Nenhum veículo encontrado para destrancar.", 6000)
        end
    end
end)


RegisterNetEvent("SetAsNoLongerOwned")
AddEventHandler("SetAsNoLongerOwned", function(vehNet)
    local veh = NetToVeh(vehNet)
    if DoesEntityExist(veh) then
        SetVehicleAsNoLongerNeeded(veh) -- Remove a propriedade do jogador anterior
    end
end)
