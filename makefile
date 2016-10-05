all: includes/default.html includes/default.tex

includes/default.html: submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html
	cat $^ > $@

includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $^ > $@

# Submodule
init:
	git submodule update --init --recursive
update:
	git pull --recurse-submodules

clean: includes/default.html includes/default.tex
