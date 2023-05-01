local inventory = exports.ox_inventory

ESX.RegisterUsableItem('metaldetector', function(source)

    local _source = source

    TriggerClientEvent('prospecting:check', _source)

end)

RegisterNetEvent('prospecting:reward')
AddEventHandler('prospecting:reward', function()

    local _source = source

    local randomAmount = math.random(1, 1000)

    local xPlayer = ESX.GetPlayerFromId(_source)

    for i = 1, #Config['rewards'] do

        randomAmount = randomAmount - Config['rewards'][i]['chance'] * 10

        if randomAmount < 1 then

            if xPlayer then

                if Config.inventory == 'ox_inventory' then

                    if inventory:CanCarryItem(_source, Config['rewards'][i]['item'], Config['rewards'][i]['amount']) then

                        inventory:AddItem(_source, Config['rewards'][i]['item'], Config['rewards'][i]['amount'])

                        return

                    else

                        xPlayer.showNotification(Config['translation'][Config.Language]['cant_carry'])

                    end

                else

                    if xPlayer.canCarryItem(Config['rewards'][i]['item'], Config['rewards'][i]['amount']) then

                        xPlayer.addInventoryItem(Config['rewards'][i]['item'], Config['rewards'][i]['amount'])
                        
                        return
    
                    else
    
                        xPlayer.showNotification(Config['translation'][Config.Language]['cant_carry'])
    
                    end

                end

            end

        end

    end

end)
