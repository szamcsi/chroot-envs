
include VERSION
DATE=$(shell date +%Y%m%d)

SRC=chroot-envs chroot-envs-ssh-config \
	chroot-envs-create-user \
	bind-mount.conf sshd-port.conf
PACKAGE=chroot-envs-$(VERSION)
BUILD=build

default:
	echo "possible targets: install tarball rpm clean"

install:
	install -d ${prefix}/etc/init.d
	install --mode=0755 chroot-envs ${prefix}/etc/init.d/
	install -d ${prefix}/usr/bin
	install --mode=0755 chroot-envs-ssh-config ${prefix}/usr/bin/
	install -d ${prefix}/usr/sbin
	install --mode=0755 chroot-envs-create-user ${prefix}/usr/sbin/
	install -d ${prefix}/var/chroot
	install --mode=0644 bind-mount.conf ${prefix}/var/chroot/
	install --mode=0644 sshd-port.conf ${prefix}/var/chroot/

tarball:
	mkdir $(PACKAGE)
	cp $(SRC) Makefile VERSION $(PACKAGE)/
	tar -czf $(PACKAGE).tar.gz $(PACKAGE)
	rm -rf $(PACKAGE)

rpm: tarball
	-rm -rf $(BUILD)
	mkdir -p $(BUILD)
	mkdir -p $(BUILD)/BUILD
	mkdir -p $(BUILD)/RPMS
	mkdir -p $(BUILD)/SRPMS
	mkdir -p $(BUILD)/SOURCES
	mkdir -p $(BUILD)/SPECS
	cp $(PACKAGE).tar.gz $(BUILD)/SOURCES
	sed -e 's/@VERSION@/$(VERSION)/g; s/@AGE@/$(AGE)/g' chroot-envs.spec >$(BUILD)/SPECS/chroot-envs.spec
	./deblog2rpmlog >>$(BUILD)/SPECS/chroot-envs.spec
	cd $(BUILD); rpmbuild --define "_topdir $(PWD)/$(BUILD)" -ba SPECS/chroot-envs.spec
	cp $(BUILD)/RPMS/*/*.rpm .
	cp $(BUILD)/SRPMS/*.rpm .
	rpm --define "__signature gpg" --define "_gpg_name 3CE8DC02" --addsign $(PACKAGE)*.rpm


deb: tarball
	-rm -rf $(BUILD)
	mkdir -p $(BUILD)
	cp $(PACKAGE).tar.gz $(BUILD)/$(PACKAGE).orig.tar.gz
	tar -C $(BUILD) -xzf $(BUILD)/$(PACKAGE).orig.tar.gz
	cp -a debian $(BUILD)/$(PACKAGE)/
	(cd $(BUILD)/$(PACKAGE); debuild -b)
	cp $(BUILD)/*.deb .

clean:
	-rm -rf $(BUILD)

changelog:
	git-log $(shell git-tag | tail -1).. >changes
	dch -v $(VERSION)-$(AGE) -D unstable  
	-rm -f changes
