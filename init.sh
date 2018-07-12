#!/bin/bash

allprogs=(curl curl emacs emacs gcc gcc ifconfig net-tools inxi inxi make build-essential ssh ssh terminator terminator);
allprogsPost=(emacs emacs npm npm);
		
		NORM="$(tput sgr0)"
		BOLD="$(tput bold)"
		REV="$(tput smso)"
		UND="$(tput smul)"
		BLACK="$(tput setaf 0)"
		RED="$(tput setaf 1)"
		GREEN="$(tput setaf 2)"
		YELLOW="$(tput setaf 3)"
		BLUE="$(tput setaf 4)"
		MAGENTA="$(tput setaf 90)"
		MAGENTA1="$(tput setaf 91)"
		MAGENTA2="$(tput setaf 92)"
		MAGENTA3="$(tput setaf 93)"
		GREY="$(tput setaf 240)"
		CYAN="$(tput setaf 6)"
		WHITE="$(tput setaf 7)"
		ORANGE="$(tput setaf 172)"
		ERROR="${REV}Error:${NORM}"

msg(){
	if [[ $2 = "c" ]]; then
		txt="${YELLOW}checking${NORM}"
	elif [[ $2 = "i" ]]; then
		txt="${ORANGE}installing${NORM}"
	elif [[ $2 = "d" ]]; then
		txt="${GREEN}installed${NORM}"
	fi
	size=${#1}
	if [[ $size -lt 8 ]]; then
		tabs="\t\t\t"
	elif [[ $size -lt 15 ]]; then
		tabs="\t\t"
	elif [[ $size -lt 22 ]]; then
		tabs="\t"
	else
		tabs=""
	fi
echo -en "\r$1${tabs}$txt"
}

installif(){
	check=$1
	aptprogname="$2"
	msg $1 c
	which $check >> /dev/null
	if [[ $? -ne 0 ]]; then
		msg $1 i
		sudo apt-get install -y $aptprogname
		if [[ $? -ne 0 ]]; then
			msg $1 e
		else
			msg $1 d
		fi
	else
		msg $1 d
	fi
		echo ""
}

installnvmnode(){
	name="nvm-node"
	msg $name c
	which node >> /dev/null
	if [[ $? -ne 0 ]]; then
		msg $name i
		pushd . >> /dev/null
		curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -o install_nvm.sh
		bash install_nvm.sh
		source ~/.profile
		nvm install 8.11.3
		nvm use 8.11.3
		if [[ $? -ne 0 ]]; then
			msg $name e
		else
			msg $name d
		fi
	else
		msg $name d
	fi
	echo ""
}

installsublimetext(){
	msg sublime c
	which subl >> /dev/null
	if [[ $? -ne 0 ]]; then
		pushd . >> /dev/null
		msg sublime i
		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
		sudo apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
		sudo apt-get install sublime-text
		if [[ $? -ne 0 ]]; then
			msg sublime e
		else
			msg sublime d
		fi
		popd >> /dev/null
	else
		msg sublime d
	fi
	echo ""
}

installslack(){
	msg slack c
	which slack >> /dev/null
	if [[ $? -ne 0 ]]; then
		msg slack i
		sudo snap install slack --classic
		if [[ $? -ne 0 ]]; then
			msg slack e
		else
			msg slack d
		fi
	else
		msg slack d
	fi
	echo ""
}



installchrome(){
	msg chrome c
	which google-chrome >> /dev/null
	if [[ $? -ne 0 ]]; then
		msg chrome i
		installif gdebi gdebi-core
		pushd . >> /dev/null
		cd /tmp
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo gdebi -n google-chrome-stable_current_amd64.deb
		if [[ $1 -ne 0 ]]; then
			msg chrome e
		else
			msg chrome d
		fi
		popd >> /dev/null
	else
		msg chrome d
	fi
	echo ""
}
	installall(){
		tLen=${#allprogs[@]}
	for (( i=0; i<${tLen}; i+=2 )); do
		check=${allprogs[$i]};
		b=$(( $i + 1 ));
		inst=${allprogs[$b]};
  		installif $check $inst
	done

	}
	installallPost(){
		tLen=${#allprogsPost[@]}
	for (( i=0; i<${tLen}; i+=2 )); do
		check=${allprogsPost[$i]};
		b=$(( $i + 1 ));
		inst=${allprogsPost[$b]};
  		installif $check $inst
	done

	}
diableAutomount() {
 gsettings set org.gnome.desktop.media-handling automount false	
	}

	installall
	installslack
	installnvmnode
	installsublimetext
	installchrome
	installallPost
	diableAutomount