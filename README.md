# Disclaimer
All this config is perfect for ME.

## Looking for widgets
Go into the `widgets` directory, there's another `README.md` file.

## my `rc.lua`

My awesomewm rc file is divided into files (files you could easily
imagine in the original rc file).

If you have a look to them, you have to understand that this config
is intented to fit two PCs: a desktop PC ("desktop") and a laptop
("laptop"), the desktop one is connected to 2 screens (left has a
portrait orientation) and the laptop may be connected from time to
time to a quite low-res interface as a second screen (landscape
only).

## can it be yours?

My `rc.lua` contains some specific lines you'll have to adjust:

``` lua
myhome = "/home/david/"
os.setlocale("fr_FR.UTF-8")
socket = require("socket")
ordinateur = socket.dns.gethostname()
-- asus is my laptop's hostname
if ordinateur == "asus" then
   ordinateur = "laptop"
else
   ordinateur = "desktop"
   commandeEcran = "xrandr --output VGA-0 --mode 1920x1080 --pos 1200x900 --output HDMI-0 --mode 1920x1200 --rotate left"
   awful.spawn.with_shell(commandeEcran)
end
```

* `myhome` intends to point to `HOME` env. variable, maybe I should
use lua to retrieve this variable...

* some lines of the whole config. test whether you're on "laptop"
or not ("asus" is my laptop's hostname).

* `variableDefinitions` contains a lot of variables, for the moment
it's rather a mess... menus, rules and apps (at awesome startup)
depend on it.

* `logicielsIndispensables.lua` is not evaluated. It just contains
a list of software that I use.

![screenshot](awesomeScreenshot.png "awesomeWM screenshot")
