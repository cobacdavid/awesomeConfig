-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
----------------------------------------
--  "david" awesome theme              --
-----------------------------------------
-- {{{ Main
local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local gfs          = require("gears.filesystem")
local themes_path  = gfs.get_themes_dir()
local gears        = require("gears")
--
theme = {}
--
-- POLICES
--
--
local sizes = {12, 15, 25}
theme.font = "Comfortaa" --abeatbyKai bold"
theme.font_size = sizes[1]
-- theme.calendar_font = "Inconsolata"
--
-- COULEURS
--
local noir        = "#000000"
local blanc       = "#FFFFFF"
local gris        = "#BFBFBF"
local grisSombre  = "#5F5F5F"
local grisSombre1  = "#636363"
local rouge       = "#FF0000"
--
--
couleurTheme = "#0af"
couleurFondVide = couleurTheme .. "2"
-- {{{ Colors
theme.bg_normal    = noir
theme.bg_focus     = noir
theme.bg_urgent    = rouge
theme.bg_minimize  = grisSombre1
theme.bg_systray   = noir
--
theme.fg_normal    = couleurTheme
theme.fg_focus     = couleurTheme
theme.fg_urgent    = couleurTheme
theme.fg_minimize  = couleurFondVide
--
-- {{{ Borders
theme.useless_gap         = dpi(0)
theme.border_width        = 0
theme.border_color_normal = couleurFondVide
theme.border_color_active = couleurTheme
theme.border_color_marked = rouge
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_normal          = noir
theme.titlebar_bg_focus           = noir
theme.titlebar_fg_normal          = couleurFondVide
theme.titlebar_fg_focus           = couleurTheme
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
theme.taglist_fg_focus    = blanc
theme.taglist_fg_normal   = grisSombre
theme.taglist_fg_occupied = gris
theme.taglist_fg_empty    = grisSombre
theme.taglist_fg_urgent   = gris
--
-- theme.taglist_bg_focus    = theme.transparent
-- theme.taglist_bg_normal   = theme.transparent
-- theme.taglist_bg_occupied = theme.transparent
-- theme.taglist_bg_empty    = theme.transparent
-- theme.taglist_bg_urgent   = theme.transparent
-- theme.taglist_font        = theme.font2
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = theme.gris
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.blanc
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height       = "18"
theme.menu_width        = "200"
theme.menu_bg_normal    = noir
theme.menu_fg_normal    = couleurTheme
theme.menu_bg_focus     = couleurTheme
theme.menu_fg_focus     = noir

theme.menu_border_width = "0"
theme.menu_font         = font
-- }}}
theme.separator_thickness        = 0	-- number 	The separator thickness.
--theme.separator_border_color     = 	-- color 	The separator border color.
--theme.separator_border_width     =	-- number 	The separator border width.
--theme.separator_span_ratio 	 =      -- number 	The relative percentage covered by the bar.
--theme.separator_color 	         =      -- string 	The separator’s color.
--theme.separator_shape 	         =      -- function 	The separator’s shape.
-- {{{ Icons
-- {{{ Taglist
--theme.taglist_squares_sel   = "/home/david/.config/awesome/themes/david/taglist/squarefz.png"
--theme.taglist_squares_unsel = "/home/david/.config/awesome/themes/david/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icone          = creeLogo(myhome .. ".config/awesome/themes/david/awesome-icon_2.png", couleurTheme)
-- }}}
theme.screenshot_icon    =  creeLogo(myhome .. ".config/awesome/themes/david/screenshot-icon.png", couleurTheme)
-- {{{ Layout

theme.titlebar_close_button_normal = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/close_normal.png", couleurFondVide)
theme.titlebar_close_button_focus  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/close_focus.png", couleurTheme)

-- theme.titlebar_minimize_button_normal = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/minimize_normal.png", couleurFondVide)
-- theme.titlebar_minimize_button_focus  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/minimize_focus.png", couleurTheme)

theme.titlebar_ontop_button_normal_inactive = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/ontop_normal_inactive.png", couleurFondVide)
theme.titlebar_ontop_button_focus_inactive  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/ontop_focus_inactive.png", couleurTheme)
theme.titlebar_ontop_button_normal_active = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/ontop_normal_active.png", couleurFondVide)
theme.titlebar_ontop_button_focus_active  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/ontop_focus_active.png", couleurTheme)

theme.titlebar_sticky_button_normal_inactive = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/sticky_normal_inactive.png", couleurFondVide)
theme.titlebar_sticky_button_focus_inactive  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/sticky_focus_inactive.png", couleurTheme)
theme.titlebar_sticky_button_normal_active = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/sticky_normal_active.png", couleurFondVide)
theme.titlebar_sticky_button_focus_active  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/sticky_focus_active.png", couleurTheme)

-- theme.titlebar_floating_button_normal_inactive = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/maximized_normal_inactive.png", couleurFondVide)
theme.titlebar_maximized_button_focus_inactive  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/maximized_focus_inactive.png", couleurTheme)
theme.titlebar_maximized_button_normal_active = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/maximized_normal_active.png", couleurFondVide)
theme.titlebar_maximized_button_focus_active  = creeLogo(myhome .. ".config/awesome/themes/david/titlebar/maximized_focus_active.png", couleurTheme)

-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- }}}
-- }}}

return theme
