CLINST_E_NAME="ansible"
CLINST_E_REV="0.2.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}"
CLINST_E_BASEURL="https://pypi.org/pypi/$CLINST_E_NAME"
CLINST_E_BASEURL_ARGS=''

ext_versions='ext_versions_pypi "$CLINST_E_BASEURL/json" | grep -e "^[0-9]\+\.[0-9]\+\.[0-9]\+$"'
ext_download='
    [ -z "${PYTHON:-}" ] && command -v python3 >/dev/null && PYTHON="python3";
    [ -z "${PYTHON:-}" ] && command -v python  >/dev/null && PYTHON="python";
    [ -z "${PYTHON:-}" ] && echo "$0: Error: please install python" && exit 1;
    if    $PYTHON -c "import virtualenv" ; then PYMOD="virtualenv -p $PYTHON";
    elif  $PYTHON -c "import venv"       ; then PYMOD="venv";
    else  echo "$0: Error: please install Python module virtualenv or venv"; exit 1; fi;
    mkdir -p "$CLINST_E_INSTDIR";
    $PYTHON -m $PYMOD --clear "$CLINST_E_INSTDIR/usr/"
'
ext_unpack='return 0'
ext_install_local='
    "$CLINST_E_INSTDIR/usr/bin/pip" install -U pip;
    "$CLINST_E_INSTDIR/usr/bin/pip" install "$CLINST_E_NAME==$CLINST_E_VERSION";
    mkdir -p "$CLINST_E_INSTDIR/bin";
    if    [ -h "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" -o -e "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" ];
    then  ln -sf "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME";
    fi;
    printf "pmunge \"$CLINST_E_INSTDIR/usr/bin\"\n" >> "$CLINST_E_INSTDIR/.env";
'

