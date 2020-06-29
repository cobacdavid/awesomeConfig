----------------------------------------
--  "david" awesome theme              --
-----------------------------------------
-- {{{ Main
-- local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears = require("gears")

theme = {}
--
-- POLICES
--
--
theme.police    = "abeatbyKai bold"
theme.calendar_font = "Inconsolata"
theme.font      = theme.police .. " 12"
theme.font2     = theme.police .. " 15"
theme.font3     = theme.police .. " 25"

--
-- COULEURS
--
theme.noir        = "#000000"
theme.trans       = "99"
theme.transparent = theme.noir .. "00"
theme.noirtrans   = theme.noir .. theme.trans
theme.blanc       = "#FFFFFF"
theme.gris        = "#BFBFBF"
theme.grisSombrePlus  = "#5F5F5F"
theme.grisSombre  = "#636363"
theme.rouge       = "#FF0000"
theme.rougetrans  = theme.rouge .. theme.trans
--
-- WALLPAPER
--
theme.wallpaperBandeau = theme.grisSombre
theme.wallpaperTagPrincipal = theme.noir
theme.wallpaperTagSecondaire = theme.grisSombrePlus
theme.wallpaper_color = theme.noir

-- {{{ Colors
theme.bg_normal    = theme.noir
theme.bg_focus     = theme.rouge
theme.bg_urgent    = theme.gris
-- theme.bg_minimize  = "#444444"
theme.bg_systray   = theme.noirtrans
-- 
theme.fg_normal    = theme.gris
theme.fg_focus     = theme.rouge
theme.fg_urgent    = theme.noir
theme.fg_minimize  = theme.blanc

theme.useless_gap   = dpi(0)
-- theme.border_width  = dpi(1)
theme.border_width  = "0"
theme.border_color_normal  = theme.blanc
theme.border_normal = theme.gris
theme.border_focus  = theme.blanc
theme.border_marked = "#A81414"

--
theme.widget_bg     = theme.noirtrans
theme.widget_fg_pri = theme.blanc
theme.widget_fg_sec = theme.gris
theme.widget_fg_ter = theme.blanc
theme.widget_fg_sel = theme.rougetrans
--
theme.widget_font_pri   = theme.police
theme.widget_font_sec   = theme.police
--------------------------
--------------------------
--- WIDGETS PERSOS
--------------------------
theme.widget_luminosite_bar_color           = theme.border_color
theme.widget_luminosite_handle_border_color = theme.border_color
theme.widget_luminosite_handle_color        = theme.border_color

theme.widget_killneuf_font_kill = theme.font2
theme.widget_killneuf_font_neuf = theme.font3
theme.widget_killneuf_kill      = theme.rouge
theme.widget_killneuf_neuf      = theme.blanc

-- choix entre gradient ou nuance
--theme.widget_volumemaster_handle_color_type         = "gradient"
theme.widget_volumeBT_handle_color_type             = "gradient" 
theme.widget_luminosite_handle_color_type           = "nuance"
theme.widget_opacite_handle_color_type              = "nuance"
theme.widget_xgamma_handle_color_type               = "nuance"
theme.widget_sliderBrightness_handle_color_type     = "nuance"


--theme.widget_font_sec   = "HP15C Simulator Font"
-- }}}
-- theme.opacity_focus = 0.5
-- {{{ Borders
-- }}}

-- {{{ Titlebars
theme.titlebar_epaisseur_premiere = 30
theme.titlebar_epaisseur_seconde  = 18
theme.titlebar_premiere           = "bottom"
theme.titlebar_seconde            = "left"
theme.titlebar_bg_normal          = theme.noir
theme.titlebar_bg_focus           = theme.noirtrans
theme.titlebar_fg_normal          = theme.blanc
theme.titlebar_fg_focus           = theme.blanc
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
theme.taglist_fg_focus    = theme.blanc
theme.taglist_fg_normal   = theme.grisSombre
theme.taglist_fg_occupied = theme.gris
theme.taglist_fg_empty    = theme.grisSombre
theme.taglist_fg_urgent   = theme.gris
--
theme.taglist_bg_focus    = theme.transparent
theme.taglist_bg_normal   = theme.transparent
theme.taglist_bg_occupied = theme.transparent
theme.taglist_bg_empty    = theme.transparent
theme.taglist_bg_urgent   = theme.transparent
theme.taglist_font        = theme.font2
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
theme.menu_height       = "16"
theme.menu_width        = "130"
theme.menu_bg_normal    = theme.noir
theme.menu_bg_focus     = theme.blanc
theme.menu_fg_focus     = theme.noir
theme.menu_fg_normal    = theme.blanc
theme.menu_border_width = "0"
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
theme.awesome_icone          = "/home/david/.config/awesome/themes/david/awesome-icon_2.png"
-- }}}

-- {{{ Layout

theme.titlebar_close_button_normal = "/home/david/.config/awesome/themes/david/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/home/david/.config/awesome/themes/david/titlebar/close_focus.png"

-- theme.titlebar_minimize_button_normal = "/home/david/.config/awesome/themes/david/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = "/home/david/.config/awesome/themes/david/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_active.png"

-- theme.titlebar_floating_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_active.png"


-- theme.grip = "/home/david/.config/awesome/themes/david/grip.png"

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
