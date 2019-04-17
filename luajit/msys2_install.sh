#!/bin/sh -eu

tmpfile="$(mktemp)"
trap 'rm -f $tmpfile; trap SIGHUP SIGINT SIGTERM' SIGHUP SIGINT SIGTERM

make install \
  && cp /usr/local/include/luajit-2.0/* /usr/local/include/ \
  && gendef - src/lua51.dll > $tmpfile \
  && dlltool -l /usr/local/lib/libluajit.a -d $tmpfile -A -k \
  && cp src/lua51.dll /usr/local/bin/libluajit.so \
  && ln -s /usr/local/bin/libluajit.so /usr/local/lib/libluajit.so

rm -f $tmpfile
trap SIGHUP SIGINT SIGTERM
