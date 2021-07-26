local gears = require("gears")
--
local themes = {}

local function vers_hex(p, n1, n2)
    return  string.format("%02x", math.floor(0.5 + (p * n2 + (1 - p) * n1) * 255))
end


function themes.gtheme(n)
    local tab = {}
    local nuance
    for i = 0, n-1 do
        nuance = string.format("%02x", math.floor(i * 255/(n - 1)))
        tab[i] = "#" .. nuance .. nuance .. nuance
    end
    return tab
end

function themes.gradtheme(n, col1, col2)
    local r1, g1, b1, a1 = gears.color.parse_color(col1)
    local r2, g2, b2, a2 = gears.color.parse_color(col2)
    --
    local r, g, b, a
    local tab = {}
    for i = 0, n-1 do
        local p = i / (n-1)
        r = vers_hex(p, r1, r2)
        g = vers_hex(p, g1, g2)
        b = vers_hex(p, b1, b2)
        a = vers_hex(p, a1, a2)
        tab[i] = "#" .. r .. g .. b .. a
    end
    --
    return tab
end

return themes
