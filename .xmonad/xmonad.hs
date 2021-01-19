--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Tabbed
import XMonad.Layout.Gaps
import XMonad.ManageHook
import XMonad.Util.NamedScratchpad
-- import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Actions.WindowGo
import XMonad.Actions.GroupNavigation
import XMonad.Layout.Fullscreen
import XMonad.Layout.MultiToggle
import XMonad.Layout.SubLayouts
import XMonad.Layout.Master
-- import XMonad.Layout.WindowNavigation
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Renamed
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.SpawnOnce
import XMonad.Layout.Simplest
import XMonad.Hooks.DynamicLog
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 4

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#4c566a"
myFocusedBorderColor = "#81a1c1"

-- Tab configuration
myTabTheme = def {
-- activeBorderWidth = 0,
-- inactiveBorderWidth = 0,
-- urgentBorderWidth = 0,
   inactiveColor = "#3B4252",
   urgentColor = "#3B4252",
   activeColor = "#2E3440",
   inactiveBorderColor = "#3B4252",
   urgentBorderColor = "#3B4252",
   activeBorderColor = "#2E3440",
   activeTextColor = "#D8DEE9",
   inactiveTextColor = "#D8DEE9" ,
   urgentTextColor = "#D8DEE9",
   fontName = "xft:IBM Plex Sans:size=10:style=Regular"
   }


-- Scratchpads
scratchpads = [
      NS "scratchpad" "st -c scratch" (className =? "scratch") (customFloating $ W.RationalRect (2/6) (2/6) (2/6) (2/6))
    , NS "ncmpcpp" "st -c MusicPlayer -e ncmpcpp" (className =? "MusicPlayer") (customFloating $ W.RationalRect 0.66 0.01 (2/6) (2/6))
    , NS "pavu" "pavucontrol" (className =? "Pavucontrol") (customFloating $ W.RationalRect (1/3) (1/3) (1/3) (1/3))
    , NS "discord" "Discord" (className =? "discord") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ]
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_d     ), spawn "run")

    -- Restart
    , ((modm,               xK_r     ), spawn "xmonad --recompile && xmonad --restart")

    , ((modm,               xK_e     ), spawn "sendinfo")
    -- close focused window
    , ((modm , xK_q     ), kill)
-- Rotate through the available layout algorithms 
    , ((modm,               xK_space ), sendMessage NextLayout)
        
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm , xK_Tab), nextMatch Backward (return True))

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- , ((modm,                 xK_l),    sendMessage $ Go R)
    -- , ((modm,                 xK_h),    sendMessage $ Go L)
    -- , ((modm,                 xK_k),    sendMessage $ Go U)
    -- , ((modm,                 xK_j),    sendMessage $ Go D)
    -- , ((modm .|. shiftMask, xK_l),    sendMessage $ Swap R)
    -- , ((modm .|. shiftMask, xK_h),    sendMessage $ Swap L)
    -- , ((modm .|. shiftMask, xK_k),    sendMessage $ Swap U)
    -- , ((modm .|. shiftMask, xK_j),    sendMessage $ Swap D)

    -- -- , ((modm,                 xK_r),    sendMessage  Rotate)
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Scratchpads
    , ((modm , xK_u), namedScratchpadAction scratchpads "scratchpad")
    , ((modm .|. shiftMask, xK_u), namedScratchpadAction scratchpads "ncmpcpp")
    , ((modm , xK_p), namedScratchpadAction scratchpads "pavu")
    , ((modm .|. shiftMask, xK_d), namedScratchpadAction scratchpads "discord")

    -- Firefox
    , ((modm , xK_w), runOrRaise "firefox" (className =? "Firefox"))
    -- Fullscreen
    , ((modm , xK_f), sendMessage $ Toggle FULL)
    -- XF86 keys
    , ((0, 0x1008ff12), spawn "vol mute")
      -- XF86AudioRaiseVolume
    , ((0, 0x1008ff13), spawn "vol up")
      -- XF86AudioLowerVolume
    , ((0, 0x1008ff11), spawn "vol down")
    , ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set +3%")
    , ((0, xF86XK_MonBrightnessDown),spawn "brightnessctl set 3%-")
  -- Audio previous.
    , ((0, 0x1008FF16), spawn "mpc prev")
   
    -- Play/pause.
    , ((0, 0x1008FF14), spawn "mpc toggle")
   
    -- Audio next.
    , ((0, 0x1008FF17), spawn "mpc next")

     --Printscreen keys 
    , ((noModMask, xK_Print ), spawn "shot -c")
    , ((modm, xK_Print ), spawn "shot")
    , ((myModMask .|. shiftMask, xK_c ), spawn "shot -ac")
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))


    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
       
       ------------------------------------------------------------------------
       -- Layouts:
       
       -- You can specify and transform your layouts by modifying these values.
       -- If you change layout bindings be sure to use 'mod-shift-space' after
       -- restarting (with 'mod-q') to reset your layout state to the new
       -- defaults, as xmonad preserves your old layout settings by default.
       --
       -- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = smartBorders 
        $ mkToggle (NOBORDERS ?? FULL ?? EOT) 
        $ avoidStruts
	$ gaps [(U,outerGaps), (R,outerGaps),(L,outerGaps),(D,outerGaps)]
	$ spacingRaw True (Border 0 0 0 0) True (Border innerGaps innerGaps innerGaps innerGaps) True 
-- $ windowNavigation 
        $ tiled 
-- ||| emptyBSP 
        ||| tabbed shrinkText myTabTheme 
        where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio

        -- The default number of windows in the master pane
        nmaster = 1

        -- Default proportion of screen occupied by master pane
        ratio   = 1/2
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100
        outerGaps = 5
        innerGaps = 5

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "viber"           --> doFloat
    -- , className =? "scratch"        --> doFloat
    , className =? "hl_linux"       --> doFloat
    , title =? "Picture-in-Picture" --> doFloat
    -- , title =? "Exitscreen"         --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ] 
    <+> namedScratchpadManageHook scratchpads 
    <+> fullscreenManageHook
    <+> raiseHook

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

myEventHook = docksEventHook 
              <+> handleEventHook def 
              <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = dynamicLog

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
                spawn "hsetroot -fill ~/.config/wall.png"
                spawn "xrdb ~/.Xresources"
                spawnOnce "xsetroot -cursor_name left_ptr"
                spawn "xcompmgr"
                spawnOnce "mpd"
                spawnOnce "dunst"
                spawn "mpc load playlist"
--        spawn "xrandr --output Virtual1 --mode 1360x768"


------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ docks defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

