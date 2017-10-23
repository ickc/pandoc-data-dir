#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat << EOF >> $HOME/.bash_profile

# pandoc-data-dir
export PATH="\$PATH:$DIR/bin:$DIR/filters"
EOF
