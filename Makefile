NAME = puma

SYSTEMD_TARGET ?= /usr/local/lib/systemd/system

UNITS = $(notdir $(wildcard systemd/*))

start: install
	sudo systemctl start $(NAME).service

bundle:
	bundle

install: bundle systemd

units:
	echo ${UNITS}

systemd:
	@sudo mkdir -p ${SYSTEMD_TARGET} sudo cp -f systemd/* ${SYSTEMD_TARGET}
	@sudo chmod 644 $(addprefix ${SYSTEMD_TARGET}/,${UNITS})
	@sudo systemctl daemon-reload
	-for unit in ${UNITS}; do sudo systemctl stop $$unit || true; done

uninstall:
	-sudo rm $(addprefix ${SYSTEMD_TARGET}/,${UNITS})

.PHONY: systemd uninstall
