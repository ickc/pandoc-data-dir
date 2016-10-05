#!/bin/bash

# getopts

## reset getopts
OPTIND=1

## Initialize parameters
pandoc_biblatex=false
pandoc_citeproc=false
latex_engine=pdflatex
to_format=html

## get the options
while getopts "bce:t:" opt; do
	case "$opt" in
	b)	pandoc_biblatex=true
		;;
	c)	pandoc_citeproc=true
		;;
	e)	latex_engine=$OPTARG
		;;
	t)	to_format=$OPTARG
		;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# get paths and extension
PATHNAME="$@"
PATHNAMEWOEXT=${PATHNAME%.*}
EXT=${PATHNAME##*.}
DIRECTORY=${PATHNAME%/*}
# ext="${EXT,,}" #This does not work on Mac's default, old version of, bash.

# define commonly used pandoc arg
fromMarkdown="markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash"
argFromMarkdown="-f $fromMarkdown -S --base-header-level=1 --toc --toc-depth=6 -N"
toMarkdown="markdown-simple_tables-multiline_tables-grid_tables"
argToMarkdown="-t $toMarkdown --wrap=none --atx-headers --extract-media=\"$PATHNAMEWOEXT\""
argToTeX="-V linkcolorblue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --filter=pandoc-amsthm.py"
argToHTML="-c https://ickc.github.io/markdown-latex-css/css/markdown-latex-lmodern.css --mathjax"
argAlways="--normalize -s"

# read file into a variable
FILE=$(<"$PATHNAME")

# set whole arg
arg="$argAlways"
## set argTo/From
if [ "$EXT" = "md" ]; then
	arg+=" $argFromMarkdown"
fi
if [ "$to_format" = "md" ]; then
	arg+=" $argToMarkdown"
elif [ "$to_format" = "tex" ]; then
	arg+=" $argToTeX"
elif [ "$to_format" = "html" ]; then
	arg+=" $argToHTML"
fi
## set citeproc, biblatex
if [ $pandoc_citeproc = true ]; then
	arg+=" --filter=pandoc-citeproc"
fi
if [ $pandoc_biblatex = true ]; then
	arg+=" --biblatex"
fi
## Header
if [ "$to_format" = "html" ]; then
	HEADER=$(echo "$FILE" | pandoc --template=includes/default.html)
	arg+=' -H <($HEADER)'
fi
if [ "$to_format" = "tex" ]; then
	HEADER=$(echo "$FILE" | pandoc --template=includes/default.tex)
	arg+=' -H <($HEADER)'
fi

# If from md, preprocessor
if [ "$EXT" = "md" ];  then
	FILE=$(echo "$FILE" | pandoc-criticmarkup.sh -d $to_format)
fi
echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format"