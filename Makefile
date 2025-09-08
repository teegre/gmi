PROGNAME  ?= gmi
PREFIX    ?= $(HOME)/.local
BINDIR    ?= $(PREFIX)/bin
LIBDIR    ?= $(PREFIX)/lib
SHAREDIR  ?= $(PREFIX)/share
MANDIR    ?= $(SHAREDIR)/man/man1

MANPAGE    = $(PROGNAME).1

.PHONY: install
install: src/$(PROGNAME).out
	install -d  $(BINDIR)
	install -m755  src/$(PROGNAME).out $(BINDIR)/$(PROGNAME)
	install -Dm644 src/*.sh   -t $(LIBDIR)/$(PROGNAME)
	install -Dm644 config     -t $(SHAREDIR)/$(PROGNAME)
	install -Dm644 $(MANPAGE) -t $(MANDIR)
	install -Dm644 LICENSE    -t $(SHAREDIR)/licenses/$(PROGNAME)

	rm src/$(PROGNAME).out

.PHONY: uninstall
uninstall:
	rm $(BINDIR)/$(PROGNAME)
	rm -rf $(LIBDIR)/$(PROGNAME)
	rm -rf $(SHAREDIR)/$(PROGNAME)
	rm $(MANDIR)/$(MANPAGE)
	rm -rf $(SHAREDIR)/licenses/$(PROGNAME)
