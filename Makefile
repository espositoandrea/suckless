tempdir != mktemp -d -t suckless-build-XXXXXXXXXXXX

DELETE = true

EMPHASYS = $(shell tput bold; tput setf 1)
RESET = $(shell tput sgr0)

define build_target
	@printf "$(EMPHASYS)Cloning '$(1)'$(RESET)\n"
	@git clone https://git.suckless.org/$(1) $(tempdir)/$(1) >/dev/null 2>&1

	@if [ ! -z "$$(ls -A "$(shell pwd)/$(1)/patches")" ]; then \
		printf "$(EMPHASYS)Applying patches$(RESET)\n"; \
		ls -rt "$(shell pwd)/$(1)/patches"/* | while read patch; do \
			printf "Applying patch $$(basename $$patch)\n"; \
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
		printf "$(EMPHASYS)Copying config file$(RESET)\n"; \
		cp "$(shell pwd)/$(1)/config.h" "$(tempdir)/$(1)"; \
	fi

	@printf "$(EMPHASYS)Building and installing '$(1)'$(RESET)\n"
	@if [ -z "$(verbose)" ]; then \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install >/dev/null 2>&1; \
	else \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install; \
	fi

	@if [ $(DELETE) = true ]; then \
		printf "$(EMPHASYS)Removing temporary directory$(RESET)\n"; \
		rm -rf "$(tempdir)"; \
	fi;
endef

all: DELETE = false
all: sent dmenu st
	@printf "$(EMPHASYS)Removing temporary directory$(RESET)\n"
	@rm -rf "$(tempdir)"

sent:
	$(call build_target,sent)

dmenu:
	$(call build_target,dmenu)

st:
	$(call build_target,st)

surf:
	$(call build_target,surf)

.PHONY: sent dmenu st surf
