PREFIX ?= /usr/local
SUCKLESS_DIR := suckless

.PHONY: all dwm dmenu clean rebuild

all: dwm dmenu

dwm:
	$(MAKE) -C $(SUCKLESS_DIR)/dwm clean install

dmenu:
	$(MAKE) -C $(SUCKLESS_DIR)/dmenu clean install

clean:
	$(MAKE) -C $(SUCKLESS_DIR)/dwm clean
	$(MAKE) -C $(SUCKLESS_DIR)/dmenu clean

rebuild: clean all
