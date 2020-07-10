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

## screen setup

First lines of `rc.lua` explains how to setup screens with GDM and
`~\.profile`.

## can it be yours?

My `rc.lua` contains some specific lines you'll have to adjust:

* some lines of the whole config. test whether you're on "laptop"
or not ("asus" is my laptop's hostname).

* `variableDefinitions` contains a lot of variables, for the moment
it's rather a mess... menus, rules and apps (at awesome startup)
depend on it.

* `logicielsIndispensables.lua` is not evaluated. It just contains
a list of software that I use.

![screenshot](awesomeScreenshot.png "awesomeWM screenshot")
