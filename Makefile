tempdir != mktemp -d -t suckless-build-XXXXXXXXXXXX

DELETE = true

EMPHASYS = \033[01m
RESET = \033[0m

define build_target
	@echo -e "$(EMPHASYS)Cloning '$(1)'$(RESET)"
	@if [ -z "$(verbose)" ]; then \
		git clone https://git.suckless.org/$(1) $(tempdir)/$(1) >/dev/null 2>&1; \
	else \
		git clone https://git.suckless.org/$(1) $(tempdir)/$(1); \
	fi

	@if [ ! -z "$$(ls -A "$(shell pwd)/$(1)/patches")" ]; then \
		echo -e "$(EMPHASYS)Applying patches$(RESET)"; \
		for patch in "$(shell pwd)/$(1)/patches"/*; do \
			echo "Applying patch $$(basename $$patch)"; \
			if [ -z "$(verbose)" ]; then \
				cd "$(tempdir)/$(1)" && \
					git am "$$patch" >/dev/null 2>&1 || \
					patch -l -p1 < "$$patch" >/dev/null 2>&1; \
			else \
				cd "$(tempdir)/$(1)" && \
					git am "$$patch" || \
					patch -l -p1 < "$$patch"; \
			fi; \
		done; \
	fi

	@if [ -f "$(shell pwd)/$(1)/config.h" ]; then \
		echo -e "$(EMPHASYS)Copying config file$(RESET)"; \
		cp "$(shell pwd)/$(1)/config.h" "$(tempdir)/$(1)"; \
	fi

	@echo -e "$(EMPHASYS)Building and installing '$(1)'$(RESET)"
	@if [ -z "$(verbose)" ]; then \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install >/dev/null 2>&1; \
	else \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install; \
	fi

	@if [ $(DELETE) = true ]; then \
		echo -e "$(EMPHASYS)Removing temporary directory$(RESET)"; \
		rm -rf "$(tempdir)"; \
	fi;
endef

all: DELETE = false
all: sent dmenu
	@echo -e "$(EMPHASYS)Removing temporary directory$(RESET)"
	@rm -rf "$(tempdir)"

sent:
	$(call build_target,sent)

dmenu:
	$(call build_target,dmenu)

.PHONY: sent dmenu
