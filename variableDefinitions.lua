-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- some parts from awesome wm 
-- ditribution
-- copyright ??
-------------------------------------------------
-- {{{ Variable definitions
--
--
modkey           = "Mod4"
scriptsPath       = config .. "/scripts/"
batteryCmd            = "cat /sys/class/power_supply/BAT0/capacity"
imageParDefaut     = "/usr/local/share/awesome/icons/awesome64.png"
--
--
-- SAUVEGARDE CONFIG awesome
--
configSvg          = "cd /home/david/travail/david/production/info/config/awesome/ && tar czf awesome_$(date +%Y%m%d-%H%M%S)-config.tgz /home/david/.config/awesome"
--
-- cylindreEcrans     = scriptsPath .. "cylindreEcran_alt.sh"
-- APPS and APPS class
--
--
vlcCmd             = "vlc"
tvCmd              = "cvlc"
--
mediaDir         = " /media/ReadyNAS/media/"
videoDir         = mediaDir .."Videos/"
collegeDir       = " /media/ReadyNAS/travail/david/production/college"
photoDir         = " /media/ReadyNAS/media/photos"
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
-- ftpReadyNAS      = "cd /home/david/Téléchargements/ && " .. ftpMgr .. " ftp://" .. ftpNASUser .. "@192.168.1.15/media/Videos"
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
browser          = firefoxCmd -- chromiumCmd -- firefoxCmd
browserClass     = firefoxClass -- chromiumClass -- firefoxClass
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
spotify          = browser .. " https://play.spotify.com"
-- lastfm           = browser .. " http://beta.last.fm/fr/user/" .. lastfmUser
gmail            = browser .. " https://mail.google.com"
--flickr           = browser .. " https://www.flickr.com/photos/" .. flickrUser
--flickrAlt        = browser .. " https://www.flickr.com/photos_user.gne?path=&nsid=" .. flickrUserAlt .. "&page=&details=1"
-- github           = browser .. " https://github.com/" .. githubUser
youtube          = browser .. " https://www.youtube.com"
maps             = browser .. " https://maps.google.fr"
-- rabelais         = browser .. " http://francois-rabelais.anjou.e-lyco.fr"
meteofrance      = browser .. " http://france.meteofrance.com/france/meteo?PREVISIONS_PORTLET.path=previsionsdept%2FDEPT49"
-- running          = browser_alt .. " https://connect.garmin.com/profile/" .. garminUser
--
BTapplet         = "blueman-applet" -- "bluetooth-applet"
WIFIapplet       = "nm-applet"
radio            = "radiotray-lite"
-- hpsystray        = "hp-systray"

-- cloudTravail     = "hubic status"
-- cloudMusique     = "google-musicmanager"
cloudMusique     = "google-play-music-desktop-player"
--
--mpdClient        = "ario"
--ncMpdClient      = "ncmpc -cm"
--ncMpdClient      =  terminal .. ' -e ' .. "ncmpcpp"
--mpdCurrent       =  scriptsPath .. "currentsong.sh &"
amixerplus       = "amixer set Master 3%+"
amixermoins      = "amixer set Master 3%-"
amixerzero       = "amixer set Master 0%"
amixermax        = "amixer set Master 100%"
--mpctoggle        = "mpc toggle"
--mpcprev          = "mpc prev"
--mpcnext          = "mpc next"
--mpcvolplus       = "mpc volume +2"
--mpcvolmoins      = "mpc volume -2"
--mpcvolzero       = "mpc volume 0"
--mpcvolmax        = "mpc volume 100"
coverMPD         = scriptsPath .. "pod_coverMPD.sh"
--
-- lumiplus         = "xbacklight -inc 5"
-- lumimoins        = "xbacklight -dec 5"
-- lumimin          = "xbacklight -set 7"
-- lumimax          = "xbacklight -set 100"
lumimoins           = "luminosite.sh -"
lumiplus            = "luminosite.sh +"
--
--alterneMode      = scriptsPath .. "alterneMode.sh"
calculatrice     = "wish8.6 /home/david/travail/david/maths/hp15/hp15simulation/HP-15C.tcl"
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
-- sur arch : /usr/bin/keepassxc
keepassCmd       = "/home/david/Téléchargements/KeePassXC-2.5.4-x86_64.AppImage"
keepass          = keepassCmd .. " /home/david/travail/david/david.kdbx"
--
RcFiles          = "/home/david/travail/david/production/info/config/"
latexRcFile      = RcFiles .. "texmf/tex/latex/prof/"
metapostRcFile   = RcFiles .. "texmf/metapost/macros_travail/"
emacsRcFile      = RcFiles .. "emacs-config/.gnu-emacs-custom"
emacsElispRcFile = RcFiles .. "emacs-config/elisp/"
--
clavierCmd       = "/home/david/travail/david/production/info/scripts/tyrfingcolor -s"
clavierCfgPath   = "/home/david/travail/david/production/lycee/algorithmique/python/drevo/exemples/"
configAwesome    = "darkred"
configUrxvt      = "darkblue"
configEmacs      = "forestgreen"
--
--
appsDemarrage = {
   compositeMgr,
   editorD,
   terminalD,
   -- cloudMusique,
   keepass,
   "wmname LG3D",
   -- radio,
}

-- config1          = clavierCfgPath .. "config_1.json"
-- configAwesome    = clavierCfgPath .. "config_awesome.json"
-- configEmacs      = clavierCfgPath .. "config_emacs.json"
-- configUrxvt      = clavierCfgPath .. "config_urxvt.json"
--
-- }}}
