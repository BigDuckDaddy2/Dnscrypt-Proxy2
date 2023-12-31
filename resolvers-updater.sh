#! /bin/sh

PKG_DATA_DIR="@datadir@/@PACKAGE@"
RESOLVERS_FILE="${PKG_DATA_DIR}/dnscrypt-resolvers.csv"
RESOLVERS_FILE_TMP="${RESOLVERS_FILE}.tmp"

RESOLVERS_URL="https://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-resolvers.csv"
RESOLVERS_SIG_URL="${RESOLVERS_URL}.minisig"
RESOLVERS_SIG_PUBKEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

echo "Updating the list of public DNSCrypt resolvers..."
curl -L "$RESOLVERS_URL" -o "$RESOLVERS_FILE_TMP" || exit 1
if $(which minisign > /dev/null 2>&1); then
  curl -L -o "$RESOLVERS_FILE_TMP.minisig" "$RESOLVERS_SIG_URL" || exit 1
  minisign -V -P "$RESOLVERS_SIG_PUBKEY" -m "$RESOLVERS_FILE_TMP" || exit 1
  mv -f "${RESOLVERS_FILE_TMP}.minisig" "${RESOLVERS_FILE}.minisig"
fi
mv -f "$RESOLVERS_FILE_TMP" "$RESOLVERS_FILE"
echo "Done"