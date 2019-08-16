TEX_SRC    = $(wildcard *.tex)
MP_SRC     = $(wildcard *.mp)
BKP_FILES  = $(wildcard *~)
# OPtions commandes
OPT_LUALATEX = --shell-escape
# Commandes
LUALATEX   = lualatex --shell-escape
MPOST      = mpost
VIS_PDF    = evince
# 
PDF        = $(TEX_SRC:%.tex=%.pdf)
# 
TO_DEL_C   = *.aux *.log *.toc *.lof *.lot *.mpx *.tmp
TO_DEL_P   = $(PDF) $(BKP_FILES)  *.0 *.1 *.2 *.3 *.4 *.5 *.6 *.7 *.8 *.9 *.10
#
#
all: $(PDF) clean

pdf: $(PDF) clean
	 @$(VIS_PDF) $(PDF) &

mp: mpost clean

clean:
	@rm -f $(TO_DEL_C)

mrproper: clean
	@rm -f $(TO_DEL_P)

# 0 1 etc.
mpost:
	$(MPOST) $(MP_SRC)

# pdf
%.pdf: %.tex
	@$(LUALATEX) $(OPT_LUALATEX) $<
