local ESX = exports["es_extended"]:getSharedObject()
local input, blip, MyVehicle, RewardVeh = nil, nil, nil, nil
local npc, boxes, rewards = {}, {}, {}

local function spawnBoxes(box, prop)
    for k, v in pairs(box) do
        ESX.Game.SpawnLocalObject(prop, v, function(object)
            PlaceObjectOnGroundProperly(object)
            SetModelAsNoLongerNeeded(object)
            FreezeEntityPosition(object, true)
			SetEntityAsMissionEntity(object, true, true)
            table.insert(boxes, {
                ["object"] = object,
                ["coords"] = v
            })
        end)
    end
end

local function getRandomReward()
    local random = math.random(1, #Config.Rewards)
    if rewards[random] then return getRandomReward() end
    local theReward = Config.Rewards[random]
    if theReward.unique then
        rewards[random] = true
    end
    return theReward
end

CreateThread(function()
    local labels = {}
    for k, v in pairs(Config.Missions) do
        table.insert(labels, {
            ["label"] = v.tittle,
            ["action"] = k
        })
    end
    
    RequestModel(Config.NPCHasModel)
    while not HasModelLoaded(Config.NPCHasModel) do
        Wait(1)
    end

    npc = CreatePed(4, Config.NPCHasModel, Config.NPCCoords, 0.0, false, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetPedCanBeTargetted(npc, false)
    SetPedCanRagdollFromPlayerImpact(npc, false)
    SetPedCanBeKnockedOffVehicle(npc, false)
    SetPedCanBeDraggedOut(npc, false)
    SetPedCanBeShotInVehicle(npc, false)
    SetModelAsNoLongerNeeded(Config.NPCHasModel)

    local player = PlayerId()
    local isNearby = false

    while true do
        Wait(0)
        local position = GetEntityCoords(PlayerPedId())
        local dist_npc = #(position - Config.NPCCoords)
        if dist_npc < 2.5 then
            isNearby = true
            drawtText('~b~Misiones \n ~g~G~w~ - Opciones', Config.NPCCoords + vector3(0, 0, 2))
            if IsControlJustReleased(0, 47) then 
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'amvi_mafias', {
                    title =  'Elegir misión',
                    elements = labels
                }, function(data, menu)
                    local CurrentMission = Config.Missions[data.current.action]
                    if RewardVeh then return ESX.ShowNotification(Config.Translations["mission_create"]) end
                    SpawnMisionVehicle(CurrentMission.vehicle)
                    missionIniciada = true
                    DrawRoute(CurrentMission.reward)
                    spawnBoxes(CurrentMission.boxes, CurrentMission.box_prop)
                    ESX.Game.SpawnLocalVehicle(CurrentMission.reward_vehicle, CurrentMission.reward, CurrentMission.reward.w, function(veh)
                        RewardVeh = veh
                        SetVehicleForwardSpeed(veh, 0)
                        SetVehicleEngineOn(veh, false, false, true)
                        SetVehicleDoorOpen(veh, 2, false, false)
                        SetVehicleDoorOpen(veh, 3, false, false)

                        CreateThread(function()
                            local coords = CurrentMission.reward
                            while not (#(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z)) < 20) do Wait(1000) end
                            if blip then RemoveBlip(blip) blip = nil end
                        end)
                    end)
                    CreateThread(function()
                        while #boxes > 0 do
                            for k, v in pairs(boxes) do
                                local coords = vector3(v.coords.x, v.coords.y, v.coords.z)
                                if #(GetEntityCoords(PlayerPedId()) - coords) < 2.3 then
                                    drawtText('~b~Cajas \n ~g~G~w~ - Abrir', coords + vector3(0, 0, 0))
                                    if IsControlJustReleased(0, 47) then
                                        exports["esx_progressbar"]:Progressbar("Recogiendo Armamento", math.random(8000, 12000),{
                                            FreezePlayer = true, 
                                            animation = {
                                                type = "anim",
                                                dict = "mini@repair", 
                                                lib = "fixing_a_ped"
                                            },
                                            onFinish = function()
                                            local reward = getRandomReward()
                                            TriggerServerEvent("ilegal:AddItem", reward.item, reward.amount)
                                            ESX.Game.DeleteObject(v.object)
                                            boxes[k] = nil
                                        end})
                                    end
                                end
                            end
                            Wait(5)
                        end
                        if RewardVeh then
                            ESX.Game.DeleteVehicle(RewardVeh)
                        end
                        if MyVehicle then
                            ESX.Game.DeleteVehicle(MyVehicle)
                        end
                        for k, v in pairs(boxes) do
                            ESX.Game.DeleteObject(v.object)
                        end
                         input, blip, MyVehicle, RewardVeh = nil, nil, nil, nil
                         npc, boxes, rewards = {}, {}, {}
                    end)
                    
                    menu.close()
                end, function(data, menu)
                    menu.close()
                end)
            end
        else
            if isNearby then
                isNearby = false
            end
        end
    end
end)

function DrawRoute(x, y, z)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 0)
    SetBlipRoute(blip, true)
end

function SpawnMisionVehicle(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    MyVehicle = CreateVehicle(model, Config.VehicleSpawnCoords.x, Config.VehicleSpawnCoords.y, Config.VehicleSpawnCoords.z, 00.00, true, false)
    ESX.ShowNotification(Config.Translations["phone_notify"])
    
    if DoesEntityExist(MyVehicle) then
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, MyVehicle, -1)
    end
end

AddEventHandler("onResourceStop", function(r)
	if r == GetCurrentResourceName() then
        if RewardVeh then
            ESX.Game.DeleteVehicle(RewardVeh)
        end
        if MyVehicle then
            ESX.Game.DeleteVehicle(MyVehicle)
        end
        for k, v in pairs(boxes) do
            ESX.Game.DeleteObject(v.object)
        end
	end
end)

function drawtText(text, coords) 
    coords = vector3(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(coords - camCoords)
    local scale = (0.8 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.40 * scale)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)

    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end