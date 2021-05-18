#!/bin/bash

git clone git@github.com:Shopify/dev-test-runner /src/github.com/shopify/dev-test-runner
/bin/code-server --install-extension "$(find /src/github.com/shopify/dev-test-runner/*.vsix | tail -1)"
