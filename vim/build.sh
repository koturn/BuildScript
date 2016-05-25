#!/bin/sh -eu

show_usage() {
  echo '[Usage]'
  echo "  $0 [options] [arguments]"
  echo '[Option]'
  echo '  -c, --clean'
  echo '    Delete configure cache'
  echo '  -p PLATFORM, --platform=PLATFORM'
  echo '    Specify platform'
  echo '      cygwin: for cygwin'
  echo '      linux: for linux (default)'
  echo '  -h, --help'
  echo '    Show help and exit'
}

case ${OSTYPE} in
  cygwin | msys)
    platform=cygwin
    ;;
  *)
    platform=linux
    ;;
esac

unset GETOPT_COMPATIBLE
OPT=`getopt -o cp:h -l clean,platform:,help -- "$@"`
if [ $? -ne 0 ]; then
  echo >&2 'Invalid argument'
  show_usage >&2
  exit 1
fi

eval set -- "$OPT"

while [ $# -gt 0 ]; do
  case $1 in
    -c | --clean)
      rm src/auto/config.cache
      make clean
      exit 0
      ;;
    -p | --platform)
      platform=$2
      shift
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
  esac
  shift
done

build_cygwin() {
  ./configure \
    --prefix=/usr/local/ \
    --enable-fail-if-missing \
    --enable-gui=no \
    --enable-multibyte=yes \
    --enable-perlinterp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-luainterp=dynamic \
    --enable-tclinterp=yes \
    --enable-cscope=yes \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --with-features=huge \
    --with-lua-prefix=/usr/local \
    --with-luajit \
    --without-x \
    --with-modified-by=koturn \
    --with-compiledby=koturn \
    CFLAGS='-Ofast -march=native -mtune=native -funroll-loops -DNDEBUG' \
    LDFLAGS='-s -Ofast' && \
    make -j2 && \
    make install
}


build_linux() {
  ./configure \
    --prefix=/usr/local/ \
    --enable-fail-if-missing \
    --enable-gui=yes \
    --enable-multibyte=yes \
    --enable-perlinterp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-tclinterp=dynamic \
    --enable-luainterp=dynamic \
    --enable-cscope=yes \
    --enable-mzschemeinterp=yes \
    --enable-gpm \
    --enable-cscope \
    --enable-fontset \
    --disable-selinux \
    --with-features=huge \
    --with-x \
    --with-luajit \
    --with-lua-prefix=/usr/local \
    --with-modified-by=koturn \
    --with-compiledby=koturn \
    CFLAGS='-Ofast -m64 -march=native -mtune=native -funroll-loops -DNDEBUG' \
    LDFLAGS='-s -Ofast' && \
    make -j2 && \
    make install
}

case $platform in
  cygwin)
    build_cygwin
    ;;
  linux)
    build_linux
    ;;
  *)
    echo 'Invalid platform name' >&2
    ;;
esac
shift
