Summary: Running chroot environments.
Name: chroot-envs
Version: @VERSION@
Release: @AGE@
Source: chroot-envs-%{version}.tar.gz
Group: admin
BuildRoot: %{_builddir}/%{name}-%{version}-root
BuildArch: noarch
Requires: bash
License: GPL
Prefix: /

%description
This package contains a basic daemon startup script to 
run Linux images as chroot environments.
It was tested with SLC3, SLC4 and SL5

%prep
%setup -q

%build

%install
rm -rf ${RPM_BUILD_ROOT}
make prefix=${RPM_BUILD_ROOT}%{prefix} install

%clean

%files
%defattr(-,root,root)
%attr(755,root,root) %{prefix}/etc/init.d/chroot-envs
%attr(755,root,root) %{prefix}/usr/bin/chroot-envs-ssh-config
%attr(755,root,root) %{prefix}/usr/sbin/chroot-envs-create-user
%config %{prefix}/var/chroot/bind-mount.conf
%config %{prefix}/var/chroot/sshd-port.conf

%changelog
* Fri Jun 26 2009 Frohner Ákos <akos@frohner.hu> 0.6.1-1

- Added new ssh ports for SLC5 and debian5.
- chroot-envs-ssh-config skips unknown chroot envs.

* Wed Sep 24 2008 Frohner Ákos <akos@frohner.hu> 0.6.0-1

- sshd fix: if there is no 'Port' specified, then it needs to be added, and
  it has to be before ListenAddress
 
- sshd fix: if /var/run/utmp of the chroot env comes from a shut down
  machine, then it might report 0 or 6 runlevel, thus 'sshd' may decide to
  kill all ssh processes.  Copying 'utmp' from the real OS.
 
- Marking config files for Debian that they are not
  overwritten with new version of the package.

* Thu Aug  7 2008 Frohner Ákos <akos@frohner.hu> 0.5.0-1

- Command to copy a user to the chroot environments.

* Tue Jun  3 2008 Frohner Ákos <akos@frohner.hu> 0.4.0-1

- Updated by Ricardo Mendes <ricardo.mendes@cern.ch> to be able to
  run in a RedHat based hosting environment and to run Debian based
  chroot environment.
 
- Do not mount AFS by default.

* Tue Feb 12 2008 FROHNER Ákos <akos@frohner.hu> 0.3.0-1

- Bound the chrooted ssh daemons to local address only.

* Tue Apr 17 2007 FROHNER Ákos <akos@frohner.hu> 0.2.0-1

- Copying /etc/resolv.conf into the chroot environments.

* Tue Mar  6 2007 Akos FROHNER <akos@frohner.hu> 0.1.0-1

- First public release.
  https://twiki.cern.ch/twiki/bin/view/EGEE/ChrootEnvs

