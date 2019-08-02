#!/bin/bash

# bootstrappr.sh
# A script to install packages and scripts found in a packages folder in the same directory
# as this script to a selected volume

if [[ $EUID != 0 ]] ; then
    echo "Pollinate: Please run this as root, or via sudo."
    exit -1
fi

INDEX=0
OLDIFS=$IFS
IFS=$'\n'

echo "*** Welcome to Pollinate! ***"
echo
echo "*** Based on Bootstrappr by Greg Neagle ***"
echo "*** Modified by Matt Hull ***"
echo

#See if the default hard disk is available
for VOL in $(/bin/ls -1 /Volumes) ; do
    if [[ "${VOL}" == "Macintosh HD" ]] ; then
		SELECTEDVOLUME="Macintosh HD"
        echo "Macintosh HD Selected"
    fi
done

# If Macintosh HD wasn't found ask them to select a drive
if [[ "${SELECTEDVOLUME}" == "" ]]; then
		
	echo "Available volumes: (Default: 1)"
	for VOL in $(/bin/ls -1 /Volumes) ; do
		if [[ "${VOL}" != "OS X Base System" ]] ; then
			let INDEX=${INDEX}+1
			VOLUMES[${INDEX}]=${VOL}
			echo "    ${INDEX}  ${VOL}"
		fi
		read -p "Install to volume # (1-${INDEX}): " SELECTEDINDEX

		if [[ "${SELECTEDINDEX}" == "" ]]; then
			SELECTEDINDEX=1
		fi
		SELECTEDVOLUME=${VOLUMES[${SELECTEDINDEX}]}
	done
fi

# Get the computer name from the Inventory site
serialNumber=`/usr/sbin/ioreg -l | grep IOPlatformSerialNumber | cut -d'"' -f4`
oldComputerName=$(curl "http://inventory.domain.com/api.asp?Type=ComputerName&Serial=$serialNumber" 2>/dev/null)
assetTag=$(curl "http://inventory.domain.com/api.asp?Type=AssetTag&Serial=$serialNumber" 2>/dev/null)

# Set the defualt computer name, use the old name if found, otherwise use the asset tag, if that's not found use the serial
if [[ "${oldComputerName}" == "" ]]; then
	if [[ "${assetTag}" == "" ]]; then 
		defaultComputerName=$serialNumber
	else
		tagList=$(curl "http://inventory.domain.com/api.asp?Type=Tags&AssetTag=$assetTag" 2>/dev/null)
		defaultComputerName=$assetTag
	fi
else
	tagList=$(curl "http://inventory.domain.com/api.asp?Type=Tags&AssetTag=$assetTag" 2>/dev/null)
	defaultComputerName=$oldComputerName
fi

# See if there is a list of Tags in the database, if so display the list
if [[ "${tagList}" != "" ]]; then
    echo "Database Tags: $tagList"
fi
echo "Enter a name for this computer: (Default: $defaultComputerName)"

read computerName

# Set the computer name, use the serial numeber if one isn't specified
if [[ "${computerName}" == "" ]]; then
    computerName=$defaultComputerName
fi

/usr/bin/touch "/Volumes/${SELECTEDVOLUME}"/Users/Shared/computerName.txt
echo $computerName > "/Volumes/${SELECTEDVOLUME}"/Users/Shared/computerName.txt

if [[ "${SELECTEDVOLUME}" == "" ]]; then
    exit 0
fi

curl "http://inventory.domain.com/updatedevice.asp?Serial=$serialNumber&Task=Pollinated"
echo "Recording pollination to inventory site..."

echo
echo "Installing packages to /Volumes/${SELECTEDVOLUME}..."

# dirname and basename not available in Recovery boot
# so we get to use Bash pattern matching
BASENAME=${0##*/}
THISDIR=${0%$BASENAME}
PACKAGESDIR="${THISDIR}packages"

for ITEM in "${PACKAGESDIR}"/* ; do
	FILENAME="${ITEM##*/}"
	EXTENSION="${FILENAME##*.}"
	if [[ -e ${ITEM} ]]; then
		case ${EXTENSION} in
			sh ) 
				if [[ -x ${ITEM} ]]; then
					echo " - Running script:  ${FILENAME}..."
					# pass the selected volume to the script as $1
					${ITEM} "/Volumes/${SELECTEDVOLUME}" >/dev/null 2>&1
				else
					echo " - ${FILENAME} is not executable..."
				fi
				;;
			pkg ) 
				echo " - Installing package: ${FILENAME}..."
				/usr/sbin/installer -pkg "${ITEM}" -target "/Volumes/${SELECTEDVOLUME}" >/dev/null 2>&1
				;;
			* ) echo " - Unsupported file extension: ${ITEM}..." ;;
		esac
	fi
done

# Delete the defualt apps
rm -rfd "/Volumes/${SELECTEDVOLUME}/Applications/Keynote.app"
rm -rfd "/Volumes/${SELECTEDVOLUME}/Applications/Pages.app"
rm -rfd "/Volumes/${SELECTEDVOLUME}/Applications/Numbers.app"
rm -rfd "/Volumes/${SELECTEDVOLUME}/Applications/iMovie.app"
rm -rfd "/Volumes/${SELECTEDVOLUME}/Applications/GarageBand.app"
echo "Deleted unneeded built in apps."

/sbin/shutdown -r now