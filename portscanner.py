#!/bin/python3

# Usage - "python3 portscanner.py <ip>"
# Argument 0 - running the file; Argument 1 is specifying the IP

import sys
import socket
from datetime import datetime

#Defining the Target
if len(sys.argv) == 2: #equivalent to specifying $1 in Bash
        target = socket.gethostbyname(sys.argv[1]) #Translate hostname to IPv4
else:
        print("Invalid Argument. Please try again")
        print("Syntax: python3 portscanner.py <ip>")

# Adding a banner
print("-" * 50)
print("Scanning target " + target)
print("Time started: " +str(datetime.now()))
print("-" * 50)

try:
        for port in range(1,100): #for ips in the range of 1-100
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #AF_INET is IPv4, Sock is port
                socket.setdefaulttimeout(1) #time to connect is 1 second
                result = s.connect_ex((target,port)) #returns an error indicator
                if result == 0: #returns 0 if the port is open
                        print("Port {} is open".format(port))
                s.close()

except KeyboardInterrupt: #using something like Ctrl + C for example
        print("\nExiting program.")
        sys.exit()

except socket.gaierror: #DNS Errors
        print ("Hostname could not be resolved")
        sys.exit()

except socket.error:
        print ("Couldn't connect to server.")
        sys.exit()

# Credit goes to Heath Adams and his PEH Course from TCM Security from which I've gained tremendous value through my PNPT journey.
# This was pushed to Github to serve as a centralised repository for my scripts/notes/walkthroughs.