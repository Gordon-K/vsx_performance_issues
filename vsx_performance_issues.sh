#!/bin/bash

# Kyle Gordon
# Diamond Services Engineer
# Check Point Software Technologies Ltd.
# Version: 0.1.3
# Last Modified September 27, 2019

#
# This script gathers information needed to make performance tuning recomendations
#  for VSX GWs.
#

###############################################################################
# Dependencies
###############################################################################
if [[ -r /etc/profile.d/CP.sh ]]; then
    source /etc/profile.d/CP.sh
elif [[ -r /opt/CPshared/5.0/tmp/.CPprofile.sh ]]; then
    source /opt/CPshared/5.0/tmp/.CPprofile.sh
elif [[ -r $CPDIR/tmp/.CPprofile.sh ]]; then
    source $CPDIR/tmp/.CPprofile.sh
else
    echo "ERROR: Unable to find \$CPDIR/tmp/.CPprofile.sh"
    echo "Verify this file exists and you can read it"
    exit 1
fi

if [[ -r /etc/profile.d/vsenv.sh ]]; then
    source /etc/profile.d/vsenv.sh
elif [[ -r $FWDIR/scripts/vsenv.sh ]]; then
    source $FWDIR/scripts/vsenv.sh
else
    echo "\\nERROR: Unable to find /etc/profile.d/vsenv.sh or \$FWDIR/scripts/vsenv.sh"
    echo "Verify this file exists in either directory and you can read it\\n"
    exit 1
fi

###############################################################################
# Main
###############################################################################
mkdir -p /var/log/tmp
cd /var/log/tmp

for VS in $(vrf list vrfs)
do
    vsenv $VS >VS"$VS"_Info.txt 2>&1
    if [[ "$VS" -eq "0" ]]
    then
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "fw ctl affinity -l -a -r -v" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        fw ctl affinity -l -a -r -v >>VS"$VS"_Info.txt 2>&1

        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "cpmq get -v" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        cpmq get -v >>VS"$VS"_Info.txt 2>&1

        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "ls -l /var/log/crash" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        ls -l /var/log/crash >>VS"$VS"_Info.txt 2>&1

        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "ls -l /var/log/dump/usermode" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        ls -l /var/log/dump/usermode >>VS"$VS"_Info.txt 2>&1

        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "top -b -n 1" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        top -b -n 1 >>VS"$VS"_Info.txt 2>&1

        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        echo "vs_bits -stat" >>VS"$VS"_Info.txt 2>&1
        echo "===================================================" >>VS"$VS"_Info.txt 2>&1
        vs_bits -stat >>VS"$VS"_Info.txt 2>&1
    fi
    # Clustering
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    echo "cphaprob stat" >>VS"$VS"_Info.txt 2>&1
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    cphaprob stat >>VS"$VS"_Info.txt 2>&1

    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    echo "cphaprob list" >>VS"$VS"_Info.txt 2>&1
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    cphaprob list >>VS"$VS"_Info.txt 2>&1

    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    echo "cphaprob -a if" >>VS"$VS"_Info.txt 2>&1
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    cphaprob -a if >>VS"$VS"_Info.txt 2>&1
    # Network/interfaces
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    echo "netstat -ni" >>VS"$VS"_Info.txt 2>&1
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    netstat -ni >>VS"$VS"_Info.txt 2>&1

    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    echo "ethtool" >>VS"$VS"_Info.txt 2>&1
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1
    for INTERFACE in $(ifconfig -a | sed 's/[ \t].*//;/^$/d'); do
        echo "# ethtool $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -i $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -i $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -k $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -k $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -g $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -g $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -S $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -S $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -a $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -a $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1

        echo "# ethtool -c $INTERFACE" >>VS"$VS"_Info.txt 2>&1
        echo "--------------------------------" >>VS"$VS"_Info.txt 2>&1
        ethtool -c $INTERFACE >>VS"$VS"_Info.txt 2>&1
        echo "" >>VS"$VS"_Info.txt 2>&1
    done
    # SecureXL
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "fwaccel stat" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    fwaccel stat >>VS"$VS"_Info.txt 2>&1;

    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "fwaccel stats -s" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    fwaccel stats -s >>VS"$VS"_Info.txt 2>&1;
    # Connections
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "fw tab -t connections -s" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    fw tab -t connections -s >>VS"$VS"_Info.txt 2>&1;
    # CoreXL
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "fw ctl multik stat" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    fw ctl multik stat >>VS"$VS"_Info.txt 2>&1;
    # Blades
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "enabled_blades" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    enabled_blades >>VS"$VS"_Info.txt 2>&1;
    # Logs
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "messages" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    for FILE in $(ls /var/log/messages*)
    do
        cat $FILE >>VS"$VS"_Info.txt 2>&1;
    done
    # Kernel Parameters
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    echo "fwkern.conf" >>VS"$VS"_Info.txt 2>&1;
    echo "===================================================" >>VS"$VS"_Info.txt 2>&1;
    cat $FWDIR/boot/modules/fwkern.conf >>VS"$VS"_Info.txt 2>&1;
done

echo "TARing up all data collected into one nice .tgz for you..."
tar zcvf "$HOSTNAME"_VSX_Info.tgz VS*_Info.txt
echo "All information collected. Please upload /var/log/tmp/VSX_Info.tgz."

