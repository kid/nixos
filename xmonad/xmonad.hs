import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import Control.Monad


import qualified Data.Map as M
import Graphics.X11.Xlib
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad

import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.InsertPosition

import XMonad.Layout.NoBorders

import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig

main = xmonad =<< xmobar myConfig

scratchpads = 
  [ NS "htop" "kitty --name=htop -e htop" (appName =? "htop") defaultFloating
  , NS "telegram" "telegram-desktop" (appName =? "TelegramDesktop") defaultFloating ]

defaultLayouts = smartBorders(avoidStruts(

  -- ThreeColMid layout puts the large master window in the center
  -- of the screen. As configured below, by default it takes of 3/4 of
  -- the available space. Remaining windows tile to both the left and
  -- right of the master window. You can resize using "super-h" and
  -- "super-l".
  ThreeColMid 1 (3/100) (3/7)

     -- ResizableTall layout has a large master window on the left,
  -- and remaining windows tile on the right. By default each area
  -- takes up half the screen, but you can resize using "super-h" and
  -- "super-l".
  ||| ResizableTall 1 (3/100) (1/2) []

  -- Mirrored variation of ResizableTall. In this layout, the large
  -- master window is at the top, and remaining windows tile at the
  -- bottom of the screen. Can be resized as described above.
  ||| Mirror (ResizableTall 1 (3/100) (1/2) [])

  -- Full layout makes every window full screen. When you toggle the
  -- active window, it will bring the active window to the front.
  ||| noBorders Full
  -- Circle layout places the master window in the center of the screen.
  -- Remaining windows appear in a circle around it
  ||| Circle

  -- Grid layout tries to equally distribute windows in the available
  -- space, increasing the number of columns and rows as necessary.
  -- Master window is at top left.
  ||| Grid))

myManageHooks = composeAll
  [
    insertPosition Below Newer
  ]

myConfig = ewmh defaultConfig
  { modMask = mod4Mask
  , layoutHook = defaultLayouts --smartBorders $ layoutHook
                                  --defaultConfig,
     -- startupHook = spawn "xscreensaver -no-splash &",
  , terminal = "kitty"
  --   keys = myKeys <+> keys defaultConfig 
  -- , manageHook = insertPosition Below Newer
  , manageHook = myManageHooks <+> manageHook defaultConfig
  , handleEventHook = fullscreenEventHook
  }
  `additionalKeysP`
  [ ("M-t", namedScratchpadAction scratchpads "htop")
  , ("M-s t", namedScratchpadAction scratchpads "telegram") ]
