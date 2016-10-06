all: filters/amsthm.py includes/default.tex includes/common.css includes/default.html includes/default.css bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py

# amsthm and other includes
filters/amsthm.py: submodule/markdown-latex-css/submodule/pandoc-amsthm/bin/pandoc-amsthm.py
	mkdir -p filters
	cp $< $@
includes/default.tex: includes/hypersetup.latex includes/usepackage.latex submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.latex includes/ucharclasses.latex
	cat $+ > $@
## The followings are for HTML output:
### needed by default.html/css. Basically is default.css without amsthm
includes/common.css: submodule/markdown-latex-css/_sass/_system-fonts-lmodern.scss submodule/markdown-latex-css/_sass/_mmdc-print.scss submodule/markdown-latex-css/_sass/_list.scss submodule/markdown-latex-css/_sass/_table.scss
	cat $+ > $@
	sed -i '' 's/@charset "UTF-8";//g' $@
### template snippet (pandoc.sh uses this)
includes/default.html: includes/common.css submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html
	echo '<style type="text/css">' > $@
	cat $< >> $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/pandoc-amsthm.html >> $@
	echo '</style>' >> $@
	cat submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html >> $@
### (marked uses this)
includes/default.css: includes/common.css submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html
	cat $< > $@
	sed -e 's/<style type="text\/css">//g' -e 's/<\/style>//g' submodule/markdown-latex-css/submodule/pandoc-amsthm/template/include/default.html >> $@

# Criticmarkdup
bin/pandoc-criticmarkup.sh: submodule/pandoc-criticmarkup/pandoc-criticmarkup.sh
	mkdir -p bin
	cp $< $@
bin/criticmarkup-reject.py: submodule/pandoc-criticmarkup/criticmarkup-reject.py
	mkdir -p bin
	cp $< $@
bin/criticmarkup-accept.py: submodule/pandoc-criticmarkup/criticmarkup-accept.py
	mkdir -p bin
	cp $< $@

# Submodule
init:
	git submodule update --init --recursive
update:
	git submodule update --recursive --remote

clean:
	rm -f filters/amsthm.py includes/default.tex includes/common.css includes/default.html includes/default.css bin/pandoc-criticmarkup.sh bin/criticmarkup-reject.py bin/criticmarkup-accept.py
