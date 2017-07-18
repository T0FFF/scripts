#!/bin/sh



dockerfile_result=$(wget -qO- https://raw.githubusercontent.com/orange-cloudfoundry/orange-cf-bosh-cli/master/Dockerfile)

bosh_cli_version="$(echo "$dockerfile_result" | grep bosh_cli_version= |  cut -d \" -f2)"
bosh_init_version="$(echo "$dockerfile_result" | grep bosh_init_version= |  cut -d \" -f2)"
cf_cli_version="$(echo "$dockerfile_result" | grep cf_cli_version= |  cut -d \" -f2)"
terraform_version="$(echo "$dockerfile_result" | grep terraform_version= |  cut -d \" -f2)"
http_proxy=
https_proxy=

sudo apt-get update && sudo apt-get install -y procps

curl -sSL https://rvm.io/mpapis.asc | gpg --import -
sudo curl -L https://get.rvm.io | bash

. /etc/profile.d/rvm.sh

if ! grep -q "/etc/profile.d/rvm.sh" ~/.zshrc
then
	echo ". /etc/profile.d/rvm.sh" >> ~/.zshrc
fi

/bin/bash -l -c "http_proxy=$http_proxy https_proxy=$https_proxy rvm requirements" 
/bin/bash -l -c "http_proxy=$http_proxy https_proxy=$https_proxy rvm install 2.3" 
/bin/bash -l -c "http_proxy=$http_proxy https_proxy=$https_proxy rvm use 2.3"
/bin/bash -l -c "http_proxy=$http_proxy https_proxy=$https_proxy gem install bosh_cli --no-ri --no-rdoc -v ${bosh_cli_version}"

wget -O /usr/local/bin/bosh-init "https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-${bosh_init_version}-linux-amd64"
chmod 755 /usr/local/bin/bosh-init

wget -O /tmp/cf.deb "https://cli.run.pivotal.io/stable?release=debian64&version=${cf_cli_version}&source=github-rel"
dpkg -i /tmp/cf.deb

wget -O /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip"
sudo unzip -o /tmp/terraform.zip -d /usr/local/bin 
sudo chmod 755 /usr/local/bin/terraform

export LC_ALL=C && \
sudo pip install --upgrade pip && \
sudo pip install python-openstackclient
