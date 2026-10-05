local hudVisible = false
local seatbelt = false

local function setHudVisible(state)
    if hudVisible == state then return end
    hudVisible = state
    SendNUIMessage({ action = state and 'show' or 'hide' })
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            setHudVisible(true)

            local speed = GetEntitySpeed(vehicle) * 3.6
            local rpm = GetVehicleCurrentRpm(vehicle)
            local gear = GetVehicleCurrentGear(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local engine = GetIsVehicleEngineRunning(vehicle)
            local health = math.max(0, math.min(100, math.floor(GetVehicleEngineHealth(vehicle) / 10)))
            local _, highBeam = GetVehicleLightsState(vehicle)
            local indicators = GetVehicleIndicatorLights(vehicle)
            local handbrake = GetVehicleHandbrake(vehicle)

            local gearText = tostring(gear)
            if gear == 0 then
                gearText = speed < 1.0 and 'N' or 'R'
            end

            SendNUIMessage({
                action = 'update',
                speed = speed,
                rpm = rpm,
                gear = gearText,
                fuel = fuel,
                health = health,
                engine = engine,
                seatbelt = seatbelt,
                highbeam = highBeam,
                left = indicators == 1 or indicators == 3,
                right = indicators == 2 or indicators == 3,
                handbrake = handbrake
            })

            Wait(75)
        else
            seatbelt = false
            setHudVisible(false)
            Wait(250)
        end
    end
end)

RegisterCommand('seatbelt', function()
    local ped = PlayerPedId()
    if GetVehiclePedIsIn(ped, false) ~= 0 then
        seatbelt = not seatbelt
        SendNUIMessage({ action = 'seatbelt', value = seatbelt })
    end
end, false)

RegisterKeyMapping('seatbelt', 'Toggle seatbelt', 'keyboard', 'B')

exports('IsSeatbeltOn', function()
    return seatbelt
end)

exports('SetSeatbelt', function(value)
    seatbelt = value == true
    SendNUIMessage({ action = 'seatbelt', value = seatbelt })
end)
