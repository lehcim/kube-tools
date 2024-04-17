default: build

common-build: common-clean
	mkdir -p build
	-./inline.sh --in-file km  --out-file build/km
	-./inline.sh --in-file kc  --out-file build/kc
	-./inline.sh --in-file kw  --out-file build/kw
	-./inline.sh --in-file klb --out-file build/klb
	chmod 755 build/*

common-clean:
	-rm build/*
	-rmdir build

build: common-build
	mkdir -p usr/bin
	cp -f  build/* usr/bin/
	./genman.sh build/km  > debian/km.1
	./genman.sh build/kc  > debian/kc.1
	./genman.sh build/kw  > debian/kw.1
	./genman.sh build/klb > debian/klb.1

clean: common-clean
	-rm -f debian/*.1 
	-rm -f usr/bin/*
	-rmdir usr/bin usr
	-rm -Rf docker/debian/*/build
	-rm -Rf docker/ubuntu/*/build

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

