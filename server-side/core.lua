-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("lib/Tunnel")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("zone_police",cRP)
vCLIENT = Tunnel.getInterface("zone_police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local ZonesActive = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("perimetro",function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"Police") and vCLIENT.checkServiceToggle(source) then
        local name = vRP.prompt(source, "Nome do perimetro:", "")
        local raio = vRP.prompt(source, "Raio do perimetro (Max = 150 metros):", "")
        local timer = vRP.prompt(source, "Tempo do perimetro (em minutos):", "")
        if name and raio and timer then
            vCLIENT.BlipZonePolice(source,name, raio, timer)
        else
            TriggerClientEvent("Notify",source,"negado","Falha ao criar o perimetro.")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Sem permissão.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.RegisterCoords(name, raio, timer, coords)
    local source = source
    if #ZonesActive > 1 then
        TriggerClientEvent("Notify", source, "negado", "Limite de zonas atigindo!", 3000)
        return false
    end
    ZonesActive[#ZonesActive + 1] = {name, raio, (os.time() + tonumber(timer*60)), coords}
    vCLIENT.BlipZonePoliceCreate(-1, name, raio, coords)
    TriggerClientEvent("Notify",source,"check","<b>Perimetro</b> ativado com sucesso.")
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnect", function(user, source)
    for k,v in pairs(ZonesActive) do
        vCLIENT.BlipZonePoliceCreate(source, v[1], v[2], v[4])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMER TO REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
while true do
    for k,v in pairs(ZonesActive) do
        if v[3] then
            if os.time() >= v[3] then
                table.remove(ZonesActive, k)
                vCLIENT.RemoveBlip(-1,v[1])
            end
        end
    end
    Wait(1000)
end
