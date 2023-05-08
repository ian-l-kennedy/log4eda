.SILENT:
SHELL=/bin/bash

do_clean_src=(rm -rf deb/log4eda/usr)
do_clean_deb=(rm -f **/*.deb ; rm -f *.deb)

deb: clean_all
	mkdir -p deb/log4eda/usr/bin
	mkdir -p deb/log4eda/usr/lib/log4eda
	cp src/bash/log4eda.bash deb/log4eda/usr/bin/log4eda
	cp src/bash/logger_diamond.bash deb/log4eda/usr/lib/log4eda/.
	dpkg-deb --build deb/log4eda
	$(call do_clean_src)

install: deb
	sudo apt install ./deb/log4eda.deb
	$(call do_clean_deb)

clean_all: clean_deb clean_src

clean_deb:
	$(call do_clean_deb)

clean_src:
	$(call do_clean_src)
