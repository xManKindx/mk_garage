function hasPropertyKeys(garageData)
    ---@param garageData table: {name string, label string, garageType string, vehicleType string}

    return false
end

function customAuth(garageData)
    ---@param garageData table: {name string, label string, garageType string, vehicleType string}

    return false
end

function hasKeys(vehicle, plate, fakePlate)
    ---@param vehicle number vehicle entity id
    ---@param plate string vehicle plate 
    ---@param fakePlate string or false fake plate if vehicle has one

    if GetResourceState('mk_vehiclekeys') == 'started' then 
        return exports['mk_vehiclekeys']:HasKey(vehicle)
    elseif GetResourceState('qb-vehiclekeys') == 'started' then
        if fakePlate then
            return exports['qb-vehiclekeys']:HasKeys(fakePlate)
        else
            return exports['qb-vehiclekeys']:HasKeys(plate)
        end
    else
        --custom check
        return false
    end
end

function giveKeys(vehicle, plate, fakePlate)
    ---@param vehicle number vehicle entity id
    ---@param plate string vehicle plate 
    ---@param fakePlate string or false fake plate if vehicle has one

    if GetResourceState('mk_vehiclekeys') == 'started' then 
        exports['mk_vehiclekeys']:AddKey(vehicle)
    elseif GetResourceState('qb-vehiclekeys') == 'started' then 
        if fakePlate then
            TriggerEvent('vehiclekeys:client:SetOwner', fakePlate)
        else
            TriggerEvent('vehiclekeys:client:SetOwner', plate)
        end
    else
        --custom give keys
    end
end

function getFuel(vehicle)
    ---@param vehicle number vehicle entity id

    if GetResourceState('LegacyFuel') == 'started' then 
        return exports['LegacyFuel']:GetFuel(vehicle)
    elseif GetResourceState('ox_fuel') == 'started' then 
        return Entity(vehicle).state.fuel 
    else
        --custom fuel check
        return 50
    end
end

function setFuel(vehicle, level)
    ---@param vehicle number vehicle entity id
    ---@param level number fuel level to set

    if GetResourceState('LegacyFuel') == 'started' then 
        exports['LegacyFuel']:SetFuel(vehicle, level)
    elseif GetResourceState('ox_fuel') == 'started' then 
        Entity(vehicle).state:set('fuel', level, true)
    else 
        --custom fuel set
    end 
end

function getMods(vehicle)
    ---@param vehicle number vehicle entity id

    return lib.getVehicleProperties(vehicle)
end

function setMods(vehicle, mods, plate, fakePlate)
    ---@param vehicle number vehicle entity id
    ---@param mods table vehicle mods
    ---@param plate string vehicle plate 
    ---@param fakePlate string or false fake plate if vehicle has one

    if fakePlate then 
        mods.plate = fakePlate 
        lib.setVehicleProperties(vehicle, mods)
    else
        lib.setVehicleProperties(vehicle, mods)
    end
end

function getVehicleClassIcon(class)
    ---@param class number vehicle class

    local icon = 'car-side'
    if class then 
        if class == 8 then 
            icon = 'motorcycle'
        elseif class == 9 then 
            icon = 'truck-monster'
        elseif class == 12 then 
            icon = 'van-shuttle'
        elseif class == 13 then 
            icon = 'bicycle'
        elseif class == 14 then 
            icon = 'sailboat'
        elseif class == 15 then 
            icon = 'helicopter'
        elseif class == 16 then 
            icon = 'plane'
        end
    end

    return icon
end

function jobGarageAuth(jobName, vehicleName, vehicleModel, playerData)
    ---@param jobName string job name
    ---@param vehicleName string vehicle spawn code
    ---@param vehicleModel number vehicle model number
    ---@param playerData table player data for client to check
    
    if vehicleName == 'polmav' then 
        --license check?
    end

    return true
end