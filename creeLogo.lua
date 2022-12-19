local cairo     = require("lgi").cairo
local gears     = require("gears")

function creeLogo(logo, couleur)
    
    -- local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
    local img = cairo.ImageSurface.create_from_png(logo)
    -- Create a context
    local cr  = cairo.Context(img)

    cr:set_operator("ATOP")
    cr:set_source(gears.color(couleur))
    cr:paint()
    return img
end

-- gears.wallpaper.fit(creeLogo(config .. "/" .. "icons" .. "/logo-github.png", "#f00"), 1)
