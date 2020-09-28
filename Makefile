override DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: all
all: print-monolithic-eac-download-script

.PHONY: print-monolithic-eac-download-script
print-monolithic-eac-download-script:
	@cat "$(DIR)libexec/args.sh" && tail -n+4 "$(DIR)download.sh"
