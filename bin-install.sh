#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo >> ~/.bash_profile
echo "# pandoc-data-dir PATH" >> ~/.bash_profile
echo "export PATH=\"$DIR/bin:"'$PATH"' >> ~/.bash_profile
echo "export PATH=\"$DIR/filters:"'$PATH"' >> ~/.bash_profile
