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
argFromMarkdown="-f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-fancy_lists"
argToMarkdown="-t markdown-fancy_lists-raw_html-native_divs-native_spans-simple_tables-multiline_tables-grid_tables" # -simple_tables-multiline_tables-grid_tables-pipe_tables
argToTeX="-V linkcolor=blue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --filter=pandoc-amsthm.py"
argToHTML="--mathjax"
argAlways="--normalize -s --wrap=none --atx-headers --extract-media=\"$PATHNAMEWOEXT\""
argAlwaysExceptNonMDToMD="-S --toc --toc-depth=6 -N"

# set pandoc args
arg="$argAlways"
## set argTo/From
if [ "$EXT" = "md" ]; then
	arg+=" $argFromMarkdown"
fi 
if [ "$EXT" = "md" ] || [ "$to_format" != "md" ]; then
	arg+=" $argAlwaysExceptNonMDToMD"
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

# output
if [ "$EXT" = "md" ] && ([ "$to_format" = "html" ] || [ "$to_format" = "tex" ] || [ "$to_format" = "pdf" ]);  then
	FILE=$(cat "$PATHNAME" | pandoc-criticmarkup.sh -d $to_format) # preprocess and read to a var
	if [ "$to_format" = "html" ]; then
		echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.html)
	elif [ "$to_format" = "tex" ] || [ "$to_format" = "pdf" ]; then
		echo "$FILE" | pandoc $arg -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.tex)
	fi
elif [ "$EXT" = "$to_format" ]; then
	pandoc $arg -o "$PATHNAMEWOEXT-pandoc.$to_format" "$PATHNAME"
else
	pandoc $arg -o "$PATHNAMEWOEXT.$to_format" "$PATHNAME"
fi
