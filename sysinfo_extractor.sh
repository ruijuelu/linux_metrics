#!/bin/bash
#<---the above Shebang indicates that the script should be run with the Bash shell--->

#assign the figlet command to create an ASCII Art Banners
banner=$(figlet "SYS.INFO Extractor")

#using the flag 'echo -e' to escape sequence
#using "\n which is supported by the "escape sequence" to insert a line break after running the bash script within the terminal
echo -e "\n"

#the printf command prints the string !' 10 times on a single line. 
#the %.0s format specifier tells printf to ignore the generated numbers from the {1..23} sequence and only print the char '\' 23 times 
printf "%.0s\ " {1..23}; echo 
printf "%.0s\ " {1..23}; echo 
#using echo to display the banner on the terminal window and an '-e' for a line break
echo "$banner"
printf "%.0s\ " {1..23}; echo
printf "%.0s\ " {1..23}; echo -e "\n"
#inform user: start of the session
echo -e "Hello there~ Please hold on while we retrieve your system information: \n"

#assign the displaying ('cat') of the name and ver. of Linux distribution sys to the variables
#'grep' to extract the name and version of the sys
LX_VERNAME=$(cat /etc/os-release | grep "NAME=" | grep -vi "Rolling" | awk -F= '{print$2}')
LX_VER=$(cat /etc/os-release | grep "VERSION_ID=" | awk -F= '{print$2}' )

#extracts your external facing IP from website "ifconfig.io" using the terminal command line tool 'curl' 
EXTIP=$(curl -s ifconfig.io) 

#using the 'hostname' command to retrieves name assigned to identify your network 
#the flag '-I' is use together with the 'hostname' command to extract your internal network IP
INTIP=$(hostname -I) 

#using the 'ifconfig' command to obtain the configuration of network interfaces for details of IPs, subnet mask and MAC add
#the command line tool 'grep' chained  is find specific text within the info "ether" returned by ifconfig
#awk is used to manipulate the output to display the MAC address located on the 2nd position of the line extractedgtom the chained command line: "if config | grep 'ether'"
#awk -F is used to filtering alphanum or special char etc..
MACADDR=$(ifconfig | grep 'ether' | awk '{print $2}' | awk -F: '{print "XX:XX:XX:"$4":"$5":"$6}')

#extracts the header of the process list showing PID, command, and CPU usage.
#'ps' command to report a snapshot of the currennt processes
#'-e' flag selects all processes
#'-o' Specifies the format of the output (in this case: pid,comm,%cpu)
CPU_HEADER=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 1 | awk '{print "\t"$0}')

#extracts the top 5 processes by CPU usage, formats the output, and adds line numbers.

CPU=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | sed '1d; 7d' | nl)

#retrieves the total memory used.
#the 'free' command displays the amount of free and used memory in the system.
#the '-h'option makes the output human-readable (i.e., it uses size units like KB, MB, GB).
USED_SPACE=$(free -h | grep "Mem:" | head -n 1 | awk '{print $2}')
FREE_SPACE=$(free -h | grep "Mem:" | head -n 1 | awk '{print $3}')

#lists active system services and formats the output with line numbers.
#'systemctl' introspect and control the state of the systemd system and service manager.
#'list-units' lists the systemd units.
#'--type=service' filters the output to include only units of type service
#'--state=active' filters the output to include only units that are active
ACTIVE_SYS=$(systemctl list-units --type=service --state=active | grep "active" | awk '{print$1  " >>> " "[status:] " $4}' | nl)

#finds the top 10 largest files in the /home directory and formats the output with line numbers.
TOPTEN_FILES=$(sudo find /home -type f -exec du -h {} + | sort -rh | head -n 10 | nl)

#these lines inform the user that various pieces of system information are being retrieved
#using echo to inform shell script user that info extraction is in progress & flag '-e' for line break
echo "[+] Retrieving your Linux Version..."
echo "[+] Retrieving your External IP address..."
echo "[+] Retrieving your Internal IP address..."
echo "[+] Retrieving your MAC address..."
echo "[+] Retrieving your top 5 processes' CPU usage..."
echo "[+] Retrieving your system memory usage..."
echo "[+] Retrieving your active system information..."
#using echo to inform shell script user of the results & flag '-e' for line break
echo -e "[+] Retrieving your top 10 files(size) from the /home directory... \n"

#these lines print the retrieved system information to the terminal.
#using echo to inform shell script user of the results & flag '-e' for line break
echo -e "Here are the information: \n"
echo "Your Linux system is $LX_VERNAME and the version is $LX_VER"
echo "Your External IP Address is $EXTIP"
echo "Your Internal IP Address is $INTIP"
echo -e "Your MAC Address is $MACADDR \n"
echo -e "Your top 5 processes' CPU usage are as follows: \n"
echo -e "$CPU_HEADER"
echo -e "$CPU \n"
echo -e "Your system is currently using $USED_SPACE of space and has $FREE_SPACE of free space available. \n"
echo -e "Your active system(s) and status is/are as follows:\n"
echo -e "$ACTIVE_SYS \n"
echo -e "Your top 10 files(size) from the /home directory are as follows:\n"
echo -e "$TOPTEN_FILES \n"

#inform user: end of the session
echo "- - -[End-of-Extraction]- - -"
