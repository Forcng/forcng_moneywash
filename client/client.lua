local ESX = exports['es_extended']:getSharedObject()

local function OPEN_WASH()
    lib.registerContext({
        id = 'wash',
        title = 'Dirty Money Wash',
        options = {
            {
                title = 'Money Wash',
                description = 'Convert your dirty money to clean money.',
                icon = 'fa-solid fa-sack-dollar',
                onSelect = function()
                    local amount = lib.inputDialog('Money Wash', {
                        {type = 'number', label = 'Amount to Wash', required = true, min = 1}
                    })

                    if not amount or not amount[1] then return end

                    TriggerServerEvent('forcng:checkActions', amount[1])
                end
            }
        }
    })

    lib.showContext('wash')
end

CreateThread(function()
    for _, peds in ipairs(Config.BigBoys) do
        RequestModel(peds.model)
        while not HasModelLoaded(peds.model) do Wait(0) end

        local ped = CreatePed(0, peds.model, peds.coords.x, peds.coords.y, peds.coords.z, peds.heading, false, false)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                label = 'Wash Money',
                icon = 'fa-solid fa-money-bill-wave',
                onSelect = function()
                    OPEN_WASH()
                end
            }
        })
    end
end)
