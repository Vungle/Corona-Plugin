local widget = require( "widget" )

local ads = require "plugin.vungle"

_H = display.contentHeight
_W = display.contentWidth

platform = system.getInfo( "platformName" )
local eh = 30
local fontSize = 20
if ("Android" == platform) then
    eh = _H/15
    fontSize = eh/2
end
local ew = display.contentWidth - 20
local pos = 30
--platform = "Android"

local margin = 10
placements = {}

if (platform == "Android") then
    appData = {
        appID="592754a11cb660c05500000b",
        placements={"DEFAULT62446","PLACEME67081","PLACEME06478"}
    }
else
    appData = {
        appID="592757da73883d212c00000b",
        placements={"DEFAULT34708","PLACEME99234","PLACEME40182"}
    }
end
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 0.5 )

main = display.newGroup()

local function addButton(event, label, enable, y)
    return widget.newButton {
        onEvent = event,
        label = label,
        defaultFile = "buttonDefault.png",
        overFile = "buttonSelected.png",
        width = ew,
        height = eh,
        fontSize = fontSize,
        isEnabled = enable,
        x = _W / 2,
        y = y
    }
end

local function setEnabled(button, enabled)
    if (enabled) then
        button:setEnabled(true)
        button:setFillColor(0.23, 0.5, 0.7)
    else
        button:setEnabled(false)
        button:setFillColor(0.5, 0.5, 0.5)
    end
end

-- AD EVENT LISTENER
-- Set this up before ads.init
local function vungleAdListener( event )
    if ( event.type == "adStart" and event.isError ) then
        -- Ad has not finished caching and will not play
    end
    if ( event.type == "adLog") then
    end
    if ( event.type == "adInitialize") then
        setEnabled(loadButton2, true)
        setEnabled(loadButton3, true)
    end
    if ( event.type == "adAvailable" ) then
        if (event.placementID == appData.placements[1]) then
            setEnabled(playButton1, event.isAdPlayable)
        end
        if (event.placementID == appData.placements[2]) then
            setEnabled(playButton2, event.isAdPlayable)
        end
        if (event.placementID == appData.placements[3]) then
            setEnabled(playButton3, event.isAdPlayable)
        end
    end
    if ( event.type == "adEnd" ) then
    end
    if ( event.type == "vungleSDKlog" ) then
        print(event)
        logText.text = event.message
    end
end

main:insert( display.newText( { text = "", x = _W/2, y = 0, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
local logo = display.newImageRect( main, "VungleLogo.png", ew/4, ew/4/200*81)
logo.x, logo.y = _W/2, pos/1.7
pos = pos + eh + margin
main:insert( display.newText( { text = "App ID:" .. appData.appID, x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
local function handleInit( event )
    if ( "ended" == event.phase ) then
        ads.init("vungle", appData.appID .. "," .. appData.placements[1] .. "," .. appData.placements[2] .. "," .. appData.placements[3], vungleAdListener)
    end
end

local initButton = addButton(handleInit, "Init", true, pos)
initButton:setFillColor(0.1, 0.5, 0.4)
main:insert( initButton )
pos = pos + eh + margin

--!!!!!!!1
main:insert( display.newText( { text = "Placement1", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = "PlacementID: " .. appData.placements[1], x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
local function handlePlay1( event )
    if ( "ended" == event.phase ) then
    ads.show({
        placementId = appData.placements[1],
    })
    end
end
playButton1 = addButton(handlePlay1, "Play Ad", false, pos)
setEnabled(playButton1, false)
main:insert( playButton1 )
pos = pos + eh + margin

--!!!!!!!2
main:insert( display.newText( { text = "Placement2", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = "PlacementID: " .. appData.placements[2], x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
local function handlePlay2( event )
if ( "ended" == event.phase ) then
ads.show({
placementId = appData.placements[2],
})
end
end
playButton2 = addButton(handlePlay2, "Play Ad", false, pos)
main:insert( playButton2 )
setEnabled(playButton2, false)
pos = pos + eh + margin
local function handleLoad2( event )
    ads.load(appData.placements[2])
end
loadButton2 = addButton(handleLoad2, "Load Ad", false, pos)
setEnabled(loadButton2, false)
main:insert( loadButton2 )
pos = pos + eh + margin

--!!!!!!!3
main:insert( display.newText( { text = "Placement3", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = "PlacementID: " .. appData.placements[3], x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
local function handlePlay3( event )
if ( "ended" == event.phase ) then
ads.show({
placementId = appData.placements[3],
})
end
end
playButton3 = addButton(handlePlay3, "Play Ad", false, pos)
setEnabled(playButton3, false)
main:insert( playButton3 )
pos = pos + eh + margin
local function handleLoad3( event )
ads.load(appData.placements[3])
end
loadButton3 = addButton(handleLoad3, "Load Ad", false, pos)
setEnabled(loadButton3, false)
main:insert( loadButton3 )
pos = pos + eh + margin
