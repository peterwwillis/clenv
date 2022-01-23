CLINST_E_NAME="gh"
CLINST_E_REV="0.1.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}.tgz"
CLINST_E_OS="$(uname_lc)"
CLINST_E_ARCH="$(uname_m_amd)"
CLINST_E_GHREPOAPI="https://api.github.com/repos/cli/cli"
CLINST_E_BASEURL="https://github.com/cli/cli/releases/download/v%s/${CLINST_E_NAME}_%s_%s_%s.tar.gz"
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_VERSION}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

ext_versions='ext_versions_ghreleases "\$CLINST_E_GHREPOAPI" | grep -v -e -'
ext_unpack='ext_unpack_untar /usr'
ext_install_local='ext_install_local "/usr/gh_${CLINST_E_VERSION}_${CLINST_E_OS}_${CLINST_E_ARCH}/bin/${CLINST_E_NAME}"'
ext_test='"$CLINST_E_INSTDIR/bin/$CLINS_E_BIN_NAME" version 2>/dev/null 1>&2'
