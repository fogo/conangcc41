# Docker CentOS 5  [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

## Docker image for Centos 5, Conan and GCC-4.1

#### About

This [image](https://hub.docker.com/r/uilianries/conangcc41/) was created to be used as build environment for gcc-4.1

#### Pull
You could obtain the latest image:

    $ docker pull uilianries/conangcc41

#### Build
To build this image:

    $ cd gcc_4.1 && ./build.sh

#### Run
Use your conan cache as container volume:

    $ gcc_4.1/run.sh

#### Build and Upload

    $ python build.py

#### License
Copyright (C) 2017 Uilian Ries  

This software may be modified and distributed under the terms  
of the MIT license.  See the LICENSE file for details.
