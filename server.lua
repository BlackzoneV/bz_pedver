ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


function ped(cb)
hexcheck = {}

MySQL.Async.fetchAll('SELECT identifier FROM bz_ped', {}, function(result)
	for i=1, #result, 1 do
		table.insert(hexcheck, tostring(result[i].identifier):lower())
	end

	if cb ~= nil then
		cb()
	end

end)
end


MySQL.ready(function()
    ped()
end)

AddEventHandler('esx:playerLoaded', function(id,xPlayer)
Wait(6000)
local xPlayer = ESX.GetPlayerFromId(id)
    MySQL.Async.fetchAll('SELECT * FROM bz_ped WHERE identifier=@identifier ', {
        ['@identifier'] = xPlayer.identifier,
    }, function (result)
            if result ~= nil then
                for i=1, #result, 1 do
                    skin = result[i].pedmodel
                    TriggerClientEvent("bz:pedayarla", xPlayer.source, skin)
                end
            end
    end)
end)


RegisterCommand('pedfix', function(source)
ped()
Wait(600)
local xPlayer = ESX.GetPlayerFromId(source)
--
local yetki = false
for i=1, #Config.PedYetki, 1 do
    if tostring(Config.PedYetki[i]) == tostring(xPlayer.identifier) then
        yetki = true
        break
    end
end
if yetki then
local hexyokla = false
local steamhex = GetPlayerIdentifiers(source)[1]
for i=1, #hexcheck, 1 do
	if tostring(hexcheck[i]) == tostring(steamhex) then
		hexyokla = true
		break
	end
end
if hexyokla then
    MySQL.Async.fetchAll('SELECT * FROM bz_ped WHERE identifier=@identifier ', {
        ['@identifier'] = xPlayer.identifier,
    }, function (result)
            if result ~= nil then
                for i=1, #result, 1 do
                    skin = result[i].pedmodel
                    TriggerClientEvent("bz:pedayarla", source, skin)
                    TriggerClientEvent('notification', source, 'Pedin değiştirildi.', 1)
                end
            end
    end)
	else
	TriggerClientEvent('notification', source, 'Pedini ayarlamamışsın!', 2)
	end
else
	TriggerClientEvent('notification', source, 'Bunu önce satın almalısın!', 2)
end
end)


RegisterCommand('a-pedver', function(source, args)
if IsPlayerAceAllowed(source, "ped.yetkisi") then
local id = tonumber(args[1])
local target = ESX.GetPlayerFromId(id).identifier
local pedgir = args[2]

MySQL.Async.execute('INSERT INTO bz_ped (`identifier`, `pedmodel`) VALUES (@identifier, @pedmodel)', {
    ['@identifier'] = target,
    ['@pedmodel'] = pedgir,
}, function(result)
    TriggerClientEvent('notification', source, id..' ID kişiye pedi verildi.', 1)
end)
else
	TriggerClientEvent('notification', source, 'Bunu kullanmak için yetkin yok!', 2)
end
end)

RegisterCommand('a-pedsil', function(source, args)
if IsPlayerAceAllowed(source, "ped.kullanimi") then
local id = tonumber(args[1])
local target = ESX.GetPlayerFromId(id).identifier

MySQL.Async.execute('DELETE FROM bz_ped WHERE identifier=@identifier', {
	['@identifier'] = target
})
else
	TriggerClientEvent('notification', source, 'Bunu kullanmak için yetkin yok!', 2)
end
end)


RegisterCommand('pedim', function(source, args)
ped()
Wait(600)
local xPlayer = ESX.GetPlayerFromId(source)
--
local yetki = false
for i=1, #Config.PedYetki, 1 do
    if tostring(Config.PedYetki[i]) == tostring(xPlayer.identifier) then
        yetki = true
        break
    end
end
if yetki then
local hexyokla = false
local steamhex = GetPlayerIdentifiers(source)[1]
for i=1, #hexcheck, 1 do
    if tostring(hexcheck[i]) == tostring(steamhex) then
        hexyokla = true
        break
    end
end
if hexyokla then
    TriggerClientEvent('notification', source, 'Zaten pedin var!', 2)
else
local pedgir = args[1]

MySQL.Async.execute('INSERT INTO bz_ped (`identifier`, `pedmodel`) VALUES (@identifier, @pedmodel)', {
    ['@identifier'] = xPlayer.identifier,
    ['@pedmodel'] = pedgir,
}, function(result)
    TriggerClientEvent('notification', source, 'Pedin ayarlandı.', 1)
end)
end
else
	TriggerClientEvent('notification', source, 'Bunu önce satın almalısın!', 2)
end
end)


RegisterCommand('pedsil', function(source)
ped()
Wait(600)
local xPlayer = ESX.GetPlayerFromId(source)
--
local yetki = false
for i=1, #Config.PedYetki, 1 do
    if tostring(Config.PedYetki[i]) == tostring(xPlayer.identifier) then
        yetki = true
        break
    end
end
if yetki then

MySQL.Async.execute('DELETE FROM bz_ped WHERE identifier=@identifier', {
    ['@identifier'] = xPlayer.identifier,
}, function(result)
    TriggerClientEvent('notification', source, 'Pedin silindi.', 2)
end)
else
	TriggerClientEvent('notification', source, 'Bunu önce satın almalısın!', 2)
end
end)