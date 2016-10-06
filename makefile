all: includes/default.html includes/default.css includes/default.tex filters/amsthm.py bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py

# amsthm and other includes
filters/amsthm.py: submodule/markdown-latex-css/submodule/pandoc-amsthm/bin/pandoc-amsthm.py
	mkdir -p filters
	cp $< $@
includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $^ > $@
includes/default.html: submodule/markdown-latex-css/_sass/_system-fonts-lmodern.scss submodule/markdown-latex-css/_sass/_mmdc-print.scss submodule/markdown-latex-css/_sass/_list.scss submodule/markdown-latex-css/_sass/_table.scss submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html
	echo '<style type="text/css">' > $@
	cat submodule/markdown-latex-css/_sass/_system-fonts-lmodern.scss submodule/markdown-latex-css/_sass/_mmdc-print.scss submodule/markdown-latex-css/_sass/_list.scss submodule/markdown-latex-css/_sass/_table.scss >> $@
	sed -i '' 's/@charset "UTF-8";//g' $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html >> $@
	echo '</style>' >> $@
	cat submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html >> $@
## default.css is not a pandoc template. Notice it uses pandoc-amsthm/template/include/default.html instead of pandoc-amsthm/template/include/pandoc-amsthm.html
includes/default.css: submodule/markdown-latex-css/_sass/_system-fonts-lmodern.scss submodule/markdown-latex-css/_sass/_mmdc-print.scss submodule/markdown-latex-css/_sass/_list.scss submodule/markdown-latex-css/_sass/_table.scss submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html
	cat submodule/markdown-latex-css/_sass/_system-fonts-lmodern.scss submodule/markdown-latex-css/_sass/_mmdc-print.scss submodule/markdown-latex-css/_sass/_list.scss submodule/markdown-latex-css/_sass/_table.scss > $@
	sed -i '' 's/@charset "UTF-8";//g' $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html >> $@

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
