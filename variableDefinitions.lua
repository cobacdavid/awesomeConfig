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

-- ordinateur peut valoir "asus" ou pas
-- si asus -> portable
-- sinon -> maison
-- awful.spawn.easy_async_with_shell("hostname",
--                                   function(stdout, stderr, reason, exit_code)
--                                      ordinateur = stdout
--                                   end
-- )
if ordinateur == "asus" then
   ecranPcp = "eDP1" -- portable
   ecranAux = "HDMI1" -- sortie HDMI
   ecranAux2 = "VGA1"
else
   ecranPcp = "HDMI-0" -- sortie HDMI
   ecranAux  = "VGA-0" -- sortie ppale
   ecranAux2  = "DVI-0" -- sortie VGA
end
--
if ordinateur == "maison" then
   -- commandeEcran = "xrandr --output DVI-0 --mode 1920x1080  --output HDMI-0 --right-of DVI-0 --pos 1920x0 --mode 1920x1200 --rotate normal"
   commandeEcran = "xrandr --output VGA-0 --mode 1920x1080 --pos 1200x900 --output HDMI-0 --mode 1920x1200 --rotate left"
   awful.spawn.with_shell(commandeEcran)
end
--
modkey           = "Mod4"
os.setlocale("fr_FR.UTF-8")
scriptsPath       = config .. "/scripts/"
beautiful.init(config .. "/themes/david/theme.lua")
batteryCmd            = "cat /sys/class/power_supply/BAT0/capacity"
imageParDefaut     = "/usr/local/share/awesome/icons/awesome64.png"
--
--
-- SAUVEGARDE CONFIG awesome
--
configSvg          = "cd /home/david/travail/david/production/info/config/awesome/ && tar czf awesome_$(date +%Y%m%d-%H%M%S)-config.tgz /home/david/.config/awesome"
--
-- BARRE INFOS
--
cylindreEcrans     = scriptsPath .. "cylindreEcran_alt.sh"
configEcrans       = "xrandr |egrep -o 'current [0-9]+ x [0-9]+'|cut -d ' ' -f 2-4"
monIP              = "hostname -I|cut -d ' ' -f1"
monIPInternet      = "wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\\< -f 1"
versionLinux       = "echo $(uname -v |cut -d ' ' -f4)"
versionDistrib     = "cat /etc/debian_version"
laTempExt          = "ansiweather -l angers,fr|cut -d ' ' -f 6-7"
temperatureCore    = "sensors |grep Package|cut -d ' ' -f 5-6"
--
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
calendrier       = "gsimplecal"
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
local appsDemarrage = {
   "wmname LG3D",
   compositeMgr,
   editorD,
   terminalD,
   cloudMusique,
   keepass,
   radio,
}

-- config1          = clavierCfgPath .. "config_1.json"
-- configAwesome    = clavierCfgPath .. "config_awesome.json"
-- configEmacs      = clavierCfgPath .. "config_emacs.json"
-- configUrxvt      = clavierCfgPath .. "config_urxvt.json"
--
-- }}}
--
--wiboxHeight = {20,20}
--barreFenetre = false
--
-- version 4.0 -> à voir....
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- fin version 4.0 
--
-- gears.timer( {
--       timeout    = 600,
--       autostart  = true,
--       callback   = function ()
-- 	 --montre( OK )
-- 	 local commande = "find " .. beautiful.wallpaperImagesRep  .. " -name *.jpg |shuf -n1"
--          -- montre( commande )
-- 	 awful.spawn.easy_async_with_shell( commande ,
-- 		function(stdout,stderr,reason,exit_code)
--                    -- stdout ccomprend un carctère de fin de ligne
--                    -- pénible qui empêche le nom de fichier d'être correct
--                    papierpeint = string.sub(stdout,0,string.len(stdout)-1)
--                    -- montre( stderr )
--                    set_wallpaper(screen.primary)
-- 		end
-- 	 )
--       end
-- } )
--
-- affichageAide      = false
--
-- phototheques       = "find /photos -type f -name '*.jpg' > /tmp/listePhototheque"
-- photothequesMod    = "find /photos -type f -name '*.jpg' |grep mod/ > /tmp/listePhotothequeMod"
--
-- freeboxtv          = vlcCmd .. " http://mafreebox.freebox.fr/freeboxtv/playlist.m3u"
-- euronews           = tvCmd .. " 'rtsp://mafreebox.freebox.fr/fbxtv_pub/stream?namespace=1&service=205&flavour=sd'"--

---- urgenceCmd         = scriptsPath .. "urgence.sh"
--
-- batteryCmd         = "upower -i $(upower -e | grep BAT) | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%//"

--
-- conkyCmd           = "conky -c /travail/david/production/info/config/conky/.conkyrc_zone "
-- killConky          = "killall conky"
-- mpdScbCmd          = "mpdscribble --conf /home/david/.mpdscribble/mpdscribble.conf"
-- podNasaCmd         = scriptsPath .. "pod_nasa.sh &"
-- podApodCmd         = scriptsPath .. "pod_apod.sh &"
-- podNatgeoCmd       = scriptsPath .. "pod_natgeo.sh &"
-- podWikimediaCmd    = scriptsPath .. "pod_wikimedia.sh &"
-- podPhotothequeCmd  = scriptsPath .. "pod_phototheque1.sh &"
-- podPhotothequeCmdAlt  = scriptsPath .. "pod_phototheque2.sh &"
-- podPhotothequeCmdMod  = scriptsPath .. "pod_phototheque3.sh &"
-- timeoutPOD         = 120 -- en secondes
-- timeoutPOD2        = 600
--jdownloader      = "/home/david/Téléchargements/jd2/JDownloader2 -org=/home/david/.jdownloader/JDownloader.jar"
--

