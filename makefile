all: includes/default.html includes/default.tex filters/amsthm.py bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py

# amsthm and other includes
includes/default.html: submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html
	cat $^ > $@
includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $^ > $@
filters/amsthm.py: submodule/markdown-latex-css/submodule/pandoc-amsthm/bin/pandoc-amsthm.py
	mkdir -p filters
	cp $< $@

# Criticmarkdup
bin/pandoc-criticmarkup.sh: submodule/pandoc-criticmarkup/pandoc-criticmarkup.sh
	mkdir -p filters
	cp $< $@
bin/criticmarkup-reject.py: submodule/pandoc-criticmarkup/criticmarkup-reject.py
	mkdir -p filters
	cp $< $@
bin/criticmarkup-accept.py: submodule/pandoc-criticmarkup/criticmarkup-accept.py
	mkdir -p filters
	cp $< $@

# Submodule
init:
	git submodule update --init --recursive
update:
	git submodule update --recursive --remote

clean: includes/default.html includes/default.tex filters/amsthm.py bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py
