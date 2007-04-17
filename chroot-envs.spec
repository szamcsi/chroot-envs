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
It was tested with SLC3 and SLC4.

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
%config %{prefix}/var/chroot/bind-mount.conf
%config %{prefix}/var/chroot/sshd-port.conf

%changelog
* Tue Apr 17 2007 Akos FROHNER <Akos.Frohner@cern.ch> 0.2.0-1

- Copying /etc/resolv.conf into the chroot environments.

* Tue Mar  6 2007 Akos FROHNER <Akos.Frohner@cern.ch> 0.1.0-1

- First public release.
  https://twiki.cern.ch/twiki/bin/view/EGEE/ChrootEnvs

