#!/bin/bash

rm ~/.gitconfig-local

# Install longjumper_spin
sudo gem install specific_install
sudo gem specific_install https://github.com/Shopify/longjumper_spin.git
