local _doorCache = {}
local _CreateThread, _RegisterServerEvent = CreateThread, RegisterServerEvent

ESX = ESX

if Config['usingOldESX'] then 
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
end

isAllowed = function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    local group = xPlayer.getGroup()
    for k, v in pairs(Config['admingroups']) do
        if group == v then
            return true
        end
    end
    return false
end

_CreateThread(function()
    local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
    if doors == "" then
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", "[]", -1)
    end
    local name = "[^4guille_doorlock^7]"
    checkVersion = function(error, latestVersion, headers)
        local currentVersion = Config['scriptVersion']            
        
        if tonumber(currentVersion) < tonumber(latestVersion) then
            print(name .. " ^1is outdated.\nCurrent version: ^8" .. currentVersion .. "\nNewest version: ^2" .. latestVersion .. "\n^3Update^7: https://github.com/guillerp8/guille_doorlock")
        elseif tonumber(currentVersion) > tonumber(latestVersion) then
            print(name .. " has skipped the latest version ^2" .. latestVersion .. ". Either Github is offline or the version file has been changed")
        else
            print(name .. " is updated.")
        end
    end

    PerformHttpRequest("https://raw.githubusercontent.com/guillerp8/jobcreatorversion/ma/doorlock.txt", checkVersion, "GET")
end)

ESX['RegisterServerCallback']('guille_doorlock:cb:getDoors', function(source,cb) 
    local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
    doors = json['decode'](doors)
    cb(doors, _doorCache)
end)

_RegisterServerEvent("guille_doorlock:server:addDoor", function(_doorCoords, _doorModel, _heading, type, _textCoords, dist, jobs, pin)
    local _src <const> = source
    if isAllowed(_src) then
        local usePin = false
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        if pin ~= "" then
            usePin = true
        end
        doors = json.decode(doors)
        local tableToIns <const> = {
            doorCoords = _doorCoords,
            _doorModel = _doorModel,
            _heading = _heading,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
        }
        table['insert'](doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors), -1)
        TriggerClientEvent("guille_doorlock:client:refreshDoors", -1, tableToIns)
    end
end)

_RegisterServerEvent("guille_doorlock:server:addDoubleDoor", function(_doorsDobule, type, _textCoords, dist, jobs, pin)
    local _src <const> = source
    if isAllowed(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        local usePin = false
        if pin ~= "" then
            usePin = true
        end
        local tableToIns <const> = {
            _doorsDouble = _doorsDobule,
            _type = type,
            _textCoords = _textCoords,
            dist = dist,
            jobs = jobs,
            usePin = usePin,
            pin = pin,
        }
        table['insert'](doors, tableToIns)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors), -1)
        TriggerClientEvent("guille_doorlock:client:refreshDoors", -1, tableToIns)
    end
end)

_RegisterServerEvent("guille_doorlock:server:updateDoor", function(id, type)
    _doorCache[id] = type
    TriggerClientEvent("guille_doorlock:client:updateDoorState", -1, id, type)
end)

_RegisterServerEvent("guille_doorlock:server:syncRemove", function(id)
    local _src <const> = source
    if isAllowed(_src) then
        local doors = LoadResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json")
        doors = json.decode(doors)
        table['remove'](doors, id)
        SaveResourceFile(GetCurrentResourceName(), "Server/Files/Doors.json", json['encode'](doors), -1)
        TriggerClientEvent("guille_doorlock:client:removeGlobDoor", -1, id)
    end
end)

RegisterCommand("door", function(source, args)  
    local _src <const> = source
    if isAllowed(_src) then
        TriggerClientEvent("guille_doorlock:client:setUpDoor", _src)
    end 
end, false)

RegisterCommand("deletedoor", function(source, args)  
    local _src <const> = source
    if isAllowed(_src) then
        TriggerClientEvent("guille_doorlock:client:deleteDoor", _src)
    end 
end, false)