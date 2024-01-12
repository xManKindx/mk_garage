Config = {}

Config.ConsoleLogging = true --TRUE DISPLAYS SCRIPT LOGGING INFO IN F8 AND SERVER CONSOLE

Config.Notify = { 
    UseCustom = false, --FALSE = DEFAULT NOTIFY WILL BE YOUR FRAMEWORKS NOTIFY SYSTEM (QBCore:Notify / esx:showNotification) / TRUE = CUSTOM NOTIFY SCRIPT (OX_LIB / T-NOTIFY / ECT)
    CustomClientNotifyFunction = function(data) --**CLIENT SIDE CODE**
        ---@param data table: { message string, type string, duration number }

        --TriggerEvent('QBCore:Notify', data.message, data.type, data.duration) --QBCORE EXAMPLE
    end,
    CustomServerNotifyFunction = function(playerSource, data) --**SERVER SIDE CODE** SAME AS ABOVE EXCEPT PASSES THE SOURCE TO SEND THE NOTIFICATION TO FROM THE SERVER
        ---@param playerSource number Server id of the player
        ---@param data table: { message string, type string, duration number }

        --TriggerClientEvent('QBCore:Notify', playerSource, data.message, data.type, data.duration) --QBCORE EXAMPLE
    end
}

Config.OnlyOwnerCanStore = false --if false anyone with keys can store vehicle

Config.DrivingDistanceColumn = 'drivingdistance' --column inside (player_vehicles / owned_vehicles) that contains vehicle driving distance

Config.EnableVehicleTracker = true --vehicles taken out of the garage can be tracked unless tracker is removed via export

Config.StoreFakePlates = true --allow to store vehicle with fakeplate
Config.FakePlateColumn = 'fakeplate' --column inside (player_vehicles / owned_vehicles) that contains fakeplate string

Config.UniqueGarages = true --can only retrieve vehicles from the (public) garage they were stored in. set false to retrieve vehicles stored in a public garage from any public garage

Config.WarpIntoVehicle = true --warp into driver seat when vehicle spawns

Config.StoreOutsideVehiclesOnRestart = true --any vehicle not marked as stored will be set back into its garage on server restart
Config.DefaultGarage = 'legion' --default garage to set a vehicle to if its last garage is not found
Config.ImpoundOnRestart = false --vehicles left out on the street will be sent to impound on server restart
Config.DefaultImpoundGarage = 'state_impound' --impound garage to send vehicles to if impounded on server restart
Config.DefaultImpoundFee = 250 --fee to retreive vehicle from impound if it gets impounded on server restart

Config.ClipboardCoords = false --relevant player coordinates will be copied to your clipboard when creating/editing a garage

Config.ImpoundCommand = {
    Enable = true, --use command to impound
    CommandName = 'impound',
    AllowedJobs = {
        'police',
    }
}

Config.ImpoundReleaseJobs = { --jobs that can pull vehicles from impound
    'police'
}

Config.AddGarageCommand = {
    CommandName = 'addgarage',
    AllowedGroups = {
        'admin',
    },
}

Config.EditGarageCommand = {
    CommandName = 'editgarage',
    AllowedGroups = {
        'admin',
    }
}

Config.AddHouseGarage = { 
    Enable = true,
    CommandName = 'addhousegarage',
    AllowedJobs = {
        ['realestate'] = {3, 4}
    },
    BlipData = {
        sprite = 357,
        color = 3,
        shortRange = true,
        enabled = true
    },
    BoxSize = vec3(4, 8, 4) --size use for ox_lib box zone based on player coords
}

Config.EditHouseGarage = {
    Enable = true,
    CommandName = 'edithousegarage',
    AllowedJobs = {
        ['realestate'] = {3, 4}
    }
}

Config.UseVehicleImages = true --basic vehicle image in garage menu
Config.GetVehicleImageLink = function(vehicleModel, vehicleName)
    return 'https://docs.fivem.net/vehicles/'..vehicleName..'.webp'
end

Config.GarageMenuProgressColor = 'blue'

Config.ProgressCircle = false --true = circle progress bar from ox_lib / false = rectangle progress bar from ox_lib
Config.ProgressCirclePosition = 'middle' --position of the progress circle. can be either 'middle' or 'bottom'

Config.TextUI = { --ox_lib
    OpenGarage = true, --display text ui when in the area of a garage
    StoreVehicle = true, --display text ui when able to store a vehicle inside of a garage
    Position = 'left-center', --left-center / right-center / top-center
    Icon = {
        Icon = 'fa-sharp fa-solid fa-car-side', --FONT AWESOME ICON
        Color = 'white', --ICON COLOR
    },
    Style = { --REACT.CSS PROPERTIES STYLING
        borderRadius = 0,
        backgroundColor = '#1A626B', --BACKGROUND
        color = 'white' --TEXT COLOR
    }
}

Config.RadialMenu = { --ox_lib
    Enable = true, --generate radial menu options when inside a garage zone
    MainIcon = 'warehouse',
    RetrieveIcon = 'magnifying-glass',
    StoreIcon = 'warehouse'
}

Config.JobVehicles = {
    ['police'] = { --job name
        SocietyPurchase = {
            Enable = true, --if true option to use society balance to purchase shared vehicles is enabled
            Grades = {4}, --grades that can use this option
        },
        ['polmav'] = { --heli
            UseShared = {2, 3, 4}, --grades that can access this vehicle in shared garage
            PurchaseShared = {4}, --grades that can purchase this vehicle to add into the shared garage
            PurchasePersonal = {3, 4}, --grades that can purchase this vehicle for themselves
            Livery = 0, --livery to set on vehicle when purchased
            Mods = { --default mods to set on vehicle when purchased
                {modType = 48, modIndex = 0, customTires = false} --Police livery
            },
            Price = 5000, --vehicle price
            CustomAuth = true --will run config/cl_functions:jobGarageAuth() function to check if player is authorized to use this vehicle
        },
        ['predator'] = { --boat
            UseShared = {2, 3, 4},
            PurchaseShared = {4},
            PurchasePersonal = {3, 4},
            Price = 5000,
        },
        ['police'] = { 
            UseShared = {0, 1, 2, 3, 4},
            PurchaseShared = {3, 4},
            PurchasePersonal = {1, 2, 3, 4},
            Price = 5000 
        },
        ['police2'] = { 
            UseShared = {0, 1, 2, 3, 4},
            PurchaseShared = {3, 4},
            PurchasePersonal = {1, 2, 3, 4},
            Price = 10000
        }
    },
    ['ambulance'] = {
        SocietyPurchase = {
            Enable = true,
            Grades = {4},
        },
        ['polmav'] = {
            UseShared = {2, 3, 4}, 
            PurchaseShared = {4},
            PurchasePersonal = {3, 4},
            Livery = 0, 
            Mods = { 
                {modType = 48, modIndex = 1, customTires = false} --EMS livery
            },
            Price = 5000, 
            CustomAuth = true 
        },
        ['ambulance'] = { 
            UseShared = {0, 1, 2, 3, 4},
            PurchaseShared = {3, 4},
            PurchasePersonal = {1, 2, 3, 4},
            Price = 5000 
        }
    }
}

Config.CustomVehicleText = {
    --add missing vehicle text for imports here
    --['spawncode'] = 'Vehicle Name'
    --['16charger'] = '2016 Dodge Charger',
    ['predator'] = 'Police Predator',

}