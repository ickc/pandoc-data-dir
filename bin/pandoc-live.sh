#!/bin/bash

pandoc --normalize -f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-fancy_lists -S --base-header-level=1 --toc --toc-depth=6 -N --mathjax -H ~/.pandoc/submodule/markdown-latex-css/js/mathjax/setup-mathjax-cdn.html