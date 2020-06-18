#!/bin/bash

autoheader
autoconf
./configure --prefix=${PREFIX} --enable-libcurl --enable-plugins --enable-gcs --enable-s3
make
make install
