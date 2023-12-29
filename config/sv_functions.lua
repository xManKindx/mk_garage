function hasPropertyKeys(garageData)
    ---@param garageData table: {name string, label string, garageType string, vehicleType string}

    if not garageData then return false end
    local src = source 

    if GetResourceState('qb-houses') == 'started' then 
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
        if Framework == 'QBCORE' then 
            if QBCore then 
                local player = QBCore.Functions.GetPlayer(src)
                if player?.PlayerData then 
                    return exports['qs-housing']:hasKey(player.PlayerData.license, player.PlayerData.citizenid, garageData.name)
                else
                    return false 
                end
            end
        else --esx
            return false 
        end
    else
        return false
    end
end

function customAuth(garageData)
    ---@param garageData table: {name string, label string, garageType string, vehicleType string}
    local src = source 
    
    return false
end

function societyWithraw(jobName, amount)
    ---@param jobName string job name
    ---@param amount number amount to withdraw

    local balance, newBalance = 0, 0
    local query, params 

    local balance = getSocietyBalance(jobName)

    if balance >= amount then 
        newBalance = math.ceil(balance - amount)

        if Framework == 'QBCORE' then 
            query = "UPDATE management_funds SET amount = ? WHERE `job_name` = ? AND `type` = ?"
            params = {newBalance, jobName, 'boss'}
        elseif Framework == 'ESX' then 
            query = "UPDATE addon_account_data SET money = ? WHERE account_name = ?"
            params = {newBalance, 'society_'..jobName}
        end

        local withdrawResult = MySQL.update.await(query, params)
        if withdrawResult then 
            return true --successful withraw
        else
            return false --failed
        end
    else
        return false 
    end
end

function getSocietyBalance(jobName)
    ---@param jobName string job name 
    
    local balance = 0
    local query, params 

    if Framework == 'QBCORE' then 
        query = "SELECT amount FROM management_funds WHERE `job_name` = ? AND `type` = ?"
        params = { jobName, 'boss'}
    elseif Framework == 'ESX' then 
        query = "SELECT money FROM addon_account_data WHERE account_name = ?"
        params = {'society_'..jobName}
    end

    local result = MySQL.query.await(query, params)
    if result and result[1] then 
        if result[1].amount then --qbcore
            balance = tonumber(result[1].amount)
        elseif result[1].money then --esx
            balance = tonumber(result[1].money)
        end 
    end

    return balance
end