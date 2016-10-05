this is my setup of the pandoc `data-dir`. It should be put in `$HOME/.pandoc`.

1. There are a couple of submodule. One can run `make init` and `make update` to update the submodule.

2. After that, run `make` and it will put the submodules into the right location.

3. Run `bin-install.sh` will install add `filters/` and `bin/` to the `PATH`.

# `pandoc.sh`

`bin/pandoc.sh` takes the most common pandoc arguments, preprocessor, filters, templates that I personally used in one package.

The options are:

- `-b`: use biblatex
- `-c`: use pandoc-citeproc
- `-e <engine>`: LaTeX engines: `pdflatex` (default), `xelatex`, `lualatex`
- ` -t <ext>`: output extensions, common ones are `md`, `tex`, `pdf`, `html`.

The script itself is pretty readable and should be easy to be tailored for personal use.

## Todo

Treat HTML related output ext the same way as HTML.
