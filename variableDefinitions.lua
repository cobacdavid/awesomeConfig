-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- some parts from awesome wm 
-- distribution
-- copyright ??
-------------------------------------------------
-- {{{ Variable definitions
--
--
modkey           = "Mod4"
scriptsPath      = config .. "/scripts/"
imageParDefaut   = "/usr/local/share/awesome/icons/awesome64.png"
-- ou 
--
-- SAUVEGARDE CONFIG awesome
--
configSvgDir     = config .. "/" .. "sauvegarde/"
configSvg        = "cd " .. configSvgDir
    .. "&& tar czf awesome_$(date +%Y%m%d-%H%M%S)-config.tgz "
    .. config
--
-- cylindreEcrans     = scriptsPath .. "cylindreEcran_alt.sh"
-- APPS and APPS class
--
--
vlcCmd           = "vlc"
tvCmd            = "cvlc"
--
terminalD        = "urxvtd -q -o -f "
terminal         = "urxvtc"
terminalClass    = "URxvt"
terminalAlt      = "xterm"
-- terminal         = "tmux"
htop             = terminal .. " -e htop"
--
ftpMgr           = "gftp"
ftpMgrClass      = "gFTP"
--
editorClass      = "Emacs"
editor           = "emacsclient -c "
editorD          = "emacs --daemon"
--editor_cmd       = terminal .. " -e " .. editor
editor_cmd       = editor
--
chromiumCmd      = "chromium"
chromiumClass    = "Chromium"
operaCmd         = "opera-developer"
operaClass       = "Opera developer"
firefoxCmd       = "firefox"
firefoxClass     = "Firefox"
--browser          = "opera-developer"
--browserClass     = "Opera developer"
browser          = firefoxCmd -- chromiumCmd
browserClass     = firefoxClass -- chromiumClass
browser_alt      = operaCmd
browser_altClass = operaClass
urlGoogle        = "https://www.google.com/"
metaGoogle       = "#"
-- urlQwant         = "https://www.qwant.com/"
-- metaQwant        = "?"
urlDDGo          = "https://duckduckgo.com/"
metaDDGo         = "?"
-- urlSearch        = urlQwant
-- metaSearch       = metaQwant
gmail            = browser .. " https://mail.google.com"
-- github           = browser .. " https://github.com/" .. githubUser
youtube          = browser .. " https://www.youtube.com"
maps             = browser .. " https://maps.google.fr"
meteofrance      = browser .. " http://france.meteofrance.com/france/meteo?PREVISIONS_PORTLET.path=previsionsdept%2FDEPT49"
--
BTapplet         = "blueman-applet" -- "bluetooth-applet"
WIFIapplet       = "nm-applet"
radio            = "radiotray-lite"
cloudMusique     = "google-play-music-desktop-player"
--
--mpdClient        = "ario"
--ncMpdClient      = "ncmpc -cm"
--ncMpdClient      =  terminal .. ' -e ' .. "ncmpcpp"
amixerplus       = "amixer set Master 3%+"
amixermoins      = "amixer set Master 3%-"
amixerzero       = "amixer set Master 0%"
amixermax        = "amixer set Master 100%"
--
mpdscribble      = "mpdscribble --conf  " .. myhome .. "/.config/mpd/mpdscribble.conf"
coverMPD         = scriptsPath .. "pod_coverMPD.sh"
--
-- lumiplus         = "xbacklight -inc 5"
-- lumimoins        = "xbacklight -dec 5"
-- lumimin          = "xbacklight -set 7"
-- lumimax          = "xbacklight -set 100"
lumimoins        = "luminosite.sh -"
lumiplus         = "luminosite.sh +"
--
--alterneMode      = scriptsPath .. "alterneMode.sh"
-- calendrier       = "gsimplecal"
compositeMgr     = "xcompmgr" --"unagi"-- 
--
fileMgr          = "nautilus" --  "pcmanfm"
fileMgrClass     = "Nautilus"
fileMgrAlt       = "thunar" --  "pcmanfm"
fileMgrAltClass  = "Thunar"
--
rawEditor        = "darktable"
imageEditor      = "gimp"
synaptic         = "gksudo synaptic"
--
keepassCmd       = "/usr/bin/keepassxc "
keepass          = keepassCmd .. myhome .. "/travail/david/david.kdbx"
--
RcFiles          = "/home/david/travail/david/production/info/config/"
latexRcFile      = RcFiles .. "texmf/tex/latex/prof/"
metapostRcFile   = RcFiles .. "texmf/metapost/macros_travail/"
emacsRcFile      = RcFiles .. "emacs-config/.gnu-emacs-custom"
emacsElispRcFile = RcFiles .. "emacs-config/elisp/"
--
clavierCmd       = "dtv2reader"
clavierCfgPath   = "/home/david/travail/david/production/lycee/informatique/modules_perso/drevo/examples/dtv2reader/"
-- configAwesome    = "config_awesome.json"
configUrxvt      = "darkblue"
configEmacs      = "forestgreen"
-- config1          = clavierCfgPath .. "config_1.json"
configAwesome    = clavierCfgPath .. "config_awesome.json"
-- configEmacs      = clavierCfgPath .. "config_emacs.json"
-- configUrxvt      = clavierCfgPath .. "config_urxvt.json"
--
--
appsDemarrage    = {
   compositeMgr,
   editorD,
   terminalD,
   -- cloudMusique,
   keepass,
   -- mpdscribble,
   "wmname LG3D",
   -- radio,
   "openrgb --server",
   "serveurHTTP.sh"
   }

-- }}}
