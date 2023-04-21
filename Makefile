.SILENT:
SHELL=/bin/bash

build:
        rm -rf usr
        mkdir -p usr/bin/log4eda_
        cp -r src/bash/* usr/bin/log4eda_/.
        mv usr/bin/log4eda_/log4eda.bash usr/bin/log4eda