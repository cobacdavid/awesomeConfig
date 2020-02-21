function EDT_jourCourant ()
   return os.date( "%A" )
end

function EDT_heureCourante ()
   local prefixe,suffixe
   local hc = tonumber(os.date( "%H" ))
   if hc <= 12 then
      prefixe = "m"
      suffixe = hc - 8 + 1
   else
      prefixe = "s"
      suffixe = hc - 13 + 1
   end
   return prefixe .. suffixe
end

function EDT_classeCourante ()
   local jour   = semaine[EDT_jourCourant()]
   local seance = jour[EDT_heureCourante()]
   return seance.classe.nom
end

function EDT_salleCourante ()
   local jour   = semaine[EDT_jourCourant()]
   local seance = jour[EDT_heureCourante()]
   return seance.salle
end

