#!/usr/bin/env bash

set -e

echo "Creating /hubble..."
sudo mkdir -p /hubble
sudo chown -R $USER:$USER /hubble

echo
echo

echo "INSTALLING DEPS..."
sudo add-apt-repository ppa:certbot/certbot > /dev/null
sudo apt update > /dev/null
sudo apt install -y libpq-dev libcurl4-openssl-dev nginx \
                    zlib1g-dev libssl-dev libreadline-dev \
                    build-essential software-properties-common \
                    python-certbot-nginx > /dev/null
echo "DONE"

sleep 1
echo
echo

echo "INSTALLING RUBY..."
if [ -d "/hubble/ruby-2.5.0" ]; then
  echo "SKIP"
else
  git clone https://github.com/rbenv/ruby-build.git /tmp/ruby-build
  sudo bash -c "PREFIX=/hubble/ruby-build /tmp/ruby-build/install.sh"
  rm -rf /tmp/ruby-build
  /hubble/ruby-build/bin/ruby-build 2.5.0 /hubble/ruby-2.5.0
  echo "export PATH=\$PATH:/hubble/ruby-2.5.0/bin" >> ~/.bashrc
  echo "export RAILS_ENV={{RAILS_ENV}}" >> ~/.bashrc
  source ~/.bashrc
  /hubble/ruby-2.5.0/bin/ruby -v > /dev/null
  if [ ! $? -eq 0 ]; then
    echo "Ruby not installed correctly?"
    exit 1
  fi
  echo "gem: --no-rdoc --no-ri" > ~/.gemrc
  /hubble/ruby-2.5.0/gem install bundler
  echo "DONE"
fi

sleep 1
echo
echo

echo "INSTALLING NODE..."
if [ -d "/hubble/node-8.12" ]; then
  echo "SKIP"
else
  curl -s https://nodejs.org/dist/v8.12.0/node-v8.12.0-linux-x64.tar.xz > /tmp/node.tar.xz
  mkdir -p /hubble/node-8.12
  tar xf /tmp/node.tar.xz --directory /hubble/node-8.12 --strip-components=1
  rm /tmp/node.tar.xz
  echo "export PATH=$PATH:/hubble/node-8.12/bin" >> ~/.bashrc
  source ~/.bashrc
  /hubble/node-8.12/bin/node -v > /dev/null
  if [ ! $? -eq 0 ]; then
    echo "Node not installed correctly?"
    exit 1
  fi
  echo "DONE"
fi
