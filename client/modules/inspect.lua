

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
    
    local ped = PlayerId()
        print('SOMMMMMMMMMMMMMMMMMMMMMMMM', player)
        --  PlaySoundFrontend(player, "ARMOR_PICKUP", "HUD_MINI_GAME_SOUNDSET", true)
        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
      



   
end)