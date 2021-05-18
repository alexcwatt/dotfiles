#!/bin/bash

git clone git@github.com:Shopify/dev-test-runner /src/github.com/shopify/dev-test-runner
EXTENSIONS_DIR=/home/${USER}/.vscode-server/extensions
cp "$(find /src/github.com/shopify/dev-test-runner/*.vsix | tail -1)" "${EXTENSIONS_DIR}/dev-test-runner.vsix"
/usr/bin/code --extensions-dir="${EXTENSIONS_DIR}" --install-extension "${EXTENSIONS_DIR}/dev-test-runner.vsix"
