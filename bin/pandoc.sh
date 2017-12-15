#!/usr/bin/env bash

usage="./$(basename "$0") [-hbco] [-e engine] [-t format] --- pandoc thin wrapper in bash

where:
	-h	show this help message.
	-t	specify the output format by its extension. e.g. md, pdf, tex, html.
	-e	specify the latex engine used. Default: pdflatex. Other options: xelatex, lualatex.
	-o	if specified, and if input and output format is identical, overwrite the original file.
	-b	if specified, use biblatex.
	-c	if specified, use pandoc-citeproc
"

# getopts ##############################################################

## reset getopts
OPTIND=1

## Initialize parameters
pandoc_biblatex=false
pandoc_citeproc=false
latex_engine=pdflatex
to_format=html
overwrite=false

## get the options
while getopts "bcoe:t:" opt; do
	case "$opt" in
	b)	pandoc_biblatex=true
		;;
	c)	pandoc_citeproc=true
		;;
	o)	overwrite=true
		;;
	e)	latex_engine=$OPTARG
		;;
	t)	to_format=$OPTARG
		;;
	h)	printf "$usage"
		exit 0
		;;
	*)	printf "$usage"
		exit 1
		;;
	esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# get paths and extension ##############################################

PATHNAME="$(realpath "$@")"
PATHNAMEWOEXT="${PATHNAME%.*}"
EXT="${PATHNAME##*.}"
DIRECTORY="${PATHNAME%/*}"
filename="${PATHNAMEWOEXT##*/}"
filenameASCII=$(echo $filename | sed -e 's/[^A-Za-z0-9._-]/_/g')
# ext="${EXT,,}" #This does not work on Mac's default, old version of, bash.

# Args #################################################################

# define commonly used pandoc arg
argFromMarkdown="-f markdown+abbreviations+autolink_bare_uris+markdown_attribute+mmd_header_identifiers+mmd_link_attributes+mmd_title_block+tex_math_double_backslash-fancy_lists"
argToMarkdown="-t markdown-fancy_lists-raw_html-native_divs-native_spans-simple_tables-multiline_tables-grid_tables" # -simple_tables-multiline_tables-grid_tables-pipe_tables
argToTeX="-V linkcolor=blue -V citecolor=blue -V urlcolor=blue -V toccolor=blue --filter=pandoc-amsthm.py"
argToHTML="--mathjax"
argAlways="-s --wrap=none --atx-headers --extract-media=$DIRECTORY/$filenameASCII"
argAlwaysExceptNonMDToMD="-S --toc --toc-depth=6 -N"

# set pandoc args
arg="$argAlways"
## set argTo/From
if [[ "$EXT" = "md" ]]; then
	arg+=" $argFromMarkdown"
fi
if [[ "$overwrite" = "false" && ( "$EXT" = "md" || "$to_format" != "md" ) ]]; then
		arg+=" $argAlwaysExceptNonMDToMD"
fi
if [[ "$to_format" = "md" ]]; then
	arg+=" $argToMarkdown"
elif [[ "$to_format" = "tex" || "$to_format" = "pdf" ]]; then
	arg+=" $argToTeX"
elif [[ "$to_format" = "html" ]]; then
	arg+=" $argToHTML"
fi
## set citeproc, biblatex
if [[ "$pandoc_citeproc" = "true" ]]; then
	arg+=" --filter=pandoc-citeproc"
fi
if [[ "$pandoc_biblatex" = "true" ]]; then
	arg+=" --biblatex"
fi

# output ###############################################################

if [[ "$EXT" = "md" && ( "$to_format" = "html" || "$to_format" = "tex" || "$to_format" = "pdf" ) ]];  then
	FILE=$(pandoc-criticmarkup.sh -d $to_format "$PATHNAME") # preprocess and read to a var
	if [[ "$to_format" = "html" ]]; then
		echo "$FILE" | pandoc $arg -M date="$(date "+%B %e, %Y")" -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.html)
	elif [[ "$to_format" = "tex" || "$to_format" = "pdf" ]]; then
		echo "$FILE" | pandoc $arg -M date="$(date "+%B %e, %Y")" -o "$PATHNAMEWOEXT.$to_format" -H <(echo "$FILE" | pandoc --template=$HOME/.pandoc/includes/default.tex)
	fi
elif [[ "$overwrite" = "false" && "$EXT" = "$to_format" ]]; then
	pandoc $arg -M date="$(date "+%B %e, %Y")" -o "$PATHNAMEWOEXT-pandoc.$to_format" "$PATHNAME"
else
	pandoc $arg -M date="$(date "+%B %e, %Y")" -o "$PATHNAMEWOEXT.$to_format" "$PATHNAME"
fi
