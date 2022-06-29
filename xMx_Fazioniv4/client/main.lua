ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
        for k,v in pairs(Fazioni) do
            TriggerEvent('gridsystem:registerMarker', {
                name = 'bossmenu'..k,
                pos = v.bossmenu,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'Premi ~INPUT_CONTEXT~ per accedere al menu boss',
                control = 'E',
                type = 20,
                color = { r = 100, g = 0, b = 255 },
                action = function()
                    local gradoJob = v.grade or 0
                    if gradoJob <= ESX.PlayerData.job.grade then
                    TriggerEvent(v.triggerboss, k, 'MENU BOSS')
                    else
                        ESX.ShowNotification('Non sei boss')
                    end
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
            TriggerEvent('gridsystem:registerMarker', {
                name = 'deposito'..k,
                pos = v.deposito,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'Premi ~INPUT_CONTEXT~ per accedere al deposito',
                control = 'E',
                type = 20,
                color = { r = 100, g = 0, b = 255 },
                action = function()
                    local gradoJob = v.grade or 0
                    if gradoJob <= ESX.PlayerData.job.grade then
                    if v.bloccopin == true then
                        if IsControlJustReleased(0,51) then
                            AddTextEntry("FMMC_KEY_TIP1", "Inserisci il Codice")
                            DisplayOnscreenKeyboard(6, "FMMC_KEY_TIP1", "", "", "", "", "", 6)
                            while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
                                Citizen.Wait(0)
                            end
                            if UpdateOnscreenKeyboard() ~= 2 then
                                local result = GetOnscreenKeyboardResult()
                                if result == v.pin then
                                    PlaySoundFrontend(-1, "Drill_Pin_Break", 'DLC_HEIST_FLEECA_SOUNDSET', 1);
                                    exports.ox_inventory:openInventory('stash', {id=k})
                                end
                                ESX.ShowNotification("Codice inserito correttamente")
                            else
                                ESX.ShowNotification("Codice errato")
                            end
                        end
                    else
                        if v.bloccopin == false then
                            exports.ox_inventory:openInventory('stash', {id=k})
                        end 
                    end
                else
                    ESX.ShowNotification('Non sei autorizzato')
                end
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
            TriggerEvent('gridsystem:registerMarker', {
                name = 'Shop'..k,
                pos = v.ShopPos,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'Premi ~INPUT_CONTEXT~ per accedere allo shop',
                control = 'E',
                type = 20,
                color = { r = 100, g = 0, b = 255 },
                action = function()
                    ApriBar(k)
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
            if v.moneywash.abilitato then
            TriggerEvent('gridsystem:registerMarker', {
                name = 'Moneywash'..k,
                pos = v.moneywashPos,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'Premi ~INPUT_CONTEXT~ per pulire i soldi',
                control = 'E',
                type = 20,
                color = { r = 100, g = 0, b = 255 },
                action = function()
                    PulisciSoldi(k, v.moneywash.percentuale)
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
            TriggerEvent('gridsystem:registerMarker', {
                name = 'garage'..k,
                pos = v.garage.pos,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'premi E per garage',
                control ='E',
                type = 20,
                color = { r = 255, g = 255, b = 255 },
                action = function()
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        ApriGarage(v.job)
                    end
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
            TriggerEvent('gridsystem:registerMarker', {
                name = 'garagedespawn'..k,
                pos = v.garage.spawn,
                scale = vector3(0.5,0.5,0.5),
                permission = k,
                msg = 'premi E per garage',
                control ='E',
                type = 20,
                color = { r = 255, g = 255, b = 255 },
                action = function()
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                        ESX.ShowNotification('Veicolo depositato con successo')
                    else
                        ESX.ShowNotification('Non sei in un veicolo', 'error')
                    end
                end,
                onExit = function()
                    ESX.UI.Menu.CloseAll()
                end
            })
        end
    end
end)

   -- garage

   function ApriGarage(job)
    for k,v in pairs(Fazioni) do
        if v.job == job then
            local elements = v.garage.vehicles
            if #elements == 0 then
                table.insert(elements,{label = 'Veicoli non Disponibili',value = 'null'})
            end
            ESX.UI.Menu.Open('default',GetCurrentResourceName(),'garage_fazioni',
            { 
            title = 'Garage', 
            align = 'bottom-right', 
            elements = elements 
            }, function(data, menu)
                if data.current.value ~= 'null' and data.current.model ~= nil then
                    menu.close()
                    if ESX.Game.IsSpawnPointClear(v.garage.spawn, 3.5) then
                        ESX.Game.SpawnVehicle(data.current.model, v.garage.spawn, v.garage.heading, function(vehicle)
                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        end)
                    else   
                        ESX.ShowNotification('Il punto di spawn é occupato', 'error')
                    end
                end
            end, function(data, menu) 
                menu.close() 
            end)
        end
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(Fazioni) do
        if v.blip.abilitato then
            local blipfazioni = AddBlipForCoord(v.blip.pos)
            SetBlipSprite(blipfazioni, v.blip.id)
            SetBlipDisplay(blipfazioni, 4)
            SetBlipScale(blipfazioni, v.blip.grandezza)
            SetBlipColour(blipfazioni, v.blip.colore)
            SetBlipAsShortRange(blipfazioni, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.nome)
            EndTextCommandSetBlipName(blipfazioni)
        end
    end
end)

ApriBar = function(job)
    for k,v in pairs(Fazioni) do
        if k == job then
            if v.Shop.abilitato then
            local gradoJob = v.Shop.grade or 0
            if gradoJob <= ESX.PlayerData.job.grade then
                if v.Shop.items ~= nil then
                    local elements = v.Shop.items
                    if #elements == 0 then
                        table.insert(elements, {label = 'Lo shop é vuoto', item = 'null'} )
                    end
                    ESX.UI.Menu.Open('default',GetCurrentResourceName(),'bar_fazione',
                    { 
                    title = 'Shop Aziendale', 
                    align = 'top', 
                    elements = elements 
                    }, function(data, menu)
                        if data.current.item ~= 'null' and data.current.item ~= nil then
                            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'count_shop', {
                                title = 'Inserisci il numero di pezzo'
                            }, function(dataCount, menuCount)
                                local countItem = tonumber(dataCount.value)
                                if countItem ~= nil and countItem ~= 0 and countItem > 0 then
                                    menuCount.close()
                                    TriggerServerEvent('xMx_fazioni:shoplocale', data.current.item, tonumber(data.current.price), k, countItem)
                                else
                                    ESX.ShowNotification('Inserisci un valore valido','error')
                                end
                            end, function(dataCount, menuCount)
                                menuCount.close()
                            end)
                        end
                    end, function(data, menu) 
                        menu.close() 
                    end)
                end
            else
                ESX.ShowNotification('Contatta un superiore per comprare!', 'warning')
            end
        else
            ESX.ShowNotification('Contatta uno staffer per comprare pacchetto shop!', 'warning')
        end
    end
    end
end

function PulisciSoldi(society, perc)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pulisci_soldi', {
        title = 'Inserisci il valore da pulire'
    }, function(data, menu)
        local amount = tonumber(data.value)
        if amount ~= nil and amount ~= 0 and amount > 0 then
            menu.close()
            TriggerServerEvent('xMx_fazioni:whsmny', society, amount, perc)
        else
            ESX.ShowNotification('Inserisci un valore valido','error')
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterCommand('_CreaFattura',function()
    for k, v in pairs(Fazioni) do
        if k == ESX.PlayerData.job.name then
            RegisterKeyMapping('_CreaFattura','Crea Fattura','KEYBOARD', v.Fattura.pulsante)
            Fattura ()
        end
    end
end)


function Fattura ()
    for k, v in pairs(Fazioni) do
        if k == ESX.PlayerData.job.name then
            if v.Fattura.abilitato then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pulisci_soldi', {
                        title = 'Inserisci il valore'
                    }, function(data, menu)
                        local amount = tonumber(data.value)
                        if amount ~= nil and amount ~= 0 and amount > 0 then
                            menu.close()
                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_'..ESX.PlayerData.job.name, 'Fattura '..ESX.PlayerData.job.label..'', amount)
                        else
                            ESX.ShowNotification('Inserisci un valore valido','error')
                        end
                    end, function(data, menu)
                        menu.close()
                    end)
                else
                    ESX.ShowNotification('Nessun player vicino', 'error')
                end
            end
        end   
    end
end

