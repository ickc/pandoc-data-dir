#!/usr/bin/env bash

pandoc -f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-fancy_lists \
--smart --number-sections --toc --toc-depth=6 --normalize --mathjax --include-in-header=~/.pandoc/submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html --filter=pandoc-amsthm.py
