Citizen.CreateThread(function()
    
    blip = {}
    area_blip = {}

    for i = 1, #Config['ProspectingArea'] do

        local v = Config['ProspectingArea'][i]

        AddTextEntry("BLIP", Config.BlipText)
        blip[i] = AddBlipForCoord(v['coords'])
        SetBlipSprite(blip[i], 485)
        SetBlipAsShortRange(blip[i], true)
        BeginTextCommandSetBlipName("BLIP")
        EndTextCommandSetBlipName(blip[i])
        area_blip[i] = AddBlipForRadius(v['coords'], v['size'] / 2)
        SetBlipSprite(area_blip[i], 10)        

    end

end)

function Dig(index)

    removeMetalDetector()

    ClearPedTasksImmediately(ped)

    Wait(100)

    StopEntityAnim(ped, "wood_idle_a", "mini@golfai", true)

    loadAnimDict("amb@world_human_gardener_plant@male@enter")
    loadAnimDict("amb@world_human_gardener_plant@male@base")
    loadAnimDict('amb@world_human_gardener_plant@male@exit')

    TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)

    Wait(6000)

    table.remove(targets, index)

    TriggerServerEvent('prospecting:reward')

    ClearPedTasks(ped)

    TriggerEvent('prospecting:generateTargets')

    Wait(5000)

    AttachEntity(ped, "w_am_digiscanner")

end

RegisterNetEvent('prospecting:check')
AddEventHandler('prospecting:check', function()

    ped = PlayerPedId() -- reapplying the value of ped because it can change when the player changes ped

    if onCoolDown then

        return

    end

    Citizen.CreateThread(function()
    
        onCoolDown = true

        Wait(1000)

        onCoolDown = false
        
    end)
    
	if metaldetector then

        removeMetalDetector()

		return

	end

    canProspect = false

    for i = 1, #Config['ProspectingArea'] do

        local x = Config['ProspectingArea'][i]

        local dst = #(GetEntityCoords(ped).xy - x['coords'].xy)

        if dst <= Config['ProspectingArea'][i]['size'] / 2 then

            v = x

            canProspect = true
            
            break

        end

    end

    if not canProspect then

        ShowNotification(Config['translation'][Config.Language]['cant_prospect'])

		return

	end

	targets = {}

	TriggerEvent('prospecting:generateTargets')

	AttachEntity(ped, "w_am_digiscanner")
	
	Citizen.CreateThread(function()

		while not metaldetector do

			Wait(10)

		end

		while metaldetector do

			local sleep = 20
			local coords = GetEntityCoords(ped)

			DisableControlAction(0, 24, true)-- input attack
			DisableControlAction(0, 75, true)-- input vehicle Exit
			DisableControlAction(0, 140, true)-- input attack

			if not IsEntityPlayingAnim(ped, "mini@golfai", "wood_idle_a", 3) then
				loadAnimDict("mini@golfai")
				TaskPlayAnim(ped, "mini@golfai", "wood_idle_a", 1.0, -1.0, GetAnimDuration("mini@golfai", "wood_idle_a"), 49, 1)
            end

			restrictedMovement = false
            restrictedMovement = restrictedMovement or IsPedFalling(ped)
            restrictedMovement = restrictedMovement or IsPedJumping(ped)
            restrictedMovement = restrictedMovement or IsPedSprinting(ped)
            restrictedMovement = restrictedMovement or IsPedRunning(ped)
            restrictedMovement = restrictedMovement or IsPlayerFreeAiming(ply)
            restrictedMovement = restrictedMovement or IsPedRagdoll(ped)
            restrictedMovement = restrictedMovement or IsPedInAnyVehicle(ped)
            restrictedMovement = restrictedMovement or IsPedInCover(ped)
            restrictedMovement = restrictedMovement or IsPedInMeleeCombat(ped)

			if not restrictedMovement then

				local targetCoords, index = getClosestTarget(coords)

				if targetCoords then

					local dst = #((coords.xy - targetCoords.xy) * v['difficultyModifier'])

                    if dst < 3.0 then

                        ShowHelpNotification(Config['translation'][Config.Language]['press_e'])

                        if IsControlPressed(0, 38) or IsControlJustReleased(0, 38) then
        
                            Dig(index)
        
                        end

                    else

                        if SoundActive then

                            ShowHelpNotification(Config['translation'][Config.Language]['helpText'])

                            if IsControlPressed(0, 23) or IsControlJustReleased(0, 23) then

                                SoundActive = false
                                Wait(500)
    
                            end
    
                            if IsControlPressed(0, 73) or IsControlJustReleased(0, 73) then
    
                                removeMetalDetector()
                                Wait(500)
    
                            end

                        else

                            ShowHelpNotification(Config['translation'][Config.Language]['helpText2'])

                            if IsControlPressed(0, 23) or IsControlJustReleased(0, 23) then

                                SoundActive = true
                                Wait(500)
    
                            end
    
                            if IsControlPressed(0, 73) or IsControlJustReleased(0, 73) then
    
                                removeMetalDetector()
                                Wait(500)
    
                            end

                        end

                    end

					if dst < 3.0 then

                        circleScale = 0.0
                        scannerScale = 0.0
                        scannerState = "ultra"

                    elseif dst < 4.0 then

                        scannerFrametime = 0.35
                        scannerScale = 4.50
                        scannerState = "fast"

                    elseif dst < 5.0 then

                        scannerFrametime = 0.4
                        scannerScale = 3.75
                        scannerState = "fast"

                    elseif dst < 6.5 then

                        scannerFrametime = 0.425
                        scannerScale = 3.00
                        scannerState = "fast"

                    elseif dst < 7.5 then

                        scannerFrametime = 0.45
                        scannerScale = 2.50
                        scannerState = "fast"

                    elseif dst < 10.0 then

                        scannerFrametime = 0.5
                        scannerScale = 1.75
                        scannerState = "fast"

                    elseif dst < 12.5 then

                        scannerFrametime = 0.75
                        scannerScale = 1.25
                        scannerState = "medium"

                    elseif dst < 15.0 then

                        scannerFrametime = 1.0
                        scannerScale = 1.00
                        scannerState = "medium"

                    elseif dst < 20.0 then

                        scannerFrametime = 1.25
                        scannerScale = 0.875
                        scannerState = "medium"

                    elseif dst < 25.0 then

                        scannerFrametime = 1.5
                        scannerScale = 0.75
                        scannerState = "slow"

                    elseif dst < 30.0 then

                        scannerFrametime = 2.0
                        scannerScale = 0.5
                        scannerState = "slow"

                    else

                        circleScale = 0.0
                        scannerScale = 0.0
                        scannerState = "none"

                    end

					scannerDistance = dst

				else

					circleScale = 0.0
					scannerScale = 0.0
					scannerState = "none"

				end

			end

			Wait(sleep)

		end

	end)

end)


Citizen.CreateThread(function()

    SoundActive = Config.SoundActive
    local circleScale = 0.0
    local framecount = 0
    local frametime = 0
    local circleScaleMultiplier = 1.5
    local circleR, circleG, circleB, circleA = 255, 255, 255, 255
    local _circleR, _circleG, _circleB = 255, 255, 255

    while true do

        local sleep = 1000
        local renderCircle = true

        if metaldetector and Config.ZoneActive then

            sleep = 1

            restrictedMovement = false
            restrictedMovement = restrictedMovement or IsPedFalling(ped)
            restrictedMovement = restrictedMovement or IsPedJumping(ped)
            restrictedMovement = restrictedMovement or IsPedSprinting(ped)
            restrictedMovement = restrictedMovement or IsPedRunning(ped)
            restrictedMovement = restrictedMovement or IsPlayerFreeAiming(ply)
            restrictedMovement = restrictedMovement or IsPedRagdoll(ped)
            restrictedMovement = restrictedMovement or IsPedInAnyVehicle(ped)
            restrictedMovement = restrictedMovement or IsPedInCover(ped)
            restrictedMovement = restrictedMovement or IsPedInMeleeCombat(ped)

			if not restrictedMovement then

                local pos = GetEntityCoords(ped) + vector3(GetEntityForwardX(ped) * 0.75, GetEntityForwardY(ped) * 0.75, -0.75)

                if scannerState == "none" then

                    renderCircle = false

                elseif scannerState == "slow" then

                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 150, 255, 150

                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end

                elseif scannerState == "medium" then

                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 255, 150

                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end

                elseif scannerState == "fast" then

                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 150, 150

                    if frametime > scannerFrametime then
                        frametime = 0.0
                    end

                elseif scannerState == "ultra" then

                    renderCircle = false

                    circleScale = circleScale + scannerScale
                    circleR, circleG, circleB = 255, 100, 100

                    if frametime > 0.125 then

                        frametime = 0.0

                        if Config.SoundActiverAudio and SoundActive then 

                            
                            PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0) 

                        end
                        -- PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
                        if Config.SoundActive and SoundActive then 

                            
                            PlaySoundFrontend(-1, "BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS", 0) 

                        end

                    end

                    circleA = 150
                    circleSize = 1.20 * circleScaleMultiplier

                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)

                    circleA = 200
                    circleSize = 0.70 * circleScaleMultiplier

                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)

                    circleA = 255
                    circleSize = 0.20 * circleScaleMultiplier

                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, circleR, circleG, circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, circleR, circleG, circleB, circleA)

                end

                if renderCircle then

                    if circleScale > 100 then

                        while circleScale > 100 do

                            circleScale = circleScale - 100

                        end

                        _circleR, _circleG, _circleB = circleR, circleG, circleB
                        
                        if Config.SoundActive and SoundActive then 

                            PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0) 

                        end

                    end

                    circleSize = ((circleScale % 100) / 100) * circleScaleMultiplier
                    circleA = math.floor(255 - ((circleScale % 100) / 100) * 155)

                    DrawMarker(1, pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circleSize, circleSize, 0.2, _circleR, _circleG, _circleB, circleA)
                    DrawMarker(6, pos, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, circleSize, 0.1, circleSize, _circleR, _circleG, _circleB, circleA)

                end

                framecount = (framecount + 1) % 120
                frametime = frametime + Timestep()

            end

        end

        Wait(sleep)

    end

end)


function AttachEntity(ped, model)

	loadModel(model)

	local ent = CreateObjectNoOffset(model, GetEntityCoords(ped), 1, 1, 0)
	AttachEntityToEntity(ent, ped, GetPedBoneIndex(ped, Config['models'][model].bone), Config['models'][model].offset, Config['models'][model].rotation, 1, 1, 0, 0, 2, 1)
	
	metaldetector = ent

end

function loadModel(model)

	if not IsModelInCdimage(model) then
		print('MetalDetector prop doesnt load')
		return
	end

    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
    end

end

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function getClosestTarget(pos)

    local targetCoords, index, closestdst

	for i = 1, #targets do

        local dst = #(GetEntityCoords(ped) - targets[i]['coords'])

        if (not targetCoords) or closestdst > dst then

            closestdst = dst
			targetCoords = targets[i]['coords']
            index = i

			Wait(0)

        end

    end
    -- Return 0,0,0 if no targets
    return targetCoords, index

end

RegisterNetEvent('prospecting:generateTargets')
AddEventHandler('prospecting:generateTargets', function()

	for i = 1, v['locations'] do

		if #targets >= v['locations'] then

			return

		end

        Wait(1000)

        print(v['size'])
        
		x = math.random(0,(v['size'] * 2))
		y = math.random(0,(v['size'] * 2))

		if x < 100 then

			x = x - x - x -- makes the value neegative

            x = x + v['coords']['x']

		else

			x = x + v['coords']['x'] - 100

		end

		if y < 100 then

            y = y - y - y -- makes the value neegative

            y = y + v['coords']['y']

		else

			y = y + v['coords']['y'] - 100

		end

		asd, z = GetGroundZFor_3dCoord(x, y, v['coords']['z'], 1)

		table.insert(targets, {coords = vec3(x,y,z)})

	end

end)

function ShowHelpNotification(msg, duration)

    AddTextEntry('notification', msg)

    BeginTextCommandDisplayHelp('notification')
    EndTextCommandDisplayHelp(0, false, true, duration or -1)

end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function removeMetalDetector()

    DeleteObject(metaldetector)
    ClearPedTasks(ped)
    metaldetector = nil

end
