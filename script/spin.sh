#!/bin/bash

git clone git@github.com:Shopify/dev-test-runner /src/github.com/shopify/dev-test-runner
code --install-extension "$(find /src/github.com/shopify/dev-test-runner/*.vsix | tail -1)"
