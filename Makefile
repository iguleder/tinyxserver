
include standard_definitions.mk

DEFS= -DNOERROR

CFLAGS= -I.. -I../.. -I../../.. -I./include -I./common -I./render -I./Xext -I./lbx -I./fb -I./mi -I./miext/shadow -I./hw/kdrive -I./miext/layer -I./os $(COMMONDEFS) $(DEFS)

OBJS=

common:
	cd render; make
	cd dix; make
	cd os; make
	cd mi; make
	cd Xext; make
	cd Xext/extmod; make
	cd XTrap; make
	cd hw/kdrive; make
	cd hw/kdrive/linux; make
	cd fb; make
	cd miext/shadow; make
	cd miext/layer; make
	cd randr; make
	cd record; make
	cd fonts; make

Xvesa: common
	cd hw/kdrive/vesa; make
	$(CC) $(CFLAGs) $(DEFS) $(LDFLAGS) -o Xvesa dix/libdix.a os/libos.a hw/kdrive/vesa/libvesa.a miext/layer/liblayer.a hw/kdrive/libkdrive.a hw/kdrive/linux/liblinux.a miext/shadow/libshadow.a fb/libfb.a mi/libmi.a Xext/libext.a Xext/extmod/libextmod.a XTrap/libxtrap.a randr/librandr.a render/librender.a record/librecord.a $(LINKDIR) -lXfont -lXinerama -lX11 -lXdmcp -lz -lm

Xfbdev: common
	cd hw/kdrive/fbdev; make
	$(CC) $(CFLAGs) $(DEFS) $(LDFLAGS) -o Xfbdev dix/libdix.a os/libos.a hw/kdrive/fbdev/libfbdev.a miext/layer/liblayer.a hw/kdrive/libkdrive.a hw/kdrive/linux/liblinux.a miext/shadow/libshadow.a fb/libfb.a mi/libmi.a Xext/libext.a Xext/extmod/libextmod.a XTrap/libxtrap.a randr/librandr.a render/librender.a record/librecord.a $(LINKDIR) -lXfont -lXinerama -lX11 -lXdmcp -lz -lm

xinit:
	cd init; make
	$(CC) $(CFLAGs) $(DEFS) $(LDFLAGS) -o xinit init/xinit.o -lX11

all: Xvesa Xfbdev xinit

clean:
	cd render; make clean
	cd dix; make clean
	cd os; make clean
	cd mi; make clean
	cd Xext; make clean
	cd Xext/extmod; make clean
	cd XTrap; make clean
	cd hw/kdrive; make clean
	cd hw/kdrive/linux; make clean
	cd fb; make clean; cd ..
	#cd hw/kdrive/vesa; make clean
	cd miext/shadow; make clean
	cd miext/layer; make clean
	cd randr; make clean
	cd hw/kdrive/fbdev; make clean
	cd record; make clean
	cd init; make clean
	cd fonts; make clean
	rm -f Xvesa
	rm -f Xfbdev
	rm -f xinit

install:
	[ -f Xfbdev ] && install -D -m 4755 Xfbdev $(DESTDIR)/$(BINDIR)/Xfbdev
	if [ -f Xvesa ]; then install -D -m 4755 Xvesa $(DESTDIR)/$(BINDIR)/Xvesa; fi
	install -m 755 xinit $(DESTDIR)/$(BINDIR)/xinit
	[ -f Xvesa ] && ln -s Xvesa $(DESTDIR)/$(BINDIR)/X || ln -s Xfbdev $(DESTDIR)/$(BINDIR)/X
	for i in misc truetype 100dpi 75dpi cyrillic; do install -d -m 755 $$i $(DESTDIR)/$(FONTDIR)/$$i; done
	cd fonts; for i in *.pcf fonts.alias; do install -m 644 $$i $(DESTDIR)/$(FONTDIR)/misc/$$i; done; cd ..
	install -D -m 644 init/xinit.1 $(DESTDIR)/$(MANDIR)/man1/xinit.1
	install -D -m 644 README $(DESTDIR)/$(DOCDIR)/tinyxserver/README
	install -m 644 changelog $(DESTDIR)/$(DOCDIR)/tinyxserver/changelog
	install -D -m 644 init/README.upstream $(DESTDIR)/$(DOCDIR)/xinit/README
	install -m 644 init/ChangeLog $(DESTDIR)/$(DOCDIR)/xinit/ChangeLog
	install -m 644 init/AUTHORS $(DESTDIR)/$(DOCDIR)/xinit/AUTHORS
	install -m 644 init/COPYING $(DESTDIR)/$(DOCDIR)/xinit/COPYING
	install -D -m 644 fonts/AUTHORS.misc $(DESTDIR)/$(DOCDIR)/font-misc-misc/AUTHORS
	install -m 644 fonts/COPYING.misc $(DESTDIR)/$(DOCDIR)/font-misc-misc/COPYING
	install -D -m 644 fonts/COPYING.cursor $(DESTDIR)/$(DOCDIR)/font-cursor-misc/COPYING
	install -D -m 644 fonts/COPYING.alias $(DESTDIR)/$(DOCDIR)/font-alias/COPYING

tarball:	clean
	./make-tarball.sh

