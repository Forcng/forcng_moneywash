local ESX = exports['es_extended']:getSharedObject()

local washCooldown = {}

RegisterServerEvent('forcng:checkActions', function(amount)
    local _src = source
    local _player = ESX.GetPlayerFromId(_src)
    local UUID = _player.getIdentifier()
    local time = os.time()

    if washCooldown[UUID] and washCooldown[UUID] > time then
        local timeLeft = washCooldown[UUID] - time
        TriggerClientEvent('ox_lib:notify', _src, {
            title = 'Money Wash',
            description = 'You must wait ' .. timeLeft .. ' seconds before washing again.',
            type = 'error',
            position = 'center-right'
        })
        return
    end

    local DIRTY_MONEY = _player.getAccount('black_money').money

    amount = tonumber(amount)

    if amount < 1000 then
        TriggerClientEvent('ox_lib:notify', _src, {
            title = 'Money Wash',
            description = 'You must input at least $1,000 to wash!',
            type = 'error',
            position = 'center-right'
        })
        return
    end

    if amount > DIRTY_MONEY then
        TriggerClientEvent('ox_lib:notify', _src, {
            title = 'Money Wash',
            description = 'You don\'t have enough dirty money.',
            type = 'error',
            position = 'center-right'
        })
        return
    end

    local CLEAN_MONEY = math.floor(amount * (Config.WashReduction / 100))

    _player.removeAccountMoney('black_money', amount)
    _player.addMoney(CLEAN_MONEY)


    washCooldown[UUID] = time + Config.Cooldown

    TriggerClientEvent('ox_lib:notify', _src, {
        title = 'Money Wash',
        description = 'Successfully washed $' .. CLEAN_MONEY,
        type = 'success',
        position = 'center-right'
    })
end)
