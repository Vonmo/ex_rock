
env ?= dev
tools_hash ?= `sha1sum ./.tool-versions | cut -f 1 -d " "`

configure:
	@make configure-environment env=$(env)

configure-environment:
	if [ -n "$(env)" ]; then \
		make __do_configure env=$(env); \
	else \
		@echo "Error: variable 'env' is not set."; \
		@exit -1; \
	fi

drop-environment:
	@if [ -d "scripts/current" ] ; then \
		make clean; \
		unlink scripts/current; \
		echo "* Drop current environment"; \
	fi

__do_configure: drop-environment
	@echo "* Configuring"

	@if [ -d "scripts/env/${env}" ] ; then \
		ln -sv env/${env} scripts/current; \
	else \
		echo "Error: environment '${env}' does not exists"; \
		exit -1; \
	fi

	@make rebuild
