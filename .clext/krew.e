CLINST_E_NAME='krew'
CLINST_E_REV='0.1.0'

CLINST_E_GHREPOAPI='https://api.github.com/repos/kubernetes-sigs/${CLINST_E_BIN_NAME}'
CLINST_E_BASEURL='https://github.com/kubernetes-sigs/${CLINST_E_NAME}/releases/download/v%s/${CLINST_E_NAME}-%s_%s.tar.gz'
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'

CLINST_E_F_VERSIONS="ghreleases"
CLINST_E_F_UNPACK="untar /usr/bin/"
CLINST_E_F_INSTALL_LOCAL='install_local /usr/bin/${CLINST_E_NAME}-${CLINST_E_OS}_${CLINST_E_ARCH}'
CLINST_E_F_TEST='bin/${CLINST_E_BIN_NAME} version'

#CLINST_E_BIN_NAME='${CLINST_E_BIN_NAME:-$CLINST_E_NAME}'
#CLINST_E_DLFILE='${CLINST_E_DLFILE:-$CLINST_E_NAME}'
#CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
#CLINST_E_OS="${CLINST_E_OS:-linux}"
#CLINST_E_ARCH="${CLINST_E_ARCH:-amd64}"
