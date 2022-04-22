#!/bin/bash

# TO-DO
# Include Subdomain Takeovers with Subjack
# Workaround for consistent Nmap Scans
# Installing dependancies for Enumeration Tools

echo " ___       __   _______   ________          _______   ________   ___  ___  _____ ______   _______   ________  ________  _________  ___  ________  ________      
|\  \     |\  \|\  ___ \ |\   __  \        |\  ___ \ |\   ___  \|\  \|\  \|\   _ \  _   \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\   __  \|\   ___  \    
\ \  \    \ \  \ \   __/|\ \  \|\ /_       \ \   __/|\ \  \\ \  \ \  \\\  \ \  \\\__\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \|\  \ \  \\ \  \   
 \ \  \  __\ \  \ \  \_|/_\ \   __  \       \ \  \_|/_\ \  \\ \  \ \  \\\  \ \  \\|__| \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \  
  \ \  \|\__\_\  \ \  \_|\ \ \  \|\  \       \ \  \_|\ \ \  \\ \  \ \  \\\  \ \  \    \ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \  \\\  \ \  \\ \  \ 
   \ \____________\ \_______\ \_______\       \ \_______\ \__\\ \__\ \_______\ \__\    \ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \_______\ \__\\ \__\
    \|____________|\|_______|\|_______|        \|_______|\|__| \|__|\|_______|\|__|     \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|_______|\|__| \|__|
                                                                                                                                                                
                                                                                                                                                                
                                                                                                                                                                "

echo "Usage: ./webenumeration.sh <url>"

url=$1

if [ ! -d "$url" ];then #if there isn't a current directory with the url name, make one
        mkdir $url
fi

if [ ! -d "$url/recon" ];then #if there isn't a current directory with the url name and recon sub-directory, make one
        mkdir $url/recon
fi

if [ ! -d "$url/recon/gowitness" ];then #if there isn't a current directory for Go witness screenshots, make one
        mkdir $url/recon/gowitness
fi

if [ ! -d "$url/recon/scans" ];then #if there isn't a current directory for Nmap scans, make one
        mkdir $url/recon/scans
fi

if [ ! -d "$url/recon/httprobe" ];then #if there isn't a current directory for alive domains, make one
        mkdir $url/recon/httprobe
fi

if [ ! -f "$url/recon/httprobe/alivedomains.txt" ];then #if there isn't a file in the httpprobe directory for alive domains, create one
        touch $url/recon/httprobe/alivedomains.txt
fi

if [ ! -f "$url/recon/httprobe/finaldomains.txt" ];then #if there isn't a file in the httpprobe directory for filtered domains, create one
        touch $url/recon/httprobe/finaldomains.txt
fi

#####################################################################################################################################################

echo ""
echo "[+] Harvesting Subdomains with Assetfinder..."
assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt

#####################################################################################################################################################

# echo ""
# echo "[+] Harvesting Subdomains with Amass..."
# amass enum -d $url >> $url/recon/f.txt
# sort -u $url/recon/f.txt >> $url/recon/final.txt
# rm $url/recon/f.txt

#####################################################################################################################################################

echo ""
echo "[+] Probing for alive domains with httprobe..."

cat $url/recon/final.txt | sort -u | httprobe >> $url/recon/httprobe/alivedomains.txt
cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/httprobe/httpsfiltered.txt

#####################################################################################################################################################

echo ""
echo "[+] Scanning for open ports with Nmap..."
nmap -iL $url/recon/httprobe/alivedomains.txt -T5 -oA $url/recon/scans/scanned.txt

#####################################################################################################################################################

echo ""
echo "[+] Running gowitness against all compiled domains..."
gowitness file -f $url/recon/httprobe/finaldomains.txt

#####################################################################################################################################################