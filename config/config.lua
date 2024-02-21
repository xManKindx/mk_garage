Config = {}

Config.OnlyOwnerCanStore = false --if false anyone with keys can store vehicle

Config.DrivingDistanceColumn = 'drivingdistance' --column inside (player_vehicles / owned_vehicles) that contains vehicle driving distance

Config.EnableVehicleTracker = true --vehicles taken out of the garage can be tracked unless tracker is removed via export

Config.StoreFakePlates = true --allow to store vehicle with fakeplate

Config.UniqueGarages = true --can only retrieve vehicles from the (public) garage they were stored in. set false to retrieve vehicles stored in a public garage from any public garage

Config.WarpIntoVehicle = true --warp into driver seat when vehicle spawns

Config.StoreOutsideVehiclesOnRestart = true --any vehicle not marked as stored will be set back into its garage on server restart or into impound if Config.ImpoundOnRestart is set to true
Config.ImpoundOnRestart = false --vehicles left out on the street will be sent to impound on server restart (Config.StoreOutsideVehiclesOnRestart must be set to true)
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
        'group.admin',
    }
}

Config.EditGarageCommand = {
    CommandName = 'editgarage',
    AllowedGroups = {
        'group.admin',
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

Config.RadialMenu = {
    Enable = true, --generate radial menu options when inside a garage zone
    MainIcon = 'warehouse',
    RetrieveIcon = 'magnifying-glass',
    StoreIcon = 'warehouse',

    ---@param garageId number Current garage id
    ---@param items { icon: string (icon name), label: string (radial option label), onSelect: function (function to run on select) }
    AddRadial = function(self, garageId, items)
        if GetResourceState('qb-radialmenu') == 'started' then
            --qb-radialmenu

            local radialItems = {}
            for key, value in pairs(items) do 
                if value.label == locale('radial_retrieve') then
                    table.insert(radialItems, {
                        id = 'openGarage',
                        title = locale('radial_retrieve'),
                        icon = self.RetrieveIcon,
                        type = 'client',
                        event = 'mk_garage:client:radialOpenGarage',
                        shouldClose = true
                    })
                elseif value.label == locale('radial_store') then 
                    table.insert(radialItems, {
                        id = 'closeGarage',
                        title = locale('radial_store'),
                        icon = self.StoreIcon,
                        type = 'client',
                        event = 'mk_garage:client:radialStoreVehicle',
                        shouldClose = true
                    })
                end
            end

            self.menuId = exports['qb-radialmenu']:AddOption({
                title = locale('radial_main_garage'),
                icon = self.MainIcon,
                items = radialItems
            })
        else
            --ox_lib radial menu

            lib.registerRadial({
                id = 'mk_garage_'..garageId..'_submenu',
                items = items
            })

            lib.addRadialItem({
                id = 'mk_garage_'..garageId,
                icon = self.MainIcon,
                label = locale('radial_main_garage'),
                menu = 'mk_garage_'..garageId..'_submenu'
            })
        end
    end,

    ---@param garageId number Current garage id
    RemoveRadial = function(self, garageId)
        if GetResourceState('qb-radialmenu') == 'started' then
            exports['qb-radialmenu']:RemoveOption(self.menuId)
        else
            --ox_lib
            lib.removeRadialItem('mk_garage_'..garageId)
        end
    end,

    HideRadial = function(self)
        if GetResourceState('qb-radialmenu') == 'started' then
            --no event for qb-radialmenu
        else
            --ox_lib
            lib.hideRadial()
        end
    end
}

if not IsDuplicityVersion() then --client only
    RegisterNetEvent('mk_garage:client:radialOpenGarage', function()
        openGarage()
    end)

    RegisterNetEvent('mk_garage:client:radialStoreVehicle', function()
        storeVeh()
    end)
end

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