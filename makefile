all: includes/default.html includes/default.tex filters/amsthm.py filters/pandoc-criticmarkup.sh filters/criticmarkup-reject.py filters/criticmarkup-accept.py

# amsthm and other includes
includes/default.html: submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html
	cat $^ > $@
includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $^ > $@
filters/amsthm.py: submodule/markdown-latex-css/submodule/pandoc-amsthm/bin/pandoc-amsthm.py
	mkdir -p filters
	cp $< $@

# Criticmarkdup
filters/pandoc-criticmarkup.sh: submodule/pandoc-criticmarkup/pandoc-criticmarkup.sh
	mkdir -p filters
	cp $< $@
filters/criticmarkup-reject.py: submodule/pandoc-criticmarkup/criticmarkup-reject.py
	mkdir -p filters
	cp $< $@
filters/criticmarkup-accept.py: submodule/pandoc-criticmarkup/criticmarkup-accept.py
	mkdir -p filters
	cp $< $@

# Submodule
init:
	git submodule update --init --recursive
update:
	git submodule foreach git pull origin

clean: includes/default.html includes/default.tex
