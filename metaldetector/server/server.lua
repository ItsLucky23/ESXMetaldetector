ESX.RegisterUsableItem('metaldetector', function(source)

    local _source = source

    TriggerClientEvent('prospecting:check', _source)

end)

RegisterNetEvent('prospecting:reward')
AddEventHandler('prospecting:reward', function()

    local _source = source

    local randomAmount = math.random(1, 100)

    local xPlayer = ESX.GetPlayerFromId(_source)

    for i = 1, #Config['rewards'] do

        local randomAmount = randomAmount - Config['rewards'][i]['chance']

        if randomAmount <= 1 then

            if xPlayer then

                if xPlayer.canCarryItem(Config['rewards'][i]['item'], Config['rewards'][i]['amount']) then

                    xPlayer.addInventoryItem(Config['rewards'][i]['item'], Config['rewards'][i]['amount'])
                    randomAmount = 100
                    break

                else

                    xPlayer.showNotification(Config['translation'][Config.Language]['cant_carry'])

                end

            end

        end

    end

end)