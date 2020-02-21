classes = {
   c4 = {
      nom = "Cinquième 4",
      effectif = 28
   },
   q1 = {
      nom = "Quatrième 1",
      effectif = 27
   },
   q5 = {
      nom = "Quatrième 5",
      effectif = 26
   },
   t3 = {
      nom = "Troisième 3",
      effectif = 26
   }
}

salles = {
   b04   = "B 04",
   a07   = "MM A07",
   mmcdi = "MM CDI",
}

semaine = {
   Sunday = {
      s9 = {
	 classe =  classes.c4 ,
	 salle  = salles.b04
      }
   },
   lundi = {
      m1 = {
	 classe =  classes.c4 ,
	 salle  = salles.b04
      },
      m3 = {
	 classe = classes.t3 ,
	 salle  = salles.b04
      },
      m4 = {
	 classe = classes.q1 ,
	 salle  = salles.b04
      },
      s1= {
	 classe = classes.c4 ,
	 salle  = salles.b04
      },
   },
   mardi = {
      m1 = {
	 classe = classes.q5,
	 salle  = salles.b04
      },
      m2 = {
	 classe = classes.q5,
	 salle  = salles.a07 
      },
      m3 = {
	 classe = classes.q1,
	 salle = salles.mmcdi
      },
      m4 = {
	 classe = classes.q1,
	 salle = salles.mmcdi
      },
   },
}

