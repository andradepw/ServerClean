local menuOpen = false
local currentPage = 'main'
local selectedIndex = 1
local pageHistory = {}
local currentVehicle = nil
local cam = nil
local customTires = false
local freeCam = false
local camDistance = 5.0
local camHeight = 2.0
local camRotX = 0.0
local camRotZ = 0.0
local committedState = nil
local lastPreviewPage = nil
local lastPreviewIndex = nil
local BuildItems

CreateThread(function()
    Wait(3000)
    print('^2[ANDRADE BENNYS] client.lua ATUALIZADO carregou com sucesso!^0')
end)

local wheelTypes = {
    { label = 'Sport', id = 0 },
    { label = 'Muscle', id = 1 },
    { label = 'Lowrider', id = 2 },
    { label = 'SUV', id = 3 },
    { label = 'Offroad', id = 4 },
    { label = 'Tuner', id = 5 },
    { label = 'Bike', id = 6 },
    { label = 'High End', id = 7 },
    { label = 'Benny’s Original', id = 8 },
    { label = 'Benny’s Bespoke', id = 9 },
    { label = 'Open Wheel', id = 10 },
    { label = 'Street', id = 11 },
    { label = 'Track', id = 12 }
}

local windowTints = {
    { label = 'Sem insulfilm', id = 0 },
    { label = 'Preto puro', id = 1 },
    { label = 'Fumê escuro', id = 2 },
    { label = 'Fumê claro', id = 3 },
    { label = 'Limo', id = 4 },
    { label = 'Verde', id = 5 }
}

local plateTypes = {
    { label = 'Azul/Branco 1', id = 0 },
    { label = 'Amarelo/Preto', id = 1 },
    { label = 'Amarelo/Azul', id = 2 },
    { label = 'Azul/Branco 2', id = 3 },
    { label = 'Azul/Branco 3', id = 4 },
    { label = 'Yankton', id = 5 }
}

local classicColors = {
    { label = 'Preto', id = 0 },
    { label = 'Preto Grafite', id = 1 },
    { label = 'Prata', id = 4 },
    { label = 'Cinza', id = 13 },
    { label = 'Branco', id = 111 },
    { label = 'Vermelho', id = 27 },
    { label = 'Vermelho Escuro', id = 34 },
    { label = 'Laranja', id = 38 },
    { label = 'Amarelo', id = 88 },
    { label = 'Verde', id = 55 },
    { label = 'Verde Limão', id = 92 },
    { label = 'Azul', id = 64 },
    { label = 'Azul Escuro', id = 62 },
    { label = 'Azul Claro', id = 70 },
    { label = 'Roxo', id = 145 },
    { label = 'Rosa', id = 135 },
    { label = 'Dourado', id = 99 },
    { label = 'Marrom', id = 96 },
    { label = 'Cromado', id = 120 }
}

local neonColors = {
    { label = 'Branco', r = 255, g = 255, b = 255 },
    { label = 'Azul', r = 0, g = 0, b = 255 },
    { label = 'Azul Claro', r = 0, g = 180, b = 255 },
    { label = 'Verde', r = 0, g = 255, b = 0 },
    { label = 'Verde Limão', r = 120, g = 255, b = 0 },
    { label = 'Amarelo', r = 255, g = 255, b = 0 },
    { label = 'Laranja', r = 255, g = 120, b = 0 },
    { label = 'Vermelho', r = 255, g = 0, b = 0 },
    { label = 'Rosa', r = 255, g = 0, b = 180 },
    { label = 'Roxo', r = 180, g = 0, b = 255 }
}

local modCategories = {
    { label = 'Spoiler', mod = 0 },
    { label = 'Para-choque dianteiro', mod = 1 },
    { label = 'Para-choque traseiro', mod = 2 },
    { label = 'Saias laterais', mod = 3 },
    { label = 'Escapamento', mod = 4 },
    { label = 'Santo Antônio / Gaiola', mod = 5 },
    { label = 'Grade', mod = 6 },
    { label = 'Capô', mod = 7 },
    { label = 'Paralama esquerdo', mod = 8 },
    { label = 'Paralama direito', mod = 9 },
    { label = 'Teto', mod = 10 },
    { label = 'Buzina', mod = 14 },
    { label = 'Placas decorativas', mod = 25 },
    { label = 'Acabamento interno', mod = 27 },
    { label = 'Enfeites', mod = 28 },
    { label = 'Painel', mod = 29 },
    { label = 'Mostradores', mod = 30 },
    { label = 'Alto-falantes portas', mod = 31 },
    { label = 'Bancos', mod = 32 },
    { label = 'Volante', mod = 33 },
    { label = 'Câmbio', mod = 34 },
    { label = 'Plaquinhas internas', mod = 35 },
    { label = 'Caixas de som', mod = 36 },
    { label = 'Porta-malas', mod = 37 },
    { label = 'Hidráulica', mod = 38 },
    { label = 'Bloco do motor', mod = 39 },
    { label = 'Filtro de ar', mod = 40 },
    { label = 'Strut bar', mod = 41 },
    { label = 'Faróis decorativos', mod = 42 },
    { label = 'Aéreos', mod = 43 },
    { label = 'Tanque', mod = 45 },
    { label = 'Vidros decorativos', mod = 46 },
    { label = 'Adesivos / Livery', mod = 48 }
}

local tuningMods = {
    { label = 'Motor', mod = 11 },
    { label = 'Freio', mod = 12 },
    { label = 'Transmissão', mod = 13 },
    { label = 'Suspensão', mod = 15 },
    { label = 'Blindagem', mod = 16 }
}

local function DrawTxt(x, y, w, h, scale, text, r, g, b, a, font, center)
    SetTextFont(font or 4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextCentre(center or false)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function DrawRectBox(x, y, w, h, r, g, b, a)
    DrawRect(x, y, w, h, r, g, b, a)
end

local function KeyboardInput(title, defaultText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', title)
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', defaultText or '', '', '', '', maxLength or 30)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end

    return nil
end

local function Notify(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

local function GetPlayerVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        return nil
    end

    if Config.OnlyDriver and GetPedInVehicleSeat(veh, -1) ~= ped then
        Notify('Você precisa estar no banco do motorista.')
        return nil
    end

    return veh
end

local function SetupVehicle(veh)
    SetVehicleModKit(veh, 0)
    SetVehicleDirtLevel(veh, 0.0)
end

local function SetupCam(veh)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end

    local coords = GetEntityCoords(veh)
    local heading = GetEntityHeading(veh)

    camRotZ = heading + 180.0
    camRotX = -15.0
    camDistance = 5.0
    camHeight = 1.5
    freeCam = false

    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    local rad = math.rad(camRotZ)
    local camX = coords.x + math.cos(rad) * camDistance
    local camY = coords.y + math.sin(rad) * camDistance
    local camZ = coords.z + camHeight

    SetCamCoord(cam, camX, camY, camZ)
    PointCamAtEntity(cam, veh, 0.0, 0.0, 0.4, true)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function SaveVehicleState(veh)
    if not veh or not DoesEntityExist(veh) then return nil end

    local primary, secondary = GetVehicleColours(veh)
    local pearlescent, wheelColor = GetVehicleExtraColours(veh)

    local customPrimary = { enabled = GetIsVehiclePrimaryColourCustom(veh) }
    local customSecondary = { enabled = GetIsVehicleSecondaryColourCustom(veh) }

    if customPrimary.enabled then
        local r, g, b = GetVehicleCustomPrimaryColour(veh)
        customPrimary.r = r
        customPrimary.g = g
        customPrimary.b = b
    end

    if customSecondary.enabled then
        local r, g, b = GetVehicleCustomSecondaryColour(veh)
        customSecondary.r = r
        customSecondary.g = g
        customSecondary.b = b
    end

    local mods = {}
    for i = 0, 49 do
        mods[i] = {
            mod = GetVehicleMod(veh, i),
            toggle = IsToggleModOn(veh, i)
        }
    end

    local extras = {}
    for i = 0, 20 do
        if DoesExtraExist(veh, i) then
            extras[i] = IsVehicleExtraTurnedOn(veh, i)
        end
    end

    local neon = {}
    for i = 0, 3 do
        neon[i] = IsVehicleNeonLightEnabled(veh, i)
    end

    local nr, ng, nb = GetVehicleNeonLightsColour(veh)
    local sr, sg, sb = GetVehicleTyreSmokeColor(veh)

    return {
        primary = primary,
        secondary = secondary,
        pearlescent = pearlescent,
        wheelColor = wheelColor,
        customPrimary = customPrimary,
        customSecondary = customSecondary,
        wheelType = GetVehicleWheelType(veh),
        windowTint = GetVehicleWindowTint(veh),
        plateIndex = GetVehicleNumberPlateTextIndex(veh),
        plateText = GetVehicleNumberPlateText(veh),
        livery = GetVehicleLivery(veh),
        mods = mods,
        extras = extras,
        neon = neon,
        neonColor = { r = nr, g = ng, b = nb },
        tyreSmoke = { r = sr, g = sg, b = sb }
    }
end

local function RestoreVehicleState(veh, state)
    if not veh or not DoesEntityExist(veh) or not state then return end

    SetVehicleModKit(veh, 0)

    ClearVehicleCustomPrimaryColour(veh)
    ClearVehicleCustomSecondaryColour(veh)

    SetVehicleColours(veh, state.primary, state.secondary)
    SetVehicleExtraColours(veh, state.pearlescent, state.wheelColor)

    if state.customPrimary and state.customPrimary.enabled then
        SetVehicleCustomPrimaryColour(veh, state.customPrimary.r, state.customPrimary.g, state.customPrimary.b)
    end

    if state.customSecondary and state.customSecondary.enabled then
        SetVehicleCustomSecondaryColour(veh, state.customSecondary.r, state.customSecondary.g, state.customSecondary.b)
    end

    SetVehicleWheelType(veh, state.wheelType)

    for i = 0, 49 do
        if state.mods[i] then
            SetVehicleMod(veh, i, state.mods[i].mod, customTires)
            ToggleVehicleMod(veh, i, state.mods[i].toggle)
        end
    end

    for i = 0, 20 do
        if state.extras[i] ~= nil then
            SetVehicleExtra(veh, i, state.extras[i] and 0 or 1)
        end
    end

    for i = 0, 3 do
        if state.neon[i] ~= nil then
            SetVehicleNeonLightEnabled(veh, i, state.neon[i])
        end
    end

    SetVehicleNeonLightsColour(veh, state.neonColor.r, state.neonColor.g, state.neonColor.b)
    SetVehicleTyreSmokeColor(veh, state.tyreSmoke.r, state.tyreSmoke.g, state.tyreSmoke.b)

    SetVehicleWindowTint(veh, state.windowTint)
    SetVehicleNumberPlateTextIndex(veh, state.plateIndex)
    SetVehicleNumberPlateText(veh, state.plateText)

    if state.livery and state.livery >= -1 then
        SetVehicleLivery(veh, state.livery)
    end
end

local function CommitPreview()
    if not currentVehicle or not DoesEntityExist(currentVehicle) then return end

    committedState = SaveVehicleState(currentVehicle)
    Notify('Modificação aplicada.')
end

local function PreviewSelectedItem()
    if not menuOpen or not currentVehicle or not DoesEntityExist(currentVehicle) then return end
    if not committedState then return end

    local items = BuildItems()
    local item = items[selectedIndex]

    RestoreVehicleState(currentVehicle, committedState)

    if item and item.preview then
        item.preview()
    end

    lastPreviewPage = currentPage
    lastPreviewIndex = selectedIndex
end

local function UpdateWorkshopCam()
    if not cam or not currentVehicle or not DoesEntityExist(currentVehicle) then
        return
    end

    local coords = GetEntityCoords(currentVehicle)

    if freeCam then
        local mouseX = GetDisabledControlNormal(0, 1)
        local mouseY = GetDisabledControlNormal(0, 2)

        camRotZ = camRotZ - mouseX * 6.0
        camRotX = camRotX - mouseY * 4.0

        if camRotX > 35.0 then camRotX = 35.0 end
        if camRotX < -45.0 then camRotX = -45.0 end

        if IsDisabledControlPressed(0, 241) then
            camDistance = camDistance - 0.15
        end

        if IsDisabledControlPressed(0, 242) then
            camDistance = camDistance + 0.15
        end

        if camDistance < 2.0 then camDistance = 2.0 end
        if camDistance > 9.0 then camDistance = 9.0 end
    end

    local radZ = math.rad(camRotZ)
    local radX = math.rad(camRotX)

    local horizontalDistance = camDistance * math.cos(radX)

    local camX = coords.x + math.cos(radZ) * horizontalDistance
    local camY = coords.y + math.sin(radZ) * horizontalDistance
    local camZ = coords.z + camHeight + camDistance * math.sin(radX)

    SetCamCoord(cam, camX, camY, camZ)
    PointCamAtEntity(cam, currentVehicle, 0.0, 0.0, 0.4, true)
end

local function DestroyWorkshopCam()
    if cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

local function OpenMenu()
    local veh = GetPlayerVehicle()

    if not veh then
        Notify('Entre em um veículo para abrir a oficina.')
        return
    end

    currentVehicle = veh
    SetupVehicle(currentVehicle)

    menuOpen = true
    currentPage = 'main'
    selectedIndex = 1
    pageHistory = {}

    committedState = SaveVehicleState(currentVehicle)
    lastPreviewPage = nil
    lastPreviewIndex = nil

    if Config.FreezeVehicle then
        FreezeEntityPosition(currentVehicle, true)
    end

    if Config.DisableVehicleCollision then
        SetEntityCollision(currentVehicle, false, false)
    end

    SetupCam(currentVehicle)

    Wait(100)
    PreviewSelectedItem()
end

local function CloseMenu()
    if currentVehicle and DoesEntityExist(currentVehicle) and committedState then
        RestoreVehicleState(currentVehicle, committedState)
    end

    menuOpen = false

    if currentVehicle and DoesEntityExist(currentVehicle) then
        FreezeEntityPosition(currentVehicle, false)

        if Config.DisableVehicleCollision then
            SetEntityCollision(currentVehicle, true, true)
        end
    end

    DestroyWorkshopCam()

    currentVehicle = nil
    selectedIndex = 1
    currentPage = 'main'
    pageHistory = {}

    committedState = nil
    lastPreviewPage = nil
    lastPreviewIndex = nil
end

local function PushPage(page)
    table.insert(pageHistory, currentPage)
    currentPage = page
    selectedIndex = 1
end

local function BackPage()
    if #pageHistory > 0 then
        currentPage = pageHistory[#pageHistory]
        table.remove(pageHistory, #pageHistory)
        selectedIndex = 1
    else
        CloseMenu()
    end
end

local function GetModLabel(modType, modIndex)
    if modIndex == -1 then
        return 'Original'
    end

    local label = GetModTextLabel(currentVehicle, modType, modIndex)

    if label and label ~= '' then
        local text = GetLabelText(label)

        if text and text ~= 'NULL' then
            return text
        end
    end

    return 'Opção ' .. tostring(modIndex + 1)
end

local function ApplyVehicleMod(modType, modIndex, silent)
    if not currentVehicle then return end

    SetupVehicle(currentVehicle)
    SetVehicleMod(currentVehicle, modType, modIndex, customTires)

    if not silent then
        Notify('Modificação aplicada.')
    end
end

local function ApplyClassicColor(slot, colorId, silent)
    if not currentVehicle then return end

    local primary, secondary = GetVehicleColours(currentVehicle)

    if slot == 'primary' then
        ClearVehicleCustomPrimaryColour(currentVehicle)
        SetVehicleColours(currentVehicle, colorId, secondary)
    elseif slot == 'secondary' then
        ClearVehicleCustomSecondaryColour(currentVehicle)
        SetVehicleColours(currentVehicle, primary, colorId)
    end

    if not silent then
        Notify('Cor aplicada.')
    end
end

local function ApplyPearlescent(colorId, silent)
    if not currentVehicle then return end

    local pearl, wheel = GetVehicleExtraColours(currentVehicle)
    SetVehicleExtraColours(currentVehicle, colorId, wheel)

    if not silent then
        Notify('Perolizado aplicado.')
    end
end

local function ApplyWheelColor(colorId, silent)
    if not currentVehicle then return end

    local pearl, wheel = GetVehicleExtraColours(currentVehicle)
    SetVehicleExtraColours(currentVehicle, pearl, colorId)

    if not silent then
        Notify('Cor da roda aplicada.')
    end
end

local function ApplyCustomRGB(slot)
    if not currentVehicle then return end

    local r = tonumber(KeyboardInput('Digite o R, de 0 a 255', '', 3))
    if not r then return end

    local g = tonumber(KeyboardInput('Digite o G, de 0 a 255', '', 3))
    if not g then return end

    local b = tonumber(KeyboardInput('Digite o B, de 0 a 255', '', 3))
    if not b then return end

    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))

    if slot == 'primary' then
        SetVehicleCustomPrimaryColour(currentVehicle, r, g, b)
    elseif slot == 'secondary' then
        SetVehicleCustomSecondaryColour(currentVehicle, r, g, b)
    end

    Notify('Cor RGB aplicada.')
end

local function ToggleTurbo()
    if not currentVehicle then return end

    local enabled = IsToggleModOn(currentVehicle, 18)
    ToggleVehicleMod(currentVehicle, 18, not enabled)

    Notify(enabled and 'Turbo removido.' or 'Turbo instalado.')
end

local function ToggleXenon()
    if not currentVehicle then return end

    local enabled = IsToggleModOn(currentVehicle, 22)
    ToggleVehicleMod(currentVehicle, 22, not enabled)

    Notify(enabled and 'Xenon removido.' or 'Xenon instalado.')
end

local function ToggleNeon()
    if not currentVehicle then return end

    local enabled = IsVehicleNeonLightEnabled(currentVehicle, 0)

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(currentVehicle, i, not enabled)
    end

    Notify(enabled and 'Neon desligado.' or 'Neon ligado.')
end

local function ApplyNeonColor(data)
    if not currentVehicle then return end

    SetVehicleNeonLightsColour(currentVehicle, data.r, data.g, data.b)

    for i = 0, 3 do
        SetVehicleNeonLightEnabled(currentVehicle, i, true)
    end

    Notify('Cor do neon aplicada.')
end

local function RepairCleanVehicle()
    if not currentVehicle then return end

    SetVehicleFixed(currentVehicle)
    SetVehicleDeformationFixed(currentVehicle)
    SetVehicleDirtLevel(currentVehicle, 0.0)

    Notify('Veículo reparado e limpo.')
end

BuildItems = function()
    local items = {}

    if currentPage == 'main' then
        items = {
            { label = 'Pintura', desc = 'Cores primárias, secundárias, RGB, perolizado e rodas.', page = 'paint' },
            { label = 'Rodas', desc = 'Tipos de roda, modelo da roda e pneu custom.', page = 'wheels' },
            { label = 'Tunagem', desc = 'Motor, freio, transmissão, suspensão, blindagem, turbo e xenon.', page = 'tuning' },
            { label = 'Visual / Bodykit', desc = 'Spoiler, para-choques, capô, escapamento, interior e outros mods.', page = 'body' },
            { label = 'Vidros e placas', desc = 'Insulfilm e tipo da placa.', page = 'windows_plates' },
            { label = 'Neon', desc = 'Liga/desliga neon e escolhe cor.', page = 'neon' },
            { label = 'Extras', desc = 'Ativar ou desativar extras do veículo.', page = 'extras' },
            { label = 'Liveries', desc = 'Adesivos/liveries nativas do veículo.', page = 'liveries' },
            { label = 'Reparar e limpar', desc = 'Repara o carro e remove sujeira.', action = RepairCleanVehicle },
            { label = 'Fechar oficina', desc = 'Sair do menu.', action = CloseMenu }
        }

    elseif currentPage == 'paint' then
        items = {
            { label = 'Cor primária clássica', desc = 'Escolher cor principal do veículo.', page = 'color_primary' },
            { label = 'Cor secundária clássica', desc = 'Escolher cor secundária do veículo.', page = 'color_secondary' },
            { label = 'Cor primária RGB', desc = 'Digite uma cor RGB manual.', action = function() ApplyCustomRGB('primary') end },
            { label = 'Cor secundária RGB', desc = 'Digite uma cor RGB manual.', action = function() ApplyCustomRGB('secondary') end },
            { label = 'Remover RGB primário', desc = 'Volta a usar cor clássica no primário.', action = function()
                ClearVehicleCustomPrimaryColour(currentVehicle)
                Notify('RGB primário removido.')
            end },
            { label = 'Remover RGB secundário', desc = 'Volta a usar cor clássica no secundário.', action = function()
                ClearVehicleCustomSecondaryColour(currentVehicle)
                Notify('RGB secundário removido.')
            end },
            { label = 'Perolizado', desc = 'Escolher cor do perolizado.', page = 'pearlescent' },
            { label = 'Cor das rodas', desc = 'Escolher cor das rodas.', page = 'wheel_color' }
        }

    elseif currentPage == 'color_primary' then
        for _, c in ipairs(classicColors) do
            table.insert(items, {
                label = c.label,
                desc = 'Pré-visualizar/aplicar como cor primária.',
                preview = function()
                    ApplyClassicColor('primary', c.id, true)
                end
            })
        end

    elseif currentPage == 'color_secondary' then
        for _, c in ipairs(classicColors) do
            table.insert(items, {
                label = c.label,
                desc = 'Pré-visualizar/aplicar como cor secundária.',
                preview = function()
                    ApplyClassicColor('secondary', c.id, true)
                end
            })
        end

    elseif currentPage == 'pearlescent' then
        for _, c in ipairs(classicColors) do
            table.insert(items, {
                label = c.label,
                desc = 'Pré-visualizar/aplicar como perolizado.',
                preview = function()
                    ApplyPearlescent(c.id, true)
                end
            })
        end

    elseif currentPage == 'wheel_color' then
        for _, c in ipairs(classicColors) do
            table.insert(items, {
                label = c.label,
                desc = 'Pré-visualizar/aplicar cor nas rodas.',
                preview = function()
                    ApplyWheelColor(c.id, true)
                end
            })
        end

    elseif currentPage == 'wheels' then
        items = {
            { label = 'Tipo de roda', desc = 'Categoria das rodas.', page = 'wheel_type' },
            { label = 'Rodas dianteiras', desc = 'Escolher modelo da roda.', page = 'mod_23' },
            { label = 'Rodas traseiras / moto', desc = 'Para motos ou veículos compatíveis.', page = 'mod_24' },
            { label = customTires and 'Pneu custom: ligado' or 'Pneu custom: desligado', desc = 'Alternar pneu custom.', action = function()
                customTires = not customTires
                Notify(customTires and 'Pneu custom ligado.' or 'Pneu custom desligado.')
            end },
            { label = 'Fumaça dos pneus - branca', desc = 'Aplicar fumaça branca.', action = function()
                ToggleVehicleMod(currentVehicle, 20, true)
                SetVehicleTyreSmokeColor(currentVehicle, 255, 255, 255)
                Notify('Fumaça branca aplicada.')
            end },
            { label = 'Fumaça dos pneus - vermelha', desc = 'Aplicar fumaça vermelha.', action = function()
                ToggleVehicleMod(currentVehicle, 20, true)
                SetVehicleTyreSmokeColor(currentVehicle, 255, 0, 0)
                Notify('Fumaça vermelha aplicada.')
            end },
            { label = 'Fumaça dos pneus - azul', desc = 'Aplicar fumaça azul.', action = function()
                ToggleVehicleMod(currentVehicle, 20, true)
                SetVehicleTyreSmokeColor(currentVehicle, 0, 0, 255)
                Notify('Fumaça azul aplicada.')
            end },
            { label = 'Fumaça dos pneus - verde', desc = 'Aplicar fumaça verde.', action = function()
                ToggleVehicleMod(currentVehicle, 20, true)
                SetVehicleTyreSmokeColor(currentVehicle, 0, 255, 0)
                Notify('Fumaça verde aplicada.')
            end }
        }

    elseif currentPage == 'wheel_type' then
        for _, w in ipairs(wheelTypes) do
            table.insert(items, {
                label = w.label,
                desc = 'Pré-visualizar categoria das rodas. ENTER abre os modelos.',
                preview = function()
                    SetVehicleWheelType(currentVehicle, w.id)
                end,
                action = function()
                    SetVehicleWheelType(currentVehicle, w.id)
                    CommitPreview()

                    currentPage = 'mod_23'
                    selectedIndex = 1

                    Wait(1)
                    PreviewSelectedItem()
                end
            })
        end

    elseif currentPage == 'tuning' then
        for _, t in ipairs(tuningMods) do
            table.insert(items, {
                label = t.label,
                desc = 'Escolher nível de ' .. t.label .. '.',
                page = 'mod_' .. tostring(t.mod)
            })
        end

        table.insert(items, {
            label = IsToggleModOn(currentVehicle, 18) and 'Turbo: instalado' or 'Turbo: original',
            desc = 'Ativar/desativar turbo.',
            action = ToggleTurbo
        })

        table.insert(items, {
            label = IsToggleModOn(currentVehicle, 22) and 'Xenon: instalado' or 'Xenon: original',
            desc = 'Ativar/desativar farol xenon.',
            action = ToggleXenon
        })

    elseif currentPage == 'body' then
        for _, m in ipairs(modCategories) do
            local amount = GetNumVehicleMods(currentVehicle, m.mod)

            if amount and amount > 0 then
                table.insert(items, {
                    label = m.label,
                    desc = 'Quantidade disponível: ' .. tostring(amount),
                    page = 'mod_' .. tostring(m.mod)
                })
            end
        end

        if #items == 0 then
            table.insert(items, {
                label = 'Nenhuma opção disponível',
                desc = 'Este veículo não possui bodykit detectado.',
                action = function() end
            })
        end

    elseif currentPage == 'windows_plates' then
        items = {
            { label = 'Insulfilm / Vidros', desc = 'Alterar transparência dos vidros.', page = 'window_tint' },
            { label = 'Tipo da placa', desc = 'Alterar modelo da placa.', page = 'plate_type' },
            { label = 'Texto da placa', desc = 'Definir texto personalizado.', action = function()
                local text = KeyboardInput('Digite a placa', GetVehicleNumberPlateText(currentVehicle), 8)

                if text then
                    SetVehicleNumberPlateText(currentVehicle, string.upper(text))
                    Notify('Texto da placa alterado.')
                end
            end }
        }

    elseif currentPage == 'window_tint' then
        for _, t in ipairs(windowTints) do
            table.insert(items, {
                label = t.label,
                desc = 'Pré-visualizar/aplicar este insulfilm.',
                preview = function()
                    SetVehicleWindowTint(currentVehicle, t.id)
                end
            })
        end

    elseif currentPage == 'plate_type' then
        for _, p in ipairs(plateTypes) do
            table.insert(items, {
                label = p.label,
                desc = 'Pré-visualizar/aplicar este tipo de placa.',
                preview = function()
                    SetVehicleNumberPlateTextIndex(currentVehicle, p.id)
                end
            })
        end

    elseif currentPage == 'neon' then
        items = {
            {
                label = IsVehicleNeonLightEnabled(currentVehicle, 0) and 'Neon: ligado' or 'Neon: desligado',
                desc = 'Ativar/desativar neon em todos os lados.',
                action = ToggleNeon
            }
        }

        for _, n in ipairs(neonColors) do
            table.insert(items, {
                label = n.label,
                desc = 'Pré-visualizar/aplicar cor do neon.',
                preview = function()
                    SetVehicleNeonLightsColour(currentVehicle, n.r, n.g, n.b)

                    for i = 0, 3 do
                        SetVehicleNeonLightEnabled(currentVehicle, i, true)
                    end
                end
            })
        end

    elseif currentPage == 'extras' then
        for i = 0, 20 do
            if DoesExtraExist(currentVehicle, i) then
                local enabled = IsVehicleExtraTurnedOn(currentVehicle, i)

                table.insert(items, {
                    label = enabled and ('Extra ' .. i .. ': ligado') or ('Extra ' .. i .. ': desligado'),
                    desc = 'Ativar/desativar extra ' .. i .. '.',
                    action = function()
                        local isOn = IsVehicleExtraTurnedOn(currentVehicle, i)
                        SetVehicleExtra(currentVehicle, i, isOn and 1 or 0)
                        Notify('Extra alterado.')
                    end
                })
            end
        end

        if #items == 0 then
            table.insert(items, {
                label = 'Nenhum extra disponível',
                desc = 'Este veículo não possui extras detectados.',
                action = function() end
            })
        end

    elseif currentPage == 'liveries' then
        local count = GetVehicleLiveryCount(currentVehicle)

        if count and count > 0 then
            table.insert(items, {
                label = 'Original',
                desc = 'Pré-visualizar/remover livery.',
                preview = function()
                    SetVehicleLivery(currentVehicle, -1)
                end
            })

            for i = 0, count - 1 do
                table.insert(items, {
                    label = 'Livery ' .. tostring(i + 1),
                    desc = 'Pré-visualizar/aplicar livery.',
                    preview = function()
                        SetVehicleLivery(currentVehicle, i)
                    end
                })
            end
        else
            local amount = GetNumVehicleMods(currentVehicle, 48)

            if amount and amount > 0 then
                table.insert(items, {
                    label = 'Original',
                    desc = 'Pré-visualizar/remover livery.',
                    preview = function()
                        ApplyVehicleMod(48, -1, true)
                    end
                })

                for i = 0, amount - 1 do
                    table.insert(items, {
                        label = GetModLabel(48, i),
                        desc = 'Pré-visualizar/aplicar livery.',
                        preview = function()
                            ApplyVehicleMod(48, i, true)
                        end
                    })
                end
            else
                table.insert(items, {
                    label = 'Nenhuma livery disponível',
                    desc = 'Este veículo não possui livery detectada.',
                    action = function() end
                })
            end
        end

    elseif string.sub(currentPage, 1, 4) == 'mod_' then
        local modType = tonumber(string.sub(currentPage, 5))
        local count = GetNumVehicleMods(currentVehicle, modType)
        local current = GetVehicleMod(currentVehicle, modType)

        table.insert(items, {
            label = current == -1 and 'Original  ✓' or 'Original',
            desc = 'Pré-visualizar/remover esta modificação.',
            preview = function()
                ApplyVehicleMod(modType, -1, true)
            end
        })

        if count and count > 0 then
            for i = 0, count - 1 do
                local label = GetModLabel(modType, i)

                if current == i then
                    label = label .. '  ✓'
                end

                table.insert(items, {
                    label = label,
                    desc = 'Pré-visualizar/aplicar esta opção.',
                    preview = function()
                        ApplyVehicleMod(modType, i, true)
                    end
                })
            end
        end
    end
    return items
end

local function DrawMenu()
    local items = BuildItems()
    local maxVisible = 10

    if selectedIndex < 1 then
        selectedIndex = #items
    elseif selectedIndex > #items then
        selectedIndex = 1
    end

    local x = 0.175
    local y = 0.16
    local width = 0.32
    local headerHeight = 0.095
    local itemHeight = 0.045

    DrawRectBox(x, y, width, headerHeight, 10, 10, 10, 240)

    DrawTxt(
        x - width / 2 + 0.014,
        y - 0.035,
        width,
        headerHeight,
        0.62,
        Config.MenuTitle,
        255, 255, 255, 255,
        4,
        false
    )

    DrawTxt(
        x - width / 2 + 0.014,
        y + 0.008,
        width,
        headerHeight,
        0.36,
        Config.MenuSubtitle,
        190, 190, 190, 255,
        4,
        false
    )

    local startIndex = 1

    if selectedIndex > maxVisible then
        startIndex = selectedIndex - maxVisible + 1
    end

    local visibleCount = math.min(maxVisible, #items)

    for i = 0, visibleCount - 1 do
        local itemIndex = startIndex + i
        local item = items[itemIndex]

        if item then
            local itemY = y + headerHeight / 2 + 0.026 + itemHeight * i
            local selected = itemIndex == selectedIndex

            if selected then
                DrawRectBox(x, itemY, width, itemHeight, 255, 255, 255, 235)

                DrawTxt(
                    x - width / 2 + 0.014,
                    itemY - 0.017,
                    width,
                    itemHeight,
                    0.40,
                    item.label,
                    0, 0, 0, 255,
                    4,
                    false
                )
            else
                DrawRectBox(x, itemY, width, itemHeight, 20, 20, 20, 215)

                DrawTxt(
                    x - width / 2 + 0.014,
                    itemY - 0.017,
                    width,
                    itemHeight,
                    0.40,
                    item.label,
                    235, 235, 235, 255,
                    4,
                    false
                )
            end

            if item.page then
                DrawTxt(
                    x + width / 2 - 0.030,
                    itemY - 0.017,
                    width,
                    itemHeight,
                    0.40,
                    '>',
                    selected and 0 or 255,
                    selected and 0 or 255,
                    selected and 0 or 255,
                    255,
                    4,
                    false
                )
            end
        end
    end

    local footerY = y + headerHeight / 2 + 0.026 + itemHeight * visibleCount + 0.025

    DrawRectBox(x, footerY, width, 0.075, 10, 10, 10, 230)

    local selectedItem = items[selectedIndex]

    if selectedItem then
        DrawTxt(
            x - width / 2 + 0.014,
            footerY - 0.030,
            width,
            0.05,
            0.32,
            selectedItem.desc or '',
            220, 220, 220, 255,
            4,
            false
        )
    end

    local camText = freeCam and 'H travar câmera' or 'H liberar câmera'

    DrawTxt(
        x - width / 2 + 0.014,
        footerY + 0.002,
        width,
        0.05,
        0.29,
        '↑ ↓ navegar  |  ENTER aplicar  |  BACKSPACE voltar  |  ' .. camText,
        175, 175, 175, 255,
        4,
        false
    )
end

local function HandleControls()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 75, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(0, 241, true)
    DisableControlAction(0, 242, true)

    local changedSelection = false

    if IsControlJustPressed(0, 74) or IsDisabledControlJustPressed(0, 74) then
        freeCam = not freeCam

        if freeCam then
            Notify('Câmera livre ativada. Mova o mouse e use scroll para zoom.')
        else
            Notify('Câmera travada nesta posição.')
        end
    end

    if IsDisabledControlJustPressed(0, 172) then
        selectedIndex = selectedIndex - 1
        changedSelection = true
    end

    if IsDisabledControlJustPressed(0, 173) then
        selectedIndex = selectedIndex + 1
        changedSelection = true
    end

    if changedSelection then
        Wait(1)
        PreviewSelectedItem()
    end

    if IsDisabledControlJustPressed(0, 191) then
        local items = BuildItems()
        local item = items[selectedIndex]

        if item then
            if item.page then
                PushPage(item.page)
                Wait(1)
                PreviewSelectedItem()
            elseif item.preview then
                item.preview()
                CommitPreview()
            elseif item.action then
                item.action()

                if currentVehicle and DoesEntityExist(currentVehicle) then
                    committedState = SaveVehicleState(currentVehicle)
                end
            end
        end
    end

    if IsDisabledControlJustPressed(0, 177) then
        if currentVehicle and DoesEntityExist(currentVehicle) and committedState then
            RestoreVehicleState(currentVehicle, committedState)
        end

        BackPage()

        Wait(1)
        PreviewSelectedItem()
    end
end

RegisterCommand(Config.Command, function()
    if menuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end)

CreateThread(function()
    while true do
        local sleep = 500

        if Config.UseMarker then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local dist = #(coords - Config.Marker.coords)

            if dist <= Config.DrawDistance then
                sleep = 0

                DrawMarker(
                    1,
                    Config.Marker.coords.x,
                    Config.Marker.coords.y,
                    Config.Marker.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    2.5, 2.5, 0.6,
                    255, 255, 255, 120,
                    false, true, 2, false, nil, nil, false
                )

                if dist <= Config.Marker.openDistance then
                    DrawTxt(0.5, 0.88, 0.0, 0.0, 0.34, 'Pressione ~INPUT_CONTEXT~ para abrir a Benny’s Workshop', 255, 255, 255, 255, 4, true)

                    if IsControlJustPressed(0, 38) then
                        OpenMenu()
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if menuOpen then
            Wait(0)

            if not currentVehicle or not DoesEntityExist(currentVehicle) then
                CloseMenu()
            else
                DrawMenu()
                HandleControls()
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if menuOpen and currentVehicle and DoesEntityExist(currentVehicle) then
            Wait(0)
            UpdateWorkshopCam()
        else
            Wait(500)
        end
    end
end)

local function DeleteCurrentVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh == 0 then
        local coords = GetEntityCoords(ped)
        veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
    end

    if veh == 0 or not DoesEntityExist(veh) then
        Notify('Nenhum veículo encontrado para deletar.')
        return
    end

    NetworkRequestControlOfEntity(veh)

    local timeout = 0
    while not NetworkHasControlOfEntity(veh) and timeout < 50 do
        Wait(10)
        NetworkRequestControlOfEntity(veh)
        timeout = timeout + 1
    end

    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)

    if DoesEntityExist(veh) then
        DeleteEntity(veh)
    end

    Notify('Veículo deletado.')
end

RegisterCommand('dv', function()
    DeleteCurrentVehicle()
end)

RegisterCommand('delveh', function()
    DeleteCurrentVehicle()
end)