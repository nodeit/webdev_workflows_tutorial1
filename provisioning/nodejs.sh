#!/bin/bash

# download node tarball
sudo wget https://nodejs.org/dist/v4.2.1/node-v4.2.1-linux-x64.tar.gz

# unarchive tarball
sudo tar xzf node-v4.2.1-linux-x64.tar.gz -C /usr/local

# cleanup
sudo rm node-v4.2.1-linux-x64.tar.gz

# add symlink to /usr/local
sudo ln -s /usr/local/node-v4.2.1-linux-x64 /usr/local/node

# add node to path
echo 'export PATH=/usr/local/node/bin:$PATH' >> ~/.profile

# source the profile
source ~/.profile