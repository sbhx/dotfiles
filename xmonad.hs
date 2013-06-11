-- Originally taken from https://github.com/thayerwilliams/msi-xmonad.git, but changed.
-- File     : ~/.xmonad/xmonad.hs (for Xmonad >= 0.9)
-- Author   : Thayer Williams
-- Website  : http://cinderwick.ca/
-- Desc     : A simple, mouse-friendly xmonad config geared towards
--            netbooks and other low-resolution devices.
--
--            dzen is used for statusbar rendering, with optional mouse
--            integration provided by xdotool:
--
--             * left-click workspace num to go to that ws
--             * left-click layout to cycle next layout
--             * left-click window title to cycle next window
--             * middle-click window title to kill focused window
--

import XMonad
import XMonad.Actions.CycleWindows -- classic alt-tab
import XMonad.Actions.CycleWS      -- cycle thru WS', toggle last WS
import XMonad.Actions.DwmPromote   -- swap master like dwm
import XMonad.Hooks.DynamicLog     -- statusbar 
import XMonad.Hooks.EwmhDesktops   -- fullscreenEventHook fixes chrome fullscreen
import XMonad.Hooks.ManageDocks    -- dock/tray mgmt
import XMonad.Hooks.UrgencyHook    -- window alert bells 
import XMonad.Layout.Named         -- custom layout names
import XMonad.Layout.NoBorders     -- smart borders on solo clients
import XMonad.Util.EZConfig        -- append key/mouse bindings
import XMonad.Util.Run(spawnPipe)  -- spawnPipe and hPutStrLn
import System.IO                   -- hPutStrLn scope
import XMonad.Hooks.SetWMName      -- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions

import qualified XMonad.StackSet as W   -- manageHook rules

main = do
        xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig 
            { modMask            = mod4Mask
--            , terminal           = "urxvtcd"
            , terminal           = "gnome-terminal"
            , borderWidth        = 4
            , normalBorderColor  = "#004444"
            , focusedBorderColor = "#bb0000"
            , handleEventHook    = fullscreenEventHook
            , workspaces = myWorkspaces
            , layoutHook = myLayoutHook
            , manageHook = manageDocks <+> myManageHook
                            <+> manageHook defaultConfig
            , startupHook = setWMName "LG3D" -- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions
            } 
            `additionalKeysP` myKeys

-- Tags/Workspaces
-- clickable workspaces via dzen/xdotool
myWorkspaces            :: [String]
myWorkspaces            = clickable . (map dzenEscape) $ ["1","2","3","4","5"]
 
  where clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                            (i,ws) <- zip [1..] l,
                            let n = i ]

-- Layouts
-- the default layout is fullscreen with smartborders applied to all
myLayoutHook = avoidStruts $ smartBorders ( full ||| mtiled ||| tiled )
  where
    full    = named "X" $ Full
    mtiled  = named "M" $ Mirror tiled
    tiled   = named "T" $ Tall 1 (5/100) (2/(1+(toRational(sqrt(5)::Double))))
    -- sets default tile as: Tall nmaster (delta) (golden ratio)

-- Window management
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Vlc"            --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "XCalc"          --> doFloat
--    , className =? "Chromium"       --> doF (W.shift (myWorkspaces !! 1)) -- send to ws 2
--    , className =? "Nautilus"       --> doF (W.shift (myWorkspaces !! 2)) -- send to ws 3
--    , className =? "Gimp"           --> doF (W.shift (myWorkspaces !! 3)) -- send to ws 4
    , className =? "stalonetray"    --> doIgnore
    ]

-- Key bindings
--
myKeys = [ ("M-b"        , sendMessage ToggleStruts              ) -- toggle the status bar gap
--         , ("M1-<Tab>"   , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab ) -- classic alt-tab behaviour
         , ("M-<Return>" , dwmpromote                            ) -- swap the focused window and the master window
--         , ("M-<Tab>"    , toggleWS                              ) -- toggle last workspace (super-tab)
         , ("M-<Right>"  , nextWS                                ) -- go to next workspace
         , ("M-<Left>"   , prevWS                                ) -- go to prev workspace
         , ("M-S-<Right>", shiftToNext                           ) -- move client to next workspace
         , ("M-S-<Left>" , shiftToPrev                           ) -- move client to prev workspace
--         , ("M-c"        , spawn "xcalc"                         ) -- calc
         , ("M-p"        , spawn "gmrun"                         ) -- app launcher
         , ("M-n"        , spawn "wicd-client -n"                ) -- network manager
         , ("M-r"        , spawn "xmonad --restart"              ) -- restart xmonad w/o recompiling
--         , ("M-w"        , spawn "chromium"                      ) -- launch browser
--         , ("M-S-w"      , spawn "chromium --incognito"          ) -- launch private browser
--         , ("M-e"        , spawn "nautilus"                      ) -- launch file manager
         , ("C-M1-l"     , spawn "gnome-screensaver-command --lock"              ) -- lock screen
--         , ("M-s"        , spawn "urxvtcd -e bash -c 'screen -dRR -S $HOSTNAME'" ) -- launch screen session
         , ("C-M1-<Delete>" , spawn "sudo shutdown -r now"       ) -- reboot
         , ("C-M1-<Insert>" , spawn "sudo shutdown -h now"       ) -- poweroff
         , ("M-S-n"        , spawn "killall keynav; keynav"        ) -- restart keynav
         , ("M-m"        , spawn "xkbset m"        ) -- mousekeys on
         , ("M-S-m"      , spawn "xkbset -m"       ) -- mousekeys off
         ]

-- vim:sw=4 sts=4 ts=4 tw=0 et ai 
