#!/bin/bash
#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/v2ray/vless.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo -e	"  NO ${GREEN}USER   ${RED}EXPIRED ${BLUE}Net${NC}"
        grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 2,3,6,7 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
hariini=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
uuid=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 5 | sed -n "${CLIENT_NUMBER}"p)
tlvs=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 6 | sed -n "${CLIENT_NUMBER}"p)
g=$(grep -E "^## " "/etc/xray/config.json" | cut -d ' ' -f 7 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^## $user $exp $hariini $uuid $tlvs/,/^},{/d" /etc/xray/config.json
sed -i "/^## $user $exp $hariini $uuid $tlvs $g/,/^},{/d" /etc/xray/config.json
systemctl restart xray.service
clear
echo ""
echo "==============================="
echo "${NC}${GREEN} VMESS AKUN BERHASIL DI HAPUS ${NC}"
echo "==============================="
echo "Username  : $user"
echo "Expired   : $exp"
echo "==============================="
echo "AKCELL XRAY MULTI VLESS"
read -p "Press Enter For Back To V2Ray/VLess Menu / CTRL+C To Cancel : "
