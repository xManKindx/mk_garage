---@param garageData { name: string, label: string, garageType: string, vehicleType: string }
function hasPropertyKeys(garageData)
    if not garageData then return false end
    local src = source 

    if GetResourceState('qb-houses') == 'started' then 
        if not QBCore then QBCore = exports['qb-core']:GetCoreObject() end
        if QBCore then 
            local player = QBCore.Functions.GetPlayer(src)
            if player?.PlayerData then 
                return exports['qb-houses']:hasKey(player.PlayerData.license, player.PlayerData.citizenid, garageData.name)
            else
                return false 
            end
        end
    elseif GetResourceState('ps-housing') == 'started' then 
        return exports['ps-housing']:IsOwner(src, garageData.name)
    elseif GetResourceState('qs-housing') == 'started' then 
        if GetResourceState('qb-core') == 'started' then 
            if not QBCore then QBCore = exports['qb-core']:GetCoreObject() end
            if QBCore then 
                local player = QBCore.Functions.GetPlayer(src)
                if player?.PlayerData then 
                    return exports['qs-housing']:hasKey(player.PlayerData.license, player.PlayerData.citizenid, garageData.name)
                else
                    return false 
                end
            end
        else --other framework
            return false 
        end
    else
        return false
    end
end

---@param garageData { name: string, label: string, garageType: string, vehicleType: string }
function customAuth(garageData)
    local src = source 
    
    return false
end