#!/bin/bash
#######################################################################
# Uninstall BeyondTrust Jump Client (macOS)
# Removes processes, hidden app folder, LaunchDaemons, and helper scripts
# Keeps /Library/BomgarSupport intact
#######################################################################

LOG_FILE="/var/logs/bomgar_jumpclient_uninstall.log"
exec > "$LOG_FILE" 2>&1
set -x

echo "===== Starting BeyondTrust Jump Client uninstall ====="

#1 Stop Jump Client processes
echo "Stopping Jump Client processes..."
pkill -f sdcust || echo "No sdcust processes running"

#2 Unload and remove all BeyondTrust LaunchDaemons
echo "Unloading and removing LaunchDaemons..."
for plist in /Library/LaunchAgents/com.bomgar.bomgar-scc-pinned-login-drone-*.plist; do
    if [ -f "$plist" ]; then
        sudo launchctl bootout system "$plist" || echo "Failed to unload $plist"
        sudo rm -rf "$plist"
        echo "Removed $plist"
    fi
done

#3 Remove hidden application folders
echo "Removing hidden Jump Client app folders..."
for appdir in /Applications/.com.bomgar.scc.*; do
    if [ -d "$appdir" ]; then
        sudo rm -rf "$appdir"
        echo "Removed $appdir"
    fi
done

#4 Remove helper in LaunchDaemons directory.
echo "Removing helper files in the directory Library/LaunchDaemons..."
for helperdir in /Library/LaunchDaemons/*com.bomgar.bomgar-ps-*.helper; do
    if [ -d "$helperdir" ]; then
        sudo rm -rf "$helperdir"
        echo "Removed helper directory $helperdir"
    fi
done

#5 Remove plist in LaunchDaemons directory. 
echo "Removing .plist files in the directory Library/LaunchDaemons..."
for plist in /Library/LaunchDaemons/com.bomgar.bomgar-ps-*.plist; do
    if [ -d "$plist" ]; then
        sudo rm -rf "$plist"
        echo "Removed helper directory $plist"
    fi
done

#6 Cleanup Package unload folder
echo "Removing "/Library/BeyondTrust" folder and all it's contents && "Removing /Library/bomgar/" contents as well"
sudo rm -rf "/Library/BeyondTrust" || echo "No "/Library/BeyondTrust" directory found"
sudo rm -rf "/Library/bomgar" || echo "No "/library/bomgar" directory found" 

echo "Uninstall completed."
exit 0


