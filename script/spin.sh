#!/bin/bash

git clone git@github.com:Shopify/dev-test-runner /src/github.com/shopify/dev-test-runner
/usr/bin/code --install-extension "$(find /src/github.com/shopify/dev-test-runner/*.vsix | tail -1)"
