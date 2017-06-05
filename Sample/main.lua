local widget = require( "widget" )

-- Import for Vungle ads
local ads = require "ads"

-- Change this to your App ID. You will need
-- separate App IDs for Android and iOS:
--local appID = "Test_Android"
local appID = "Test_iOS"

_H = display.contentHeight
_W = display.contentWidth

-- We recommend hiding the status bar so our
-- full-screen videos are not obstructed
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 1 )

local vungleLogo = display.newImage( "images/vungleLogo.png" )
vungleLogo:translate( _W / 3, 0 )
local vungleLogo = display.newImage( "images/corona.jpg" )
vungleLogo:translate( _W / 1.5, 0 )

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
    if ( event.type == "adStart" and event.isError ) then
        -- Ad has not finished caching and will not play
    end
    if ( event.type == "adStart" and not event.isError ) then
        -- Ad will play
        defaultAdButton:setLabel ( "Please wait.." )
        defaultAdButton:setEnabled ( false )
        incentivizedAdButton:setLabel ( "a video should" )
        incentivizedAdButton:setEnabled ( false )
        customAdButton:setLabel ( "be ready soon!" )
        customAdButton:setEnabled ( false )
    end
    if ( event.type == "cachedAdAvailable" ) then
        -- Ad has finished caching and is ready to play
        defaultAdButton:setLabel( "Play Default Ad" )
        defaultAdButton:setEnabled( true )
        incentivizedAdButton:setLabel ( "Play Incentivized Ad" )
        incentivizedAdButton:setEnabled ( true )
        customAdButton:setLabel ( "Play Custom Ad" )
        customAdButton:setEnabled ( true )
    end
    if ( event.type == "adView" ) then
        -- An ad has completed
    end
    if ( event.type == "adEnd" ) then
        -- The ad experience has been closed- this
        -- is a good place to resume your app
    end
end

-- Do this as early as possible in your app
-- An ad will begin caching on init and it can take
-- up to 30 seconds before it is ready to play
ads.init( "vungle", appID, vungleAdListener )

-- Your app logic here :)