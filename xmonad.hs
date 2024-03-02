import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)

import XMonad.Actions.WindowGo
import XMonad.Actions.FloatSnap
import XMonad.Actions.TiledWindowDragging
import XMonad.Actions.MouseResize


import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.MouseResizableTile
import qualified XMonad.Actions.FlexibleManipulate as Flex

import XMonad.Hooks.InsertPosition (insertPosition, Focus(Newer), Position(End))
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops



import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 3

myModMask       = mod4Mask
alt             = mod1Mask
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#232528"
myFocusedBorderColor = "#9191e9"

toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))




myLayout = smartBorders $ mouseResizableTile {draggerType = BordersDragger}||| noBorders Full
  
--ResizableTall 1 (3/100) (1/2) [] smartBorders $ 

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Програмы
    [ ((alt,                xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_p     ), spawn "rofi -show drun")
    , ((alt,                xK_w     ), spawn "firefox")
    , ((alt,                xK_e     ), spawn "nemo")
    , ((alt,                xK_t     ), spawn "telegram-desktop")
    , ((alt,                xK_p     ), spawn "gmrun")
    
    -- Управления окнами
    -- Закрыть
    , ((modm ,              xK_c     ), kill)
     -- Переместить фокус на следующее окно по мере открытия
    , ((modm,               xK_space ), sendMessage NextLayout)
    -- Превести размер окон в дефолт 
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Переместить фокус на следуещее окно
    , ((modm,               xK_Tab   ), windows W.focusDown)
    -- Переместить фокус на следуещее окно вниз
    , ((modm,               xK_j     ), windows W.focusDown)
    -- Переместить фокус на предыдущее окно
    , ((modm,               xK_k     ), windows W.focusUp  )
    -- Переместить фокус на главное окно
    , ((modm,               xK_m     ), windows W.focusMaster  )
    -- Поменять местами окно в фокусе и главное
    , ((modm,               xK_Return), windows W.swapMaster)
    -- Поменять окно в фокусе и следующее
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
     -- Поменять местами в фокусе и предыдущее
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    ,((modm, xK_space), withFocused toggleFloat)   
    -- super + , Уменьшить номер главного окна на 1
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    -- Увеличить номер главного окна на 1
    -- Может выходить за рамки индексов
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    -- Правильно размещает окна
    , ((modm,               xK_n     ), refresh)

    , ((modm,               xK_h     ), sendMessage Shrink)
	, ((modm,               xK_l     ), sendMessage Expand)


    
	--, ((modm,               xK_k), sendMessage MirrorShrink) -- %! Shrink a slave area
	--, ((modm,               xK_j), sendMessage MirrorExpand)
  
    -- Выход с xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Перезапуск xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    -- Подсказки
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Переместится на 1..9
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Переводит окно в плавающее
    [ ((modm, button1), dragWindow)
	, ((modm, button1),(\w -> focus w >> Flex.mouseWindow Flex.position w))
	, ((modm, button3), withFocused $ \f -> mouseResizeWindow f False)
       --(\w -> focus w >> mouseResizeWindow w))

    ]

myManageHook = composeAll
    [ insertPosition End Newer
    , className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , className =? "telegram-desktop" --> (doRectFloat $ W.RationalRect 0.7 0.9 0.3 0.3)]

myEventHook = mempty

myLogHook = return ()

myStartupHook = do 
    spawnOnce "~/scripts/wallpaper-wrap"  --Живые обои
    --spawnOnce "feh --bg-scale --randomize ~/.wallpaper/img/*"--Обои
    -- spawnOnce "picom --config ~/.config/picom/picom.conf --experimental-backend -b"
    -- spawnOnce "eww open bar"

main = xmonad $ ewmh $ ewmhFullscreen defaults

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

help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
