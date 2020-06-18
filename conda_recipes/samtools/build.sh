#!/bin/bash

CURSES_LIB="-ltinfow -lncursesw"

autoheader
autoconf -Wno-syntax
./configure --prefix=$PREFIX --with-htslib=system CURSES_LIB="$CURSES_LIB"
make all
make install
