SCRIPTS = km kc kw klb
INLINES = $(patsubst %,build/%.sh,$(SCRIPTS))
BINS = $(patsubst %.sh,%,$(INLINES))
MANS = $(patsubst %,debian/%.1,$(SCRIPTS))
TARGETS = $(INLINES) $(BINS) $(MANS)

build/%.sh: %
	mkdir -p build
	./inline.sh --in-file $< --out-file $@
	chmod 755 $@

debian/%.1: build/%
	./genman.sh $< > $@

default: build

common-build: $(TARGETS)

build: common-build
	mkdir -p usr/bin
	cp -f  $(BINS) usr/bin/

clean:
	rm -f $(TARGETS)
	-rm -Rf docker/debian/*/build
	-rm -Rf docker/ubuntu/*/build

distclean: clean

.PHONY: all install uninstall clean distclean

.PHONY: debian build
debian: 
	debuild -us -uc

debian-clean:
	debclean

docker: docker-debian-bookworm docker-ubuntu-focal docker-ubuntu-jammy docker-ubuntu-noble

docker-debian-bookworm: common-build
	mkdir -p docker/debian/bookworm/build/
	cp -f build/km docker/debian/bookworm/build/km.sh
	cp -f build/kc docker/debian/bookworm/build/kc.sh
	cp -f build/kw docker/debian/bookworm/build/kw.sh
	cp -f build/klb docker/debian/bookworm/build/klb.sh
	docker build -t kubetools-debian docker/debian/bookworm/

docker-ubuntu-focal: common-build
	mkdir -p docker/ubuntu/focal/build/
	cp -f build/km docker/ubuntu/focal/build/km.sh
	cp -f build/kc docker/ubuntu/focal/build/kc.sh
	cp -f build/kw docker/ubuntu/focal/build/kw.sh
	cp -f build/klb docker/ubuntu/focal/build/klb.sh
	-docker rmi kubetools-ubuntu-focal
	docker build -t kubetools-ubuntu-focal docker/ubuntu/focal

docker-ubuntu-jammy: common-build
	mkdir -p docker/ubuntu/jammy/build/
	cp -f build/km docker/ubuntu/jammy/build/km.sh
	cp -f build/kc docker/ubuntu/jammy/build/kc.sh
	cp -f build/kw docker/ubuntu/jammy/build/kw.sh
	cp -f build/klb docker/ubuntu/jammy/build/klb.sh
	-docker rmi kubetools-ubuntu-jammy
	docker build -t kubetools-ubuntu-jammy docker/ubuntu/jammy


docker-ubuntu-noble: common-build
	mkdir -p docker/ubuntu/noble/build/
	cp -f build/km docker/ubuntu/noble/build/km.sh
	cp -f build/kc docker/ubuntu/noble/build/kc.sh
	cp -f build/kw docker/ubuntu/noble/build/kw.sh
	cp -f build/klb docker/ubuntu/noble/build/klb.sh
	-docker rmi kubetools-ubuntu-nobble
	docker build -t kubetools-ubuntu-nobble docker/ubuntu/noble

