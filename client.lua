-- Créé par Meliodassge

local stockageBoiteGants = {}
local capaciteMax = 10
local boiteGantsOuverte = false

function ChargerStockageVehicule(vehicule)
    local vehicleId = VehToNet(vehicule)
    local playerId = GetPlayerServerId(PlayerId())

    TriggerServerEvent('vehicleStorage:load', vehicleId, playerId)
end

function SauvegarderStockageVehicule(vehicule)
    local vehicleId = VehToNet(vehicule)
    local playerId = GetPlayerServerId(PlayerId())

    TriggerServerEvent('vehicleStorage:save', vehicleId, playerId, stockageBoiteGants)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicule = GetVehiclePedIsIn(playerPed, false)

        if vehicule ~= 0 then
            if not stockageBoiteGants[vehicule] then
                ChargerStockageVehicule(vehicule)
            end

            if IsPedInAnyVehicle(playerPed, false) and not IsVehicleOnAllWheels(vehicule) then
                SauvegarderStockageVehicule(vehicule)
            end
        end
    end
end)

function AjouterObjetDansBoiteAGants(nomObjet, quantite)
    local objetTrouve = false

    for _, objet in ipairs(stockageBoiteGants) do
        if objet.name == nomObjet then
            objet.count = objet.count + quantite
            objetTrouve = true
            break
        end
    end

    if not objetTrouve then
        table.insert(stockageBoiteGants, {name = nomObjet, count = quantite})
    end
end

function AfficherMenuBoiteAGants(objets)
    local elements = {}

    for _, objet in ipairs(objets) do
        table.insert(elements, {
            label = objet.name .. " x" .. objet.count,
            value = objet.name,
            type = "slider",
            min = 1,
            max = objet.count,
            value = 1
        })
    end

    exports['ox_lib']:registerMenu({
        id = 'menu_boite_gants',
        title = "Boîte à Gants",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local nomObjet = data.value
        local quantite = data.value

        TriggerServerEvent('vehicleStorage:stockerObjet', nomObjet, quantite)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end