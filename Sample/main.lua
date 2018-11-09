local widget = require( "widget" )
local ads = require ( "plugin.vungle" )

-- Change this to your App ID. You will need
-- separate App IDs for Android and iOS:
--local appID = "Test_Android"
local appID = "Test_iOS"

_H = display.contentHeight
_W = display.contentWidth

platform = system.getInfo( "platformName" )
local eh = 20
local fontSize = 15
if ("Android" == platform) then
    eh = _H/20
    fontSize = eh/2
end
local ew = display.contentWidth - 20
local pos = 30
local margin = 10

if (platform == "Android") then
    appData = {
        appID="5ae0db55e2d43668c97bd65e",
        placement1 = "DEFAULT-6595425",
        placement2 = "DYNAMIC_TEMPLATE_REWARDED-5271535",
        placement3 = "FLEX_VIEW-4423991"
    }
else
    appData = {
        appID="5af083df47c10a604be1ceb3",
        placement1 = "DEFAULT-0547777",
        placement2 = "DYNAMIC_TEMPLATE_REWARDED-1243369",
        placement3 = "FLEX_VIEW-4449334"
    }
end

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 0.5 )
main = display.newGroup()

-- DEFAULT ADS:
local function handleDefaultAdPlay( event )
    if ( "ended" == event.phase ) then
        ads.show( "interstitial" )
    end
end
local defaultAdButton = widget.newButton {
    defaultFile = "images/sfSky.jpg",
    onRelease = handleDefaultAdPlay,
    -- While ads are caching, our buttons are disabled
    -- and inform the user to please wait
    label = "Please wait..",
    labelColor = { default={ 255, 255, 255, 1.0 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 36,
    isEnabled = false,
    x = _W / 2,
    y = _H / 6 + 35
}

-- INCENTIVIZED ADS:
local function handleIncentivizedAdPlay( event )
    if ( "ended" == event.phase ) then
        -- On click, we call ads.show()
        ads.show( "incentivized" )
    end
end
local incentivizedAdButton = widget.newButton {
    defaultFile = "images/berlinSky.jpg",
    onRelease = handleIncentivizedAdPlay,
    label = "a video should",
    labelColor = { default={ 255, 255, 255, 1.0 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 36,
    isEnabled = false,
    x = _W / 2,
    y = _H / 2 + 40
}

-- CUSTOM ADS:
local function handleCustomAdPlay( event )
    if ( "ended" == event.phase ) then
        ads.show( "incentivized", { isAnimated = true, 
                                    isAutoRotation = false,
                                    orientations = UIInterfaceOrientationMaskLandscape,
                                    isBackButtonEnabled = true,
                                    isSoundEnabled = false,
                                    -- username is used for incentivized ads
                                    -- (so we know who to reward)
                                    username = "someUsername123" })
    end
end
local customAdButton = widget.newButton {
    defaultFile = "images/londonSky.jpg",
    onRelease = handleCustomAdPlay,
    label = "be ready soon!",
    labelColor = { default={ 255, 255, 255, 1.0 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 36,
    isEnabled = false,
    x = _W / 2,
    y = _H / 1.2 + 45
}
-- AD EVENT LISTENER
-- Set this up before ads.init
local function vungleAdListener( event )
    if ( event.type == "adStart" and not event.isError) then
        print("adStart: " .. tostring(event.placementID))
    end
    if ( event.type == "adStart" and event.isError ) then
        -- Ad has not finished caching and will not play
        print("adStart: Error playing " .. tostring(event.placementID) .. " - " .. tostring(event.message))
    end

    if ( event.type == "adLog") then
        print("adLog: " .. tostring(event.message))
    end
    if ( event.type == "adInitialize") then
        print("adInitialize")

        -- Set GDPR consent status
        -- ads.updateConsentStatus(1, "corona consent v1.0") -- Opted_in
        -- ads.updateConsentStatus(2, "corona consent v1.0") -- Opted_out
        -- status = vungle.getConsentStatus() -- Get consent status
        -- consentVersionTxt = vungle.getConsentMessageVersion() -- Get consent version string

        setEnabled(loadButton2, true)
        setEnabled(loadButton3, true)
    end
    if ( event.type == "adAvailable" ) then
        print("adAvailable: " .. tostring(event.placementID) .. ", isAvailable: " .. tostring(event.isAdPlayable))
        if (event.placementID == appData.placement1) then
            setEnabled(playButton1, event.isAdPlayable)
        end
        if (event.placementID == appData.placement2) then
            setEnabled(playButton2, event.isAdPlayable)
        end
        if (event.placementID == appData.placement3) then
            setEnabled(playButton3, event.isAdPlayable)
        end
    end
    if ( event.type == "adEnd" ) then
        print("adEnd")
        print("placementID: " .. tostring(event.placementID))
        print("didDownload: " .. tostring(event.didDownload))
        print("completed: " .. tostring(event.completedView))
    end
    if ( event.type == "vungleSDKlog" ) then
        print("vungleSDKlog: " .. tostring(event.message))
    end
end

main:insert( display.newText( { text = "", x = _W/2, y = 0, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
local logo = display.newImageRect( main, "VungleLogo.png", ew/4, ew/4/200*81)
logo.x, logo.y = _W/2, pos/1.7
pos = pos + eh + margin
main:insert( display.newText( { text = appData.appID, x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin

local function handleInit( event )
    print("Initializing...")
    if ( "ended" == event.phase ) then
        ads.init("vungle", appData.appID, vungleAdListener)
    end
end

local initButton = addButton(handleInit, "Init", true, pos)
initButton:setFillColor(0.1, 0.5, 0.4)
main:insert( initButton )
pos = pos + eh + margin

-- 1
main:insert( display.newText( { text = "Placement1", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = appData.placement1, x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin

local function handlePlay1( event )
    if ( "ended" == event.phase ) then
        print("Play Ad: " .. tostring(appData.placement1))
        ads.show( { placementId = appData.placement1 } )
    end
end

playButton1 = addButton(handlePlay1, "Play Ad", false, pos)
setEnabled(playButton1, false)
main:insert( playButton1 )
pos = pos + eh + margin

-- 2
main:insert( display.newText( { text = "Placement2", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = appData.placement2, x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin

local function handlePlay2( event )
    print("Play Ad: " .. tostring(appData.placement2))
    if ( "ended" == event.phase ) then
        if (platform == "Android") then
            options = {
                placementId = appData.placement2,
                isAutoRotation = true,
                immersive = true,
                isSoundEnabled = true
            }
        else
            options = {
                placementId = appData.placement2,
                large = true,
                isSoundEnabled = true,
                ordinal = "7"
            }
            options.orientation = 4
        end

        options.userTag = "vungle_test_user"
        options.alertTitle = "test_title"
        options.alertText = "test_text"
        options.alertClose = "test_close"
        options.alertContinue = "test_continue"

        ads.show(options)
    end
end

playButton2 = addButton(handlePlay2, "Play Ad", false, pos)
main:insert( playButton2 )
setEnabled(playButton2, false)
pos = pos + eh + margin

local function handleLoad2( event )
    print("LoadAd: " .. tostring(appData.placement2))
    ads.load(appData.placement2)
end

loadButton2 = addButton(handleLoad2, "Load Ad", false, pos)
setEnabled(loadButton2, false)
main:insert( loadButton2 )
pos = pos + eh + margin

-- 3
main:insert( display.newText( { text = "Placement3", x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin
main:insert( display.newText( { text = "PlacementID: " .. appData.placement3, x = _W/2, y = pos, font = native.systemFont, width = ew, height = eh, fontSize = fontSize, align = "center" } ) )
pos = pos + eh + margin

local function handlePlay3( event )
    if ( "ended" == event.phase ) then
        options = {
            placementId = appData.placement3,
            flexCloseSec = "5",
        }

        ads.show(options)
    end

end

playButton3 = addButton(handlePlay3, "Play Ad", false, pos)
setEnabled(playButton3, false)
main:insert( playButton3 )
pos = pos + eh + margin

local function handleLoad3( event )
    print("Load Ad: " .. tostring(appData.placement3))
    ads.load(appData.placement3)
end

loadButton3 = addButton(handleLoad3, "Load Ad", false, pos)
setEnabled(loadButton3, false)
main:insert( loadButton3 )
pos = pos + eh + margin
