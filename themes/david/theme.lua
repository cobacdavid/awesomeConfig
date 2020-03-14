----------------------------------------
--  "david" awesome theme              --
-----------------------------------------
-- {{{ Main
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

theme = {}

--
--
-- POLICES
--
--
theme.police    = "abeatbyKai bold"
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
theme.grisSombre  = "#5F5F5F"
theme.rouge       = "#FF0000"
theme.rougetrans  = theme.rouge .. theme.trans
--
-- WALLPAPER
--
theme.wallpaperImagesRep = "/home/david/.config/awesome/fondMaths"
theme.ppeint = function(t)
   gears.wallpaper.set(theme.noir)
   if t.screen.index == 1 then
   else
   end
end

-- {{{ Colors
theme.bg_normal    = theme.noirtrans
theme.bg_focus     = theme.gris
theme.bg_urgent    = theme.blanc
-- theme.bg_minimize  = "#444444"
theme.bg_systray   = theme.noirtrans
-- 
theme.fg_normal    = theme.blanc .. theme.trans
theme.fg_focus     = theme.blanc
theme.fg_urgent    = theme.rouge
theme.fg_minimize  = theme.blanc

theme.useless_gap   = dpi(0)
-- theme.border_width  = dpi(1)
theme.border_width  = "0"
theme.border_color  = theme.blanc
theme.border_normal = theme.gris
theme.border_focus  = theme.blanc
theme.border_marked = "#A81414"

--
theme.widget_bg     = theme.noirtrans
theme.widget_fg_pri = theme.blanc
theme.widget_fg_sec = theme.blanc
theme.widget_fg_ter = theme.blanc
theme.widget_fg_sel = theme.rougetrans
--
theme.widget_font_pri   = theme.police
theme.widget_font_sec   = theme.police
--------------------------
--------------------------
--- WIDGETS PERSOS
--------------------------
theme.widget_heurew_font    = theme.widget_font_pri
theme.heurew_size = "20"
theme.widget_heurew_fg_jour = theme.widget_fg_pri
theme.widget_heurew_fg_soir = theme.widget_fg_ter

theme.widget_luminosite_bar_color           = theme.border_color
theme.widget_luminosite_handle_border_color = theme.border_color
theme.widget_luminosite_handle_color        = theme.border_color

theme.widget_killneuf_font_kill = theme.font2
theme.widget_killneuf_font_neuf = theme.font3
theme.widget_killneuf_kill      = theme.rouge
theme.widget_killneuf_neuf      = theme.blanc

-- choix entre gradient ou nuance
theme.widget_volumemaster_handle_color_type         = "gradient"
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

-- {{{ Icons
-- {{{ Taglist
--theme.taglist_squares_sel   = "/home/david/.config/awesome/themes/david/taglist/squarefz.png"
--theme.taglist_squares_unsel = "/home/david/.config/awesome/themes/david/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icone          = "/home/david/.config/awesome/themes/david/awesome-icon_2.png"
theme.flash_icon             = "/home/david/.config/awesome/themes/david/flash-icon2.png"
theme.chromium_icon	     = "/home/david/.config/awesome/themes/david/www2.png"
theme.gmail_icon	     = "/home/david/.config/awesome/themes/david/gmail-icon.png"
theme.maps_icon	             = "/home/david/.config/awesome/themes/david/maps-icon_2.png"
theme.hp15_icon	             = "/home/david/.config/awesome/themes/david/hp15-icon_2.png"
theme.lastfm_icon	     = "/home/david/.config/awesome/themes/david/lastfm-icon.png"
theme.jdownloader_icon	     = "/home/david/.config/awesome/themes/david/jdownloader-icon.png"
theme.urgence_icon	     = "/home/david/.config/awesome/themes/david/urgence-icon.png"
theme.rotation_icon	     = "/home/david/.config/awesome/themes/david/rotation-icon_2.png"
theme.meteo_icon	     = "/home/david/.config/awesome/themes/david/meteofrance-icon_90.png"
theme.youtube_icon	     = "/home/david/.config/awesome/themes/david/youtube-icon.png"
theme.menu_submenu_icon      = "/home/david/.config/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = "/home/david/.config/awesome/themes/default/tasklist/floatingw.png"
theme.running_icon           = "/home/david/.config/awesome/themes/david/running-icon.png"
theme.rabelais_icon          = "/home/david/.config/awesome/themes/david/rabelais-icon_2_90.png"
theme.github_icon            = "/home/david/.config/awesome/themes/david/github-icon_64.png"
theme.vlc_icon               = "/home/david/.config/awesome/themes/david/vlc-icon_2.png"
theme.euronews_icon          = "/home/david/.config/awesome/themes/david/euronews-icon.png"
theme.musique_icon           = "/home/david/.config/awesome/themes/david/musique-icon.png"
theme.spotify_icon           = "/home/david/.config/awesome/themes/david/spotify-icon.png"
theme.darktable_icon         = "/home/david/.config/awesome/themes/david/darktable-icon.png"
theme.flickr_icon            = "/home/david/.config/awesome/themes/david/flickr-icon.png"
theme.keepass_icon            = "/home/david/.config/awesome/themes/david/keepass-icon.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = "/home/david/.config/awesome/themes/david/layouts/tile.png"
theme.layout_tileleft   = "/home/david/.config/awesome/themes/david/layouts/tileleft.png"
theme.layout_tilebottom = "/home/david/.config/awesome/themes/david/layouts/tilebottom.png"
theme.layout_tiletop    = "/home/david/.config/awesome/themes/david/layouts/tiletop.png"
theme.layout_fairv      = "/home/david/.config/awesome/themes/david/layouts/fairv.png"
theme.layout_fairh      = "/home/david/.config/awesome/themes/david/layouts/fairh.png"
theme.layout_spiral     = "/home/david/.config/awesome/themes/david/layouts/spiral.png"
theme.layout_dwindle    = "/home/david/.config/awesome/themes/david/layouts/dwindle.png"
theme.layout_max        = "/home/david/.config/awesome/themes/david/layouts/max.png"
theme.layout_fullscreen = "/home/david/.config/awesome/themes/david/layouts/fullscreen.png"
theme.layout_magnifier  = "/home/david/.config/awesome/themes/david/layouts/magnifier.png"
theme.layout_floating   = "/home/david/.config/awesome/themes/david/layouts/floating.png"
-- }}}

-- {{{ Titlebar
-- theme.titlebar_close_button_focus  = "/home/david/.config/awesome/themes/david/titlebar/close_focus.png"
-- theme.titlebar_close_button_normal = "/home/david/.config/awesome/themes/david/titlebar/close_normal.png"

-- theme.titlebar_ontop_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_active.png"
-- theme.titlebar_ontop_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_inactive.png"

-- theme.titlebar_sticky_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_active.png"
-- theme.titlebar_sticky_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_inactive.png"

-- theme.titlebar_floating_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_active.png"
-- theme.titlebar_floating_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_inactive.png"

-- theme.titlebar_maximized_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_active.png"
-- theme.titlebar_maximized_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_inactive.png"

theme.titlebar_close_button_normal = "/home/david/.config/awesome/themes/david/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "/home/david/.config/awesome/themes/david/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = "/home/david/.config/awesome/themes/david/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "/home/david/.config/awesome/themes/david/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/home/david/.config/awesome/themes/david/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "/home/david/.config/awesome/themes/david/titlebar/maximized_focus_active.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- }}}
-- }}}

return theme
