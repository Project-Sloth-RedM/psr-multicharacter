local QBRCore = exports["qbr-core"]
---This function will log to the console and prettify the code
---@param text string
function log(text)
  print(json.encode(text, { pretty = true, indent = "  ", align_keys = true }))
end

---Function to check if the Invoking resource is the same of the parent resource, if not, the player is triggering some event from oustide psr or qbr core
---@return boolean
local function GetCurrentName()
  return GetInvokingResource() ~= GetCurrentResourceName()
end

---Callback to get the info from the DB and the amount of characters, the default is 5
---@param source number
---@param cb table
QBRCore:CreateCallback("psr-multicharacter:server:GetCurrentPeds", function(source, cb)
  if GetInvokingResource() ~= "qbr-core" then
    --Every CreateCallback is triggered by QBR-CORE
    print("mm.... someone is trying to trigger this event from outside the resource")
    return
  end
  local license = QBRCore:GetIdentifier(source, 'license')
  local plyChars = {}
  MySQL.Async.fetchAll("SELECT players.citizenid AS citizenid,players.position AS position,players.cid AS cid, JSON_UNQUOTE(JSON_EXTRACT(players.charinfo,'$.firstname')) AS firstname, JSON_UNQUOTE(JSON_EXTRACT(players.charinfo,'$.lastname')) AS lastname,JSON_UNQUOTE(JSON_EXTRACT(players.charinfo,'$.nationality')) AS nationality,JSON_UNQUOTE(JSON_EXTRACT(players.job,'$.name')) AS job,JSON_UNQUOTE(JSON_EXTRACT(players.job,'$.grade.name')) AS rango,playerskins.model AS model, playerskins.skin AS skin , playerskins.clothes AS cloth FROM players left JOIN  playerskins ON playerskins.citizenid = players.citizenid WHERE license = @license"
    , { ['@license'] = license }, function(result)

    for i = 1, #result do
      local el = result[i]
      plyChars[#plyChars + 1] = {
        charinfo = {
          firstname = el.firstname,
          lastname = el.lastname,
          citizenid = el.citizenid,
          cid = el.cid
        },
        model = {
          model = el.model,
          skin = json.decode(el.skin),
          cloth = json.decode(el.cloth)
        },
        position = json.decode(el.position),
        cid = el.cid
      }

    end
    if not Config.CustomAmountCharacters[license] then
      cb(plyChars, Config.AmountCharacters)
    else
      cb(plyChars, Config.CustomAmountCharacters[license])
    end

  end)
end)

---handle the creation of a new character and save that to the db
--Function Taked from QBR
---@param data any
RegisterNetEvent("psr-multicharacter:server:CreateNewCharacter", function(data)
  if not GetCurrentName() then
    print "Trying to call the event from outside psr-multicharacter"
    return
  end
  local newData = {}
  local src = source
  newData.cid = data.cid
  newData.charinfo = data
  if exports['qbr-core']:Login(src, false, newData) then
    exports['qbr-core']:ShowSuccess(GetCurrentResourceName(), GetPlayerName(src) .. ' has succesfully loaded!')
    exports['qbr-core']:RefreshCommands(src)
    TriggerClientEvent("psr-multicharacter:client:closeNuiWindow", src)
    Wait(200)
    TriggerClientEvent('qbr-clothing:client:newPlayer', src)
  end
end)

---This function will check if the CID and License match in the db, if it pass the first check it will trigger the deletion, after that just to be sure it will check if there are some existing rows on the db
---@param source number
---@param cb boolean
---@param cid string
QBRCore:CreateCallback("psr-multicharacter:server:deleteCurrentCharacter", function(source, cb, cid)
  if GetInvokingResource() ~= "qbr-core" then
    --Every CreateCallback is triggered by QBR-CORE
    print("mm.... someone is trying to trigger this event from outside the resource")
    return
  end
  local License = QBRCore:GetIdentifier(source, 'license')
  local Res = MySQL.single.await("SELECT EXISTS(SELECT 1 FROM players WHERE license = ? AND citizenid = ?) AS EX",
    { License, cid })
  if Res.EX == 1 then
    QBRCore:DeleteCharacter(source, cid)
    Wait(200)
    local citizenid = MySQL.single.await("SELECT EXISTS(SELECT 1 FROM players WHERE citizenid = ?) AS CID",
      { cid })
    if citizenid.CID == 1 then
      MySQL.prepare("DELETE FROM players WHERE citizenid = ?", { cid }, function(result)
        log(result)
        print("Abnormal termination on DELETE CHARACTER, manually Delete Triggered")
      end)
    end
    local Skins = MySQL.single.await("SELECT EXISTS(SELECT 1 FROM playerskins WHERE citizenid = ?) AS Skin",
      { cid })
    if Skins == 1 then
      MySQL.prepare("DELETE FROM playerskins WHERE citizenid = ?", { cid }, function(result)
        log(result)
        print("Abnormal termination on DELETE CHARACTER, manually Delete Triggered")
      end)
    end
    print("Character " .. cid .. " Was Deleted")
    Wait(200)
    TriggerClientEvent("psr-multicharacter:client:closeNuiWindow", source)
    Wait(300)
    TriggerClientEvent("psr-multicharacter:client:openMulticharacter", source)
    cb(true)
  else
    print(QBRCore:GetPlayer(source).PlayerData.citizenid .. " is trying to delete a character with the ID: " .. cid)
    cb(false)
  end
end)

RegisterNetEvent("psr-multicharacter:server:openNewPlayer", function()
  if GetInvokingResource() ~= "qbr-clothing" then
    return
  end
  local src <const> = source
  local Player = QBRCore:GetPlayer(src)
  TriggerClientEvent("psr-multicharacter:client:closeNuiWindow", src)
  Wait(200)
  TriggerClientEvent("psr-multicharacter:client:openNewPlayer", src, Player.PlayerData.citizenid)
end)

---Function to check if there is a valid model on the db
---@param source number
---@param cb any
---@param cid string
QBRCore:CreateCallback("psr-multicharacter:server:setNewModel", function(source, cb, cid)
  local src <const> = source
  local modelCheck = MySQL.single.await("SELECT EXISTS(SELECT 1 FROM playerskins WHERE NULLIF(playerskins.model,'') and  citizenid = ?) AS model"
    , { cid })
  if modelCheck.model == 0 then
    TriggerClientEvent("psr-multicharacter:client:closeNuiWindow", src)
    Wait(200)
    TriggerClientEvent('qbr-clothing:client:newPlayer', src)
  end
end)
---Set the user Online
--Function taked from QBR-Multicharacter
---@param cData table
RegisterNetEvent('psr-multicharacter:server:loadUserData', function(cData)
  local src = source
  if exports['qbr-core']:Login(src, cData.citizenid) then
    print('^2[qbr-core]^7 ' .. GetPlayerName(src) .. ' (Citizen ID: ' .. cData.citizenid ..
      ') has succesfully loaded!')
    exports['qbr-core']:RefreshCommands(src)
    TriggerClientEvent("psr-multicharacter:client:closeNuiWindow", src)
    TriggerEvent("qbr-log:server:CreateLog", "joinleave", "Loaded", "green",
      "**" .. GetPlayerName(src) .. "** (" .. cData.citizenid .. " | " .. src .. ") loaded..")
  end
end)
