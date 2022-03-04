!/bin/bash

if [ "$1" == "" ]
then
echo "You forgot an IP Address!"
echo "Syntax: ./ipsweep.sh 192.168.20"

else
for ip in `seq 1 254`; do
ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
done
fi

# Credit goes to Heath Adams and his PEH Course from TCM Security from which I've gained tremendous value through my PNPT journey.