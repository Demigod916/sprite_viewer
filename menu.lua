local sprite_textures = require 'data'

local dictionaries = {}

for dict, textures in pairs(sprite_textures) do
    dictionaries[#dictionaries + 1] = dict
end

table.sort(dictionaries, function(a, b)
    return a:lower() < b:lower()
end)

local currentDictionary, currentTexture

local function registerMenu(dictionary, currentDictIndex)
    lib.registerMenu({
        id = 'texture_viewer',
        title = 'Sprite Textures',
        position = 'top-right',
        onSideScroll = function(selected, scrollIndex, args)
            if selected == 1 then
                local newdictionary = dictionaries[scrollIndex]
                currentDictionary, currentTexture = newdictionary, sprite_textures[newdictionary][1]
                print(currentDictionary)
                lib.requestStreamedTextureDict(currentDictionary)
                registerMenu(dictionaries[scrollIndex], scrollIndex)
                lib.hideMenu()
                Wait(50)
                lib.showMenu('texture_viewer')
            end
            if selected == 2 then
                print(currentDictionary, selected, scrollIndex, args)
                currentTexture = sprite_textures[currentDictionary][scrollIndex]
            end
        end,
        onClose = function()
            currentDictionary, currentTexture = nil, nil
        end,
        options = {
            { label = 'dictionary', values = dictionaries,                defaultIndex = currentDictIndex },
            { label = 'texture',    values = sprite_textures[dictionary], defaultIndex = 1 },
        }
    }, function(selected, scrollIndex, args, checked)
        currentDictionary, currentTexture = nil, nil
    end)
end

registerMenu(dictionaries[1])

RegisterCommand('spriteviewer', function()
    currentDictionary = dictionaries[1]
    currentTexture = sprite_textures[currentDictionary][1]
    lib.requestStreamedTextureDict(currentDictionary)
    lib.showMenu('texture_viewer')
    while currentDictionary and currentTexture do
        Wait(0)
        DrawSprite('commonmenu', 'gradient_bgd', 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
        DrawSprite(currentDictionary, currentTexture, 0.5, 0.5, 0.5, 0.5, 0.0, 255, 255, 255, 255)
    end
end)
