(TeX-add-style-hook
 "controles"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("prof" "ecran" "unepage")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "prof"
    "tabularx")
   (TeX-add-symbols
    '("commande" 1)
    '("raccourci" 1)
    '("debutTab" 1)
    '("touche" 1)
    '("touchef" 1)
    "ctrl"
    "shift"
    "win"
    "alt"
    "boutong"
    "boutond"
    "boutonm"
    "rouletteAvant"
    "rouletteArriere"
    "finTab")
   (LaTeX-add-environments
    '("monTableau" 1))))

