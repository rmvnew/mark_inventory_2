-- local NEAR_SHOP = false

-- local function ParseItems(items) 
--     local response = {}
--     local count = 0
--     for k,v in pairs(items) do
--         count += 1 
--         response[tostring(count)] = {
--             price = items[k],
--             item = k,
--             slot = tostring(count)
--         }
--     end
--     return response
-- end
-- CreateThread(function() 
--     for k,v in pairs(Shops) do 
--         Shops[k].items = ParseItems(v.items)
--     end
--     SearchShopThread()
-- end)

-- function SearchShopThread()
--     CreateThread(function() 
--         while not NEAR_SHOP do 
--             local sleep = 1002
--             local ply       = PlayerPedId()
--             local plyCds    = GetEntityCoords(ply)
--             for k,v in pairs(Shops) do
--                 for i = 1, #v.coords do
--                     local distance = #(plyCds - v.coords[i])
--                     if distance < 7.0 then
--                         NEAR_SHOP = true
--                         NearShopThread(k, i)
--                     end
--                 end
--             end
--             Wait(sleep)
--         end
--     end)
-- end


-- function NearShopThread(store, coordIndex)
--     CreateThread(function()
--         while NEAR_SHOP do
--             local sleep = 4
--             local ply = PlayerPedId()
--             local plyCds = GetEntityCoords(ply)
--             local distance = #(plyCds - Shops[store].coords[coordIndex])
--             if distance > 7.0 or (GetEntityHealth(PlayerPedId()) <= 101) then
--                 CloseShop()
--                 break
--             end 
--             DrawMarker(29, Shops[store].coords[coordIndex].x,Shops[store].coords[coordIndex].y,Shops[store].coords[coordIndex].z-0.4, 0, 0, 0, 0, 180.0, 0, 0.7, 0.7, 0.7, 255, 255, 255, 75, 1, 0, 0, 1)
--             if distance <= 1.3 then
--                 if IsControlJustPressed(0, 38) then
--                     print("near shop!")
--                     print("SHOP ID: "..coordIndex.." TYPE: "..store)
--                     if (not Shops[store].perm or Remote.checkPermission(Shops[store].perm)) then 
--                         SendNUIMessage({
--                             route = "OPEN_SHOP",
--                             payload = {
--                                 mode = Shops[store].mode, -- buy|sell
--                                 store_name = store, -- buy|sell
--                                 inventory = Shops[store].items, -- [item: string] = price;
--                             }
--                         })
--                         SetNuiFocus(true,true)
--                     end  
--                 end
--             end
--             Wait(sleep)
--         end
--     end)
-- end

-- CloseShop = function()
--     NEAR_SHOP = false
--     SearchShopThread()

--     SendNUIMessage({
--         route = "CLOSE_INVENTORY",
--         payload = false
--     })
--     SetNuiFocus(false,false)
-- end 


-- local NEAR_SHOP = false

-- local function ParseItems(items) 
--     local response = {}
--     local count = 0
--     for k, v in pairs(items) do
--         count += 1
--         response[tostring(count)] = {
--             price = v,
--             item = k,
--             slot = tostring(count)
--         }
--     end
--     return response
-- end

-- CreateThread(function() 
--     for k, v in pairs(Shops) do 
--         Shops[k].items = ParseItems(v.items)
--     end
--     SearchShopThread()
-- end)

-- function DrawText3D(x, y, z, text)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)
--     if onScreen then
--         SetTextScale(0.35, 0.35)
--         SetTextFont(4)
--         SetTextProportional(1)
--         SetTextColour(255, 255, 255, 215)
--         SetTextDropShadow()
--         SetTextEntry("STRING")
--         SetTextCentre(1)
--         AddTextComponentString(text)
--         DrawText(_x, _y)
--     end
-- end

-- function SearchShopThread()
--     CreateThread(function() 
--         while not NEAR_SHOP do 
--             local sleep = 250  -- Verificação mais rápida
--             local ply = PlayerPedId()
--             local plyCds = GetEntityCoords(ply)

--             for k, v in pairs(Shops) do
--                 for i = 1, #v.coords do
--                     local distance = #(plyCds - v.coords[i])
--                     if distance < 7.0 then
--                         NEAR_SHOP = true
--                         NearShopThread(k, i)
--                     end
--                 end
--             end
--             Wait(sleep)
--         end
--     end)
-- end

-- function NearShopThread(store, coordIndex)
--     CreateThread(function()
--         while NEAR_SHOP do
--             local sleep = 4
--             local ply = PlayerPedId()
--             local plyCds = GetEntityCoords(ply)
--             local distance = #(plyCds - Shops[store].coords[coordIndex])

--             if distance > 7.0 or (GetEntityHealth(PlayerPedId()) <= 101) then
--                 CloseShop()
--                 break
--             end 

--             -- Marker de loja
--             DrawMarker(29, Shops[store].coords[coordIndex].x, Shops[store].coords[coordIndex].y, Shops[store].coords[coordIndex].z - 0.4, 0, 0, 0, 0, 180.0, 0, 0.7, 0.7, 0.7, 255, 255, 255, 75, 1, 0, 0, 1)
            
--             -- Texto interativo
--             if distance <= 1.3 then
--                 DrawText3D(Shops[store].coords[coordIndex].x, Shops[store].coords[coordIndex].y, Shops[store].coords[coordIndex].z, "[E] Acessar a Loja")

--                 -- Abrir loja ao pressionar E
--                 if IsControlJustPressed(0, 38) then
--                     print("Entrando na loja!")  -- Debug
--                     if (not Shops[store].perm or Remote.checkPermission(Shops[store].perm)) then 
--                         SendNUIMessage({
--                             route = "OPEN_SHOP",
--                             payload = {
--                                 mode = Shops[store].mode,
--                                 store_name = store,
--                                 inventory = Shops[store].items
--                             }
--                         })
--                         SetNuiFocus(true, true)
--                     end  
--                 end
--             end
--             Wait(sleep)
--         end
--     end)
-- end

-- CloseShop = function()
--     NEAR_SHOP = false
--     SearchShopThread()

--     SendNUIMessage({
--         route = "CLOSE_INVENTORY",
--         payload = false
--     })
--     SetNuiFocus(false, false)
-- end




local NEAR_SHOP = false

local function ParseItems(items) 
    local response = {}
    local count = 0
    for k, v in pairs(items) do
        count += 1
        response[tostring(count)] = {
            price = v,
            item = k,
            slot = tostring(count)
        }
    end
    return response
end

CreateThread(function() 
    for k, v in pairs(Shops) do 
        Shops[k].items = ParseItems(v.items)
    end
    SearchShopThread()
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function SearchShopThread()
    CreateThread(function() 
        while true do  
            local sleep = 250  -- Verificação mais rápida
            local ply = PlayerPedId()
            local plyCds = GetEntityCoords(ply)
            local foundShop = false

            for k, v in pairs(Shops) do
                for i = 1, #v.coords do
                    local distance = #(plyCds - v.coords[i])
                    if distance < 7.0 then
                        foundShop = true
                        if not NEAR_SHOP then
                            NEAR_SHOP = true
                            NearShopThread(k, i)
                        end
                    end
                end
            end

            if not foundShop then
                NEAR_SHOP = false
            end

            Wait(sleep)
        end
    end)
end

function NearShopThread(store, coordIndex)
    CreateThread(function()
        while NEAR_SHOP do
            local sleep = 4000
            local ply = PlayerPedId()
            local plyCds = GetEntityCoords(ply)
            local mCoods = Shops[store].coords[coordIndex]
            local distance = #(plyCds - mCoods)

            if distance > 4.0 or (GetEntityHealth(PlayerPedId()) <= 101) then
                CloseShop()
                break
            else    
                sleep = 4
                
                -- Abrir loja ao pressionar E
                if distance <= 1.3 then
                   
                    -- Marker de loja
                    DrawMarker(29, mCoods.x, mCoods.y, mCoods.z - 0.4, 0, 0, 0, 0, 180.0, 0, 0.7, 0.7, 0.7, 0, 255, 0, 75, 1, 0, 0, 1)
                    
                    -- Texto interativo
                    DrawText3D(mCoods.x, mCoods.y,mCoods.z, "[E] Acessar a Loja!!")
                    if IsControlJustPressed(0, 38) then
                        print("Entrando na loja!")  -- Debug
                        if (not Shops[store].perm or Remote.checkPermission(Shops[store].perm)) then 
                            SendNUIMessage({
                                route = "OPEN_SHOP",
                                payload = {
                                    mode = Shops[store].mode,
                                    store_name = store,
                                    inventory = Shops[store].items
                                }
                            })
                            SetNuiFocus(true, true)
                        end  
                    end
                else
                    -- Marker de loja
                    DrawMarker(28, mCoods.x,mCoods.y, mCoods.z + 0.3, 0, 0, 0, 0, 180.0, 0, 0.05, 0.05, 0.05, 50, 150, 255, 160, 0, 0, 0, 0)
                   
                end
                
            end 


            Wait(sleep)
        end
    end)
end

CloseShop = function()
    NEAR_SHOP = false

    SendNUIMessage({
        route = "CLOSE_INVENTORY",
        payload = false
    })
    SetNuiFocus(false, false)
end