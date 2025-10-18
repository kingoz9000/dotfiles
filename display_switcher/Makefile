CC = gcc

PKGFLAGS = -lcjson

BINARY = display_quick_switch

all: $(BINARY)
	sudo mv display_quick_switch ~/dotfiles/bins/

$(BINARY): main.c get_connected_monitors.c
	$(CC) -lm -o $(BINARY) main.c get_connected_monitors.c $(PKGFLAGS)

clean:
	rm -f $(BINARY)
