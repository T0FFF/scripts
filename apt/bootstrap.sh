#!/bin/sh

YELLOW='\033[1;33m'
NC='\033[0m' # No Color


if [ -z "$(which sudo)" ]; then
	echo "${YELLOW}sudo not found${NC}"
	apt-get update && apt-get install -y sudo
fi


echo "${YELLOW}Apt install${NC}"
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y zsh gcc make autoconf autogen automake shellcheck vim net-tools locate locales telnet silversearcher-ag tree tcpdump git unzip  \
	wget curl jq \
	linux-headers-$(uname -r) build-essential dpkg-dev \
	ssmtp mailutils zsh  \
        mysql-client \
	python-dev python-pip \
	maven gradle openjdk-8-jdk \
	nodejs \
	ruby ruby-dev \
	byobu 

echo "${YELLOW}Configure vim${NC}"
sudo sed -i "s/\"set background=dark/set background=dark/g" /etc/vim/vimrc

echo "${YELLOW}Configure zsh${NC}"
sh -c "$(wget https://raw.githubusercontent.com/T0FFF/oh-my-zsh/master/tools/install.sh -O -)"
if [ $(whoami) != "root" ]
then
	user=$(whoami)
	echo "source /home/$user/.zshrc" | sudo tee -a /root/.zshrc > /dev/null
	sudo chsh -s /bin/zsh $user
	sudo chsh -s /bin/zsh root
else
	chsh -s /bin/zsh root
fi

echo "${YELLOW}Configure timezone${NC}"
if ! grep -q "TZ='Europe" ~/.zshrc
then
	echo "TZ='Europe/Paris';export TZ" >> ~/.zshrc
fi

echo "Europe/Paris" | sudo tee /etc/timezone > /dev/null
sudo rm /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

echo "${YELLOW}Configure git${NC}"
git config --global credential.helper cache
git config --global user.name "Christophe LE COZ"
git config --global user.email christophe.lecoz@orange.com
git config --global http.sslUerify "false"

sudo apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove && sudo rm -rf /var/lib/{apt,dpkg,cache,log}
