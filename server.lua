-- Créé par Meliodassge

local MySQL = require('mysql-async')

RegisterServerEvent('vehicleStorage:load')
AddEventHandler('vehicleStorage:load', function(vehicleId, playerId)
    local src = source

    MySQL.Async.fetchAll('SELECT item_name, item_count FROM vehicle_storage WHERE vehicle_id = @vehicle_id AND owner = @owner', {
        ['@vehicle_id'] = vehicleId,
        ['@owner'] = playerId
    }, function(result)
        local items = {}

        for _, row in ipairs(result) do
            table.insert(items, {name = row.item_name, count = row.item_count})
        end

        TriggerClientEvent('vehicleStorage:receive', src, items)
    end)
end)

RegisterServerEvent('vehicleStorage:save')
AddEventHandler('vehicleStorage:save', function(vehicleId, playerId, storage)
    MySQL.Async.execute('DELETE FROM vehicle_storage WHERE vehicle_id = @vehicle_id AND owner = @owner', {
        ['@vehicle_id'] = vehicleId,
        ['@owner'] = playerId
    })

    for _, item in ipairs(storage) do
        MySQL.Async.execute('INSERT INTO vehicle_storage (vehicle_id, owner, item_name, item_count) VALUES (@vehicle_id, @owner, @item_name, @item_count)', {
            ['@vehicle_id'] = vehicleId,
            ['@owner'] = playerId,
            ['@item_name'] = item.name,
            ['@item_count'] = item.count
        })
    end
end)

RegisterServerEvent('vehicleStorage:stockerObjet')
AddEventHandler('vehicleStorage:stockerObjet', function(nomObjet, quantite)
    local src = source
    local playerId = GetPlayerServerId(src)
    local vehiculeId = VehToNet(GetVehiclePedIsIn(GetPlayerPed(src), false))

    MySQL.Async.execute('INSERT INTO vehicle_storage (vehicle_id, owner, item_name, item_count) VALUES (@vehicle_id, @owner, @item_name, @item_count)', {
        ['@vehicle_id'] = vehiculeId,
        ['@owner'] = playerId,
        ['@item_name'] = nomObjet,
        ['@item_count'] = quantite
    })
end)
