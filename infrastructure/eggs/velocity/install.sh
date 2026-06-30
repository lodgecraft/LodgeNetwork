#!/bin/bash
set -euo pipefail

cd /mnt/server

apt update
apt install -y curl jq ca-certificates

JAR_FILE="${SERVER_JARFILE:-velocity.jar}"
VERSION="${VELOCITY_VERSION:-latest}"

if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -s https://api.papermc.io/v2/projects/velocity | jq -r '.versions[-1]')
fi

BUILD=$(curl -s "https://api.papermc.io/v2/projects/velocity/versions/${VERSION}" | jq -r '.builds[-1]')

DOWNLOAD_URL="https://api.papermc.io/v2/projects/velocity/versions/${VERSION}/builds/${BUILD}/downloads/velocity-${VERSION}-${BUILD}.jar"

echo "Installing Velocity"
echo "Version: ${VERSION}"
echo "Build: ${BUILD}"
echo "Jar: ${JAR_FILE}"
echo "URL: ${DOWNLOAD_URL}"

curl -L -o "${JAR_FILE}" "${DOWNLOAD_URL}"

if [ ! -s "${JAR_FILE}" ]; then
  echo "Error: downloaded jar is empty or missing"
  exit 1
fi

echo "Velocity installed successfully."
