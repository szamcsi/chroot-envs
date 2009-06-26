default:
	echo "possible targets: install changelog"

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

include VERSION

changelog:
	git log $(shell git tag | tail -1).. >changes
	dch -v $(VERSION)-$(AGE)
	-rm -f changes
	awk ' BEGIN { inchangelog = 0 } { if(inchangelog == 0) print } /^%changelog/ { inchangelog = 1 }' rpm/chroot-envs.spec >rpm/chroot-envs.spec.tmp
	rpm/deblog2rpmlog >>rpm/chroot-envs.spec.tmp
	mv rpm/chroot-envs.spec.tmp rpm/chroot-envs.spec
