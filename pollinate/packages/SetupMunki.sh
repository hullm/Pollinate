#!/bin/bash
 
# AppleSoftwareUpdatesOnly
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist AppleSoftwareUpdatesOnly -bool false
 
# InstallAppleSoftwareUpdates
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist InstallAppleSoftwareUpdates -bool true
 
# SoftwareRepoURL
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist SoftwareRepoURL -string "https://munki.domain.com/repo"
 
# ClientIdentifier
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist ClientIdentifier -string "app_store"
 
# ManagedInstallDir
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist ManagedInstallDir -string "/Library/Managed Installs"
 
# LogFile
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist LogFile -string "/Library/Managed Installs/Logs/ManagedSoftwareUpdate.log"
 
# LogToSyslog
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist LogToSyslog -bool false
 
# LoggingLevel
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist LoggingLevel -int 0
 
# DaysBetweenNotifications
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist DaysBetweenNotifications -int 1
 
# UseClientCertificate
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist UseClientCertificate -bool false
 
# AdditionalHttpHeaders
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist AdditionalHttpHeaders -array "Authorization: Basic aaaaaaaaaaaaa=="
 
# PackageVerificationMode
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist PackageVerificationMode -string "hash"
 
# SuppressUserNotification
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist SuppressUserNotification -bool false
 
# SuppressAutoInstall
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist SuppressAutoInstall -bool false
 
# SuppressStopButtonOnInstall
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist SuppressStopButtonOnInstall -bool false

# FollowHTTPRedirects
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist FollowHTTPRedirects -string "none"

# UnattendedAppleUpdates
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist UnattendedAppleUpdates -bool true

# ShowOptionalInstallsForHigherOSVersions
/usr/bin/defaults write /Volumes/Macintosh\ HD/Library/Preferences/ManagedInstalls.plist ShowOptionalInstallsForHigherOSVersions True

# Delete the network settings
rm /Volumes/Macintosh\ HD/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist