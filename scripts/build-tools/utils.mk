
ask-confirmation:
	@read -p "You've attempted to $(context). Are you sure? [Y/y] " -n 1 -r ; \
	@echo ; \
	if [[ ! $$REPLY =~ ^[Yy]$$ ]] ; then \
		@echo "Operation aborted."; \
		@exit -1; \
	fi
