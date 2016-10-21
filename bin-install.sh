#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
printf "%s\n" "" "# pandoc-data-dir PATH" "export PATH=\"$DIR/bin:"'$PATH"' "export PATH=\"$DIR/filters:"'$PATH"' >> ~/.bash_profile
