
include ../VERSION

SRC=chroot-envs chroot-envs-ssh-config \
	chroot-envs-create-user \
	bind-mount.conf sshd-port.conf
PACKAGE=chroot-envs-$(VERSION)
BUILD=build
DEFAULT_KEY=$(shell awk '/^default-key/ { print $$2 }' $(HOME)/.gnupg/options)

default: rpm

tarball:
	mkdir -p $(PACKAGE)
	(cd ..; cp $(SRC) Makefile VERSION $(CURDIR)/$(PACKAGE))
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
	cd $(BUILD); rpmbuild --define "_topdir $(PWD)/$(BUILD)" -ba SPECS/chroot-envs.spec
	cp $(BUILD)/RPMS/*/*.rpm .
	cp $(BUILD)/SRPMS/*.rpm .
	rpm --define "__signature gpg" --define "_gpg_name $(DEFAULT_KEY)" --addsign $(PACKAGE)*.rpm

clean:
	-rm -rf $(BUILD)

distclean: clean
	-rm -f *.rpm *.tar.gz

