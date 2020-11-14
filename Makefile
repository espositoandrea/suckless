.PHONY: sent
tempdir != mktemp -d -t suckless-build-XXXXXXXXXXXX
DELETE = true
TARGET = bin
EMPHASYS = \033[01m
RESET = \033[0m

define build_target
	@echo -e "$(EMPHASYS)Creating target directory$(RESET)"
	@mkdir -p $(TARGET)

	@echo -e "$(EMPHASYS)Cloning '$(1)'$(RESET)"
	@if [ -z "$(verbose)" ]; then \
		git clone https://git.suckless.org/$(1) $(tempdir)/$(1) >/dev/null 2>&1; \
	else \
		git clone https://git.suckless.org/$(1) $(tempdir)/$(1); \
	fi

	@echo -e "$(EMPHASYS)Applying patches$(RESET)"
	@for patch in "$(shell pwd)/$(1)/patches"/*.diff; do \
		cd "$(tempdir)/$(1)" && git am "$$patch"; \
	done;

	@echo -e "$(EMPHASYS)Building '$(1)'$(RESET)"
	@if [ -z "$(verbose)" ]; then \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install >/dev/null 2>&1; \
	else \
		sudo $(MAKE) -C "$(tempdir)/$(1)" install; \
	fi

	@echo -e "$(EMPHASYS)Copying builded '$(1)' to current directory$(RESET)"
	@cp "$(tempdir)/$(1)/$(1)" $(TARGET)

	@if [ $(DELETE) = true ]; then \
		echo -e "$(EMPHASYS)Removing temporary directory$(RESET)"; \
		rm -rf "$(tempdir)"; \
	fi;
endef

all: DELETE = false
all: sent
	@echo -e "$(EMPHASYS)Removing temporary directory$(RESET)"
	@rm -rf "$(tempdir)"

sent:
	$(call build_target,sent)
