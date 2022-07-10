local Cache = {}
local function log(text)
    print(json.encode(text, { pretty = true, indent = "  ", align_keys = true }))
end
local Loaded = false
local CreateNewPlayer = false
--Local Functions
local function RequestAndLoadModels(model)
    local CacheModel = tonumber(model)
    RequestModel(CacheModel)
    while not HasModelLoaded(CacheModel) do
        Wait(200)
        print("Requesting Model")
    end
    print("Model Loaded")
end

-- Function From QBR
local function RequestAndSetModel(model)
    local requestedModel = model == 1 and `mp_male` or `mp_female`
    RequestAndLoadModels(requestedModel)
    Wait(200)
 
    Citizen.InvokeNative(0xED40380076A31506, PlayerId(), requestedModel, false)

    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, PlayerPedId(), 0, 0)

    Wait(200)
    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x1D4C528A, 0)

    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x3F1F01E5, 0)

    Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0xDA0E2C55, 0)

end



-- Coordinates taked from QBR
local function RenderMap()
    RequestImap(-1699673416)
    RequestImap(1679934574)
    RequestImap(183712523)
    GetInteriorAtCoords(-558.9098, -3775.616, 238.59, 137.98)
    Wait(1500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), -562.91, -3776.25, 237.63)
end

local function CreateCams()
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    SetCamCoord(cam, -561.206, -3776.224, 239.597)
    SetCamRot(cam, -20.0, 0, 270.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    return cam
end


--QBR
local function createCharacter(sex)
    local model = sex == 1 and 'mp_male' or 'mp_female'
    if (sex == 0) then
        exports['qbr-clothing']:RequestAndSetModel(model)
        Wait(1000)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x158cb7f2, true, true, true); --head
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x16e292a1, true, true, true); --torso
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0xa615e02, true, true, true); --legs
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x105ddb4, true, true, true); --hair
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x10404a83, true, true, true);
        SetModelAsNoLongerNeeded(model)
    else
        exports['qbr-clothing']:RequestAndSetModel(model)
        Wait(1000)
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x11567c3, true, true, true); --head
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x2c4fe0c5, true, true, true); --torso
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0xaa25eca7, true, true, true); --legs
        Citizen.InvokeNative(0xD3A7B003ED343FD9, Cache.Player, 0x104293ea, true, true, true); --hair
        SetModelAsNoLongerNeeded(model)
    end
end

/*
--- This function will check if the player has or not a valid model, if not will trigger the QBR-clothing:newCharacter from the server
*/
local function onModelErrorDetected(cid)
    exports["qbr-core"]:TriggerCallback("psr-multicharacter:server:setNewModel",function(_)end,cid)
end
CreateThread(function() 
    Wait(200)
    if not Cache.SpawnPlace then
        Cache.SpawnPlace = {}
        for k,_ in each(Config.SpawnLocations) do
            local el = Config.SpawnLocations[k]
                Cache.SpawnPlace[#Cache.SpawnPlace+1] = {
                    label = el.label,
                    location = el.location,
                    coords = el.coords
                }
         end
    end
end)
---Lets check first if there isnt NUI active
RegisterNetEvent("psr-multicharacter:client:openMulticharacter",function(newPlayer)
    if not IsNuiFocused() then
    RenderMap()
 
    Wait(200)
    
    exports["qbr-core"]:TriggerCallback("psr-multicharacter:server:GetCurrentPeds", function(data, char)
        if (data and char) then
            Cache.Cam = CreateCams()
            Cache.Player = PlayerPedId()
            for i = 1, #data do
                local el = data[i]
                if not Cache[el.charinfo.citizenid] then
                    Cache[el.charinfo.citizenid] = {}
                end
                Cache[el.charinfo.citizenid] = {
                    model = el.model,
                    skin = el.skin,
                    cloth = el.cloth,
                    citizenid = el.charinfo.citizenid,
                    position = el.position
                }       
            end
            SendNUIMessage({
                action = "openMulticharacter",
                data = {
                    o = true,
                    data = data,
                    nCharacter = tonumber(char) or 5,
                    spawnData = Cache.SpawnPlace
                }
            })
            SetNuiFocus(true, true)
        end
    end)
end
end)

RegisterNetEvent("psr-multicharacter:client:closeNuiWindow",function()
    if IsNuiFocused() then
        SetNuiFocus(false, false)
    end
    SendNUIMessage({
        action = "closeNUI",
    })
    Cache.SpawnedPed = nil
end)

RegisterNUICallback("exitMultiplayer", function(data, cb)
    SetNuiFocus(false, false)
    if Cache.SpawnedPed then
        DeletePed(Cache.SpawnedPed)
        SetModelAsNoLongerNeeded(Cache.SpawnedPed)
        Cache.SpawnedPed = nil
    end
    FreezeEntityPosition(Cache.Player, false)
    RenderScriptCams(0, 1, 1, false, false)
    SetEntityVisible(Cache.Player, true)
    DestroyAllCams(true)
    cb(true)
    CreateNewPlayer = false
end)


CreateThread(function() 
    while CreateNewPlayer do
        Wait(1)
        DrawLightWithRange(-558.91, -3776.25, 237.63+ 1.0, 255, 255, 255, 5.5, 50.0)
    end
end)

RegisterNUICallback("selectedCharacter", function(data, cb)
    local cid = data.citizenid
    if Cache.SpawnedPed then
        DeletePed(Cache.SpawnedPed)
        SetModelAsNoLongerNeeded(Cache.SpawnedPed)
       repeat
        Wait(1)
       until not DoesEntityExist(Cache.SpawnedPed)
       Cache.SpawnedPed = nil
    end
    if Cache[cid] then
        if not Cache[cid].model.model then
            onModelErrorDetected(cid)
            print("NO MODEL DETECTED ERROR!")
            return
        end
        RequestAndLoadModels(tonumber(Cache[cid].model.model))
        Wait(200)
        local Player = CreatePed(tonumber(Cache[cid].model.model), -558.91, -3776.25, 237.63, 90.0, false, false)
        Cache.SpawnedPed = Player
        Wait(200)
        SetBlockingOfNonTemporaryEvents( Cache.SpawnedPed, true)
        while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C,  Cache.SpawnedPed) do
            Wait(200)
        end
        local model = IsPedMale(Cache.SpawnedPed) and 1 or 0
        RequestAndSetModel(model)
        Wait(300)
        exports['qbr-clothing']:loadSkin( Cache.SpawnedPed, Cache[cid].model.skin, false)
        Wait(200)
        exports['qbr-clothing']:loadClothes( Cache.SpawnedPed, Cache[cid].model.cloth, false)
    end
    cb("ok")
end)
RegisterNUICallback("createCharacter", function(data, cb)
    local cData = data
    DoScreenFadeOut(150)
    Wait(200)
    DestroyAllCams(true)
    cData.gender = "Male" and 1 or 0
    createCharacter(cData.gender)
    DeleteEntity(Cache.SpawnedPed)
    SetModelAsNoLongerNeeded(Cache.SpawnedPed)
    TriggerServerEvent('psr-multicharacter:server:CreateNewCharacter', cData)
    DoScreenFadeIn(1000)
    Wait(1000)
   cb("ok")
end)


RegisterNUICallback("spawnSelectedCharacter",function(data,cb)
     
    
    local cData = data
    if cData.location == "lastlocation" then
        local Coords = vector3(Cache[cData.citizenid].position.x, Cache[cData.citizenid].position.y, Cache[cData.citizenid].position.z)
        local old = vector3(-558.91, -3776.25, 237.63)
        if #(Coords - old) < 70 then
            cb(false)
            exports["qbr-core"]:Notify(2,"ERROR","Please select another spawn point")
            return
        end
    end
    DoScreenFadeOut(200)
    Wait(300)


    local model = IsPedMale(Cache.SpawnedPed) and 1 or 0
    if DoesEntityExist(Cache.SpawnedPed) then
        DeletePed(Cache.SpawnedPed)
        SetEntityAsNoLongerNeeded(Cache.SpawnedPed)
    end
    TriggerServerEvent("psr-multicharacter:server:loadUserData",data)
    RequestAndSetModel(model)
    Wait(1000)
        exports['qbr-clothing']:loadSkin(PlayerPedId(),Cache[cData.citizenid].model.skin)
        Wait(1000)
        exports['qbr-clothing']:loadClothes(PlayerPedId(), Cache[cData.citizenid].model.cloth, false)
        SetModelAsNoLongerNeeded(model)
    if cData.location == "lastlocation" then
        Citizen.InvokeNative(0x0A3720F162A033C9,Cache[cData.citizenid].position.x, Cache[cData.citizenid].position.y, Cache[cData.citizenid].position.z)
        Wait(500)
        --Move Player to the coordinates, then request the collision, after that just loop until the collision has loaded so no pop up
        SetEntityCoords(PlayerPedId(), Cache[cData.citizenid].position.x, Cache[cData.citizenid].position.y, Cache[cData.citizenid].position.z)
        while not HasCollisionLoadedAroundEntity(PlayerPedId() ) do
            Wait(100)
            print("Loading Collision at Coords")
        end
        Wait(2000)
        DoScreenFadeOut(500)
        Wait(2000)
    SetEntityCoords(PlayerPedId(), Cache[cData.citizenid].position.x, Cache[cData.citizenid].position.y, Cache[cData.citizenid].position.z)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(Cache.Cam, false)
    DestroyCam(Cache.Cam, true)
    SetEntityVisible(PlayerPedId(), true)
    Wait(500)
    DoScreenFadeIn(250)
    elseif Config.SpawnLocations[cData.location] then
        local NewCoords = Config.SpawnLocations[cData.location]
        DoScreenFadeOut(500)
        Citizen.InvokeNative(0x0A3720F162A033C9,NewCoords.coords.x, NewCoords.coords.y, NewCoords.coords.z)
        Wait(500)
        --Move Player to the coordinates, then request the collision, after that just loop until the collision has loaded so no pop up
        SetEntityCoords(PlayerPedId(), NewCoords.coords.x, NewCoords.coords.y, NewCoords.coords.z)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(100)
            print("Loading Collision at Coords")
        end
        Wait(2000)
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(Cache.Cam, false)
        DestroyCam(Cache.Cam, true)
        SetEntityVisible(PlayerPedId(), true)
        Wait(500)
        DoScreenFadeIn(250)
    else
        local NewCoords = Config.SpawnLocations["default"]
        DoScreenFadeOut(500)
        Citizen.InvokeNative(0x0A3720F162A033C9,NewCoords.coords.x, NewCoords.coords.y, NewCoords.coords.z)
        Wait(500)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(100)
            print("Loading Collision at Coords")
        end
        Wait(2000)
        SetEntityCoords(Cache.Player, NewCoords.coords.x, NewCoords.coords.y, NewCoords.coords.z)
        FreezeEntityPosition(Cache.Player, false)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        RenderScriptCams(false, true, 500, true, true)
        SetCamActive(Cache.Cam, false)
        DestroyCam(Cache.Cam, true)
        SetEntityVisible(Cache.Player, true)
        Wait(500)
        DoScreenFadeIn(250)
    end
    Cache = {}
    cb("ok")
end)
RegisterCommand("fixfade",function(_,__)
   -- DoScreenFadeIn(0)
end)
RegisterNUICallback("deleteCurrentCharacter",function(data,cb) 
    local cData = data.citizenid
    DoScreenFadeOut(150)
    Wait(200)
    if Cache[cData] then
        if Cache.SpawnedPed then
            DeletePed(Cache.SpawnedPed)
            SetModelAsNoLongerNeeded(Cache.SpawnedPed)
            Cache.SpawnedPed = nil
        end
        Cache[cData] = nil

      end
    exports["qbr-core"]:TriggerCallback("psr-multicharacter:server:deleteCurrentCharacter",function(result)
    if result then
            cb(true)
        end
      end,cData)
        Wait(1000)
        DoScreenFadeIn(1000)
end)


AddEventHandler("onResourceStop", function(res)
    if not GetCurrentResourceName() == res then
        return
    end
    if Cache.SpawnedPed then
        DeletePed(Cache.SpawnedPed)
        SetModelAsNoLongerNeeded(Cache.SpawnedPed)
    end
    FreezeEntityPosition(Cache.Player, false)
    SetEntityVisible(Cache.Player, true)
    RenderScriptCams(0, 1, 1, false, false)
    DestroyAllCams(true)
    Cache = {}
end)

CreateThread(function()
   while not Loaded do
    if  NetworkIsSessionStarted() then
        TriggerEvent('psr-multicharacter:client:openMulticharacter')
        Loaded = true
        CreateNewPlayer = true
        print("psr-multicharacter LOADED")
        break
    end
   end
end)