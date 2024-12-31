-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("zone_police",cRP)
vSERVER = Tunnel.getInterface("zone_police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local BlipRadius = nil

local blipsActive = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK SERVICE TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkServiceToggle()
    if LocalPlayer.state.Police then
        return true
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP ZONE POLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.BlipZonePolice(name, raio, timer)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local raio = tonumber(raio)
    if raio > 200 then
        raio = 400
    end
    if raio then
        raio = tonumber(string.format("%.1f", raio))
    end

    if vSERVER.RegisterCoords(name, raio, timer, coords) then
        ExecuteCommand("190 Nova zona de conflito adicionada ao GPS. Cuidado! 🚨")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP ZONE POLICE CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.BlipZonePoliceCreate(name, raio, coords)
    local raio = tonumber(raio)
    if raio > 150 then
        raio = 150
    end
    if raio then
        raio = tonumber(string.format("%.1f", raio))
    end

    Blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(Blip,0)
    SetBlipDisplay(Blip,4)
    SetBlipAsShortRange(Blip,true)
    SetBlipColour(Blip,0)
    SetBlipScale(Blip,0.4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(Blip)

    BlipRadius = AddBlipForRadius(coords.x,coords.y,coords.z,raio)
    SetBlipColour(BlipRadius,1)
    SetBlipAlpha(BlipRadius,60)

    blipsActive[#blipsActive + 1] = {
        [name] = {Blip,BlipRadius}
    }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMER TO REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.RemoveBlip(name)
    for k,v in pairs(blipsActive) do
        if blipsActive[k] and blipsActive[k][name] then
            if DoesBlipExist(blipsActive[k][name][1]) and DoesBlipExist(blipsActive[k][name][2]) then
                RemoveBlip(blipsActive[k][name][1])
                RemoveBlip(blipsActive[k][name][2])
            end
        end
    end
end