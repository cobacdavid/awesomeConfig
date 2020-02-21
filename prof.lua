local liste = { --
   "emploidutempsFonctions.lua",
   "emploidutemps2017s2.lua"
}


for i,f in ipairs(liste) do
   dofile ( config .. "/" .. f )
end
