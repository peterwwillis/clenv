# NOTE:
#   This only works for Linux currently, as Vagrant only has system-packages for
#   Windows, Mac, Debian and RHEL.
# TODO:
#   Support downloading and installing system packages

CLINST_E_NAME="vagrant"
CLINST_E_REV="0.1.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}.zip"
CLINST_E_OS="$(uname_lc)"
CLINST_E_ARCH="$(uname_m_amd)"
CLINST_E_HCURL="https://releases.hashicorp.com/$CLINST_E_NAME"
CLINST_E_BASEURL="$CLINST_E_HCURL/%s/$CLINST_E_NAME""_%s_%s_%s.zip"
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_VERSION}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'

ext_versions='ext_versions_hashicorp "$CLINST_E_HCURL" | grep -v -e "-"'
ext_unpack='ext_unpack_unzip "/usr/bin"'
