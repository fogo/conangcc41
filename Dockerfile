FROM centos:5

MAINTAINER Uilian Ries <uilianries@gmail.com>


 # Cent OS Vault as repository
RUN sed -i -e 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo \
 && sed -i -e 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo \
 && sed -i -e 's/mirror.centos.org\/centos\/$releasever/vault.centos.org\/5.11/g' /etc/yum.repos.d/CentOS-Base.repo \
 # Development tools
 && yum upgrade -y \
 && yum groupinstall -y 'Development Tools' \
 # Dependencies
 && yum install -y wget sudo bzip2 make xz nasm valgrind vim zlib openssl-devel curl-devel \
 # Sqlite3
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://www.sqlite.org/2017/sqlite-autoconf-3170000.tar.gz \
 && tar zxf sqlite-autoconf-3170000.tar.gz \
 && cd sqlite-autoconf-3170000 \
 && ./configure \
 && make \
 && make install \
 && rm -rf /tmp/sqlite-* \
 # OpenSSL 1.0.2a
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://www.openssl.org/source/openssl-1.0.2a.tar.gz \
 && tar -zxf openssl-1.0.2a.tar.gz \
 && cd openssl-1.0.2a \
 && ./config -fPIC --prefix=/usr --openssldir=/usr/include/openssl shared \
 && make \
 && make install \
 && rm -rf /tmp/openssl-* \
 # libffi 3.2.1
 && cd /tmp \
 && wget -q -t 0 -c ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz \
 && tar -zxf libffi-3.2.1.tar.gz \
 && cd libffi-3.2.1 \
 && sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in \
 && sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in \
 && ./configure --prefix=/usr --disable-static \
 && make \
 && make install \
 && rm -rf /tmp/libffi-* \
 # CMake 3.7
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz \
 && tar -xzf cmake-3.7.2.tar.gz \
 && cd cmake-3.7.2 \
 && ./bootstrap \
 && make \
 && make install \
 && rm -rf /tmp/cmake-* \
 # Git 2.11.1
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://www.kernel.org/pub/software/scm/git/git-2.11.1.tar.gz \
 && tar -zxf git-2.11.1.tar.gz \
 && cd git-2.11.1 \
 && ./configure \
 && make \
 && make install \
 && rm -rf /tmp/git-* \
 # Python 2.7
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz \
 && unxz Python-2.7.13.tar.xz \
 && tar xf Python-2.7.13.tar \
 && cd Python-2.7.13 \
 && ./configure \
 && make \
 && make install \
 && rm -rf /tmp/Python* \
 # Python pip
 && cd /tmp \
 && wget --no-check-certificate -q -t 0 -c https://bootstrap.pypa.io/get-pip.py \
 && python get-pip.py \
 && rm -f get-pip.py \
 # Conan 
 && pip install -U pip \
 && pip install conan conan_package_tools \
 # Sudo user
 && groupadd 1001 -g 1001 \
 && groupadd 1000 -g 1000 \
 && useradd -m -s /bin/bash -g 1001 -G 1000 -u 1000 conan \
 && echo "conan:conan" | chpasswd \
 && usermod -aG wheel conan \
 && echo "conan ALL= NOPASSWD: ALL" >> /etc/sudoers \
 && mkdir -p /home/conan/.conan \
 && chown conan:1001 /home/conan/.conan \
 # Solve sudo tty
 && sed -i -e 's/Defaults    requiretty/# Defaults    requiretty/g' /etc/sudoers

USER conan
WORKDIR /home/conan
