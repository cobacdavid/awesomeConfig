--#!/usr/bin/lua

require ( "io" )
require ( "os" )

local dir = "/home/david/.config/awesome"

local dst          = "/tmp/"
local dstFile = "awesome_config.tgz"
local dstAwesome   = dst .. "/awesome"
local dstFinal     = "/home/david/travail/david/production/info/config/awesome/"

local tar     = "tar czf"
local af      = dst .. "/" .. dstFile

-- creation des repertoires dans le /tmp
for line in io.lines( fic ) do
   if string.match ( line , ".*awesome.*" ) then
      -- on copie tout le repertoire
      os.execute ( "cp -r " .. line .. " " .. dst )
   end
end
-- creation du tarball
os.execute ( "cd " .. dst .. " && " .. tar .. " " .. af  .. " conky/ awesome/" )
os.execute ( "mv " .. af ..  " " .. dstFinal )
