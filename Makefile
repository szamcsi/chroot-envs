
include VERSION

SRC=chroot-envs chroot-envs-ssh-config bind-mount.conf sshd-port.conf
PACKAGE=chroot-envs-$(VERSION)
BUILD=build

default:
	echo "possible targets: install tarball rpm clean"

install:
	install -d ${prefix}/etc/init.d
	install --mode=0755 chroot-envs ${prefix}/etc/init.d/
	install -d ${prefix}/usr/bin
	install --mode=0755 chroot-envs-ssh-config ${prefix}/usr/bin/
	install -d ${prefix}/var/chroot
	install --mode=0644 bind-mount.conf ${prefix}/var/chroot/
	install --mode=0644 sshd-port.conf ${prefix}/var/chroot/

tarball:
	mkdir $(PACKAGE)
	cp $(SRC) Makefile VERSION $(PACKAGE)/
	tar -czf $(PACKAGE).tar.gz $(PACKAGE)
	rm -rf $(PACKAGE)

rpm:
	mkdir -p $(BUILD)
	mkdir -p $(BUILD)/BUILD
	mkdir -p $(BUILD)/RPMS
	mkdir -p $(BUILD)/SRPMS
	mkdir -p $(BUILD)/SOURCES
	mkdir -p $(BUILD)/SPECS
	$(MAKE) tarball
	cp $(PACKAGE).tar.gz $(BUILD)/SOURCES
	sed -e 's/@VERSION@/$(VERSION)/g; s/@AGE@/$(AGE)/g' chroot-envs.spec >$(BUILD)/SPECS/chroot-envs.spec
	cd $(BUILD); rpmbuild --define "_topdir $(PWD)/$(BUILD)" -ba SPECS/chroot-envs.spec
	cp $(BUILD)/RPMS/*/*.rpm .
	cp $(BUILD)/SRPMS/*.rpm .

clean:
	-rm -rf $(BUILD)
