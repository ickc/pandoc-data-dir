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

# set pandoc args
arg="$argAlways"
## set argTo/From
if [ "$EXT" = "md" ]; then
	arg+=" $argFromMarkdown"
fi
if [ "$to_format" = "md" ]; then
	arg+=" $argToMarkdown"
elif [ "$to_format" = "tex" ] || [ "$to_format" = "pdf" ]; then
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

# read file into a variable
## If from md, preprocessor
if [ "$EXT" = "md" ] && ([ "to_format" = "html" ] || [ "to_format" = "tex" ] || [ "to_format" = "pdf" ]);  then
	FILE=$(pandoc-criticmarkup.sh -d $to_format "$PATHNAME")
else
	FILE=$(<"$PATHNAME")
fi

# output
if [ "$to_format" = "html" ]; then
	echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.html)
elif [ "$to_format" = "tex" ] || [ "$to_format" = "pdf" ]; then
	echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.tex)
elif [ "$EXT" = "md" ] && [ "$to_format" = "md" ]; then
	echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT-pandoc.$to_format"
else
	echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format"
fi