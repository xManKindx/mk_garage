---@param garageData { name: string, label: string, garageType: string, vehicleType: string }
function hasPropertyKeys(garageData)

    return false
end

---@param garageData { name: string, label: string, garageType: string, vehicleType: string }
function customAuth(garageData)

    return false
end

---@param vehicle number vehicle entity id
---@param plate string vehicle plate 
---@param fakePlate string|boolean fake plate if vehicle has one or false
function hasKeys(vehicle, plate, fakePlate)
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

---@param vehicle number vehicle entity id
---@param plate string vehicle plate 
---@param fakePlate string|boolean fake plate if vehicle has one or false
function giveKeys(vehicle, plate, fakePlate)
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

---@param vehicle number vehicle entity id
function getFuel(vehicle)
    if GetResourceState('LegacyFuel') == 'started' then 
        return exports['LegacyFuel']:GetFuel(vehicle)
    elseif GetResourceState('ox_fuel') == 'started' then 
        return Entity(vehicle).state.fuel 
    elseif GetResourceState('cdn-fuel') == 'started' then 
        return exports['cdn-fuel']:GetFuel(vehicle)
    else
        --custom fuel check
        return 50
    end
end

---@param vehicle number vehicle entity id
---@param level number fuel level to set
function setFuel(vehicle, level)
    if GetResourceState('LegacyFuel') == 'started' then 
        exports['LegacyFuel']:SetFuel(vehicle, level)
    elseif GetResourceState('ox_fuel') == 'started' then 
        Entity(vehicle).state:set('fuel', level, true)
    elseif GetResourceState('cdn-fuel') == 'started' then 
        exports['cdn-fuel']:SetFuel(vehicle, level)
    else 
        --custom fuel set
    end 
end

---@param vehicle number vehicle entity id
function getMods(vehicle)
    return lib.getVehicleProperties(vehicle)
end

---@param vehicle number vehicle entity id
---@param mods table vehicle mods
---@param plate string vehicle plate 
---@param fakePlate string|boolean fake plate if vehicle has one or false
function setMods(vehicle, mods, plate, fakePlate)
    if fakePlate then 
        mods.plate = fakePlate 
        lib.setVehicleProperties(vehicle, mods)
    else
        lib.setVehicleProperties(vehicle, mods)
    end
end

---@param class number vehicle class
function getVehicleClassIcon(class)
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

---@param jobName string job name
---@param vehicleName string vehicle spawn code
---@param vehicleModel number vehicle model number
---@param playerData table player data for client to check
function jobGarageAuth(jobName, vehicleName, vehicleModel, playerData)
    if vehicleName == 'polmav' then 
        --license check?
    end

    return true
end