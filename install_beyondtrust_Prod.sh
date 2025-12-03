#!/bin/bash

LOGFILE="/var/logs/beyondtrust_install.log"

echo "[$(date)] BeyondTrust Jump Client Installation Started" >> "$LOGFILE"

# Remove quarantine attribute if needed
echo "[$(date)] Removing quarantine attribute from DMG..." >> "$LOGFILE"
if xattr -p com.apple.quarantine "/Library/BeyondTrust/bomgar-scc-w0eec30ije1dwggejejf6d5yhixjwji51ewx5zwc40hc90.dmg" >/dev/null 2>&1; then
    if xattr -d com.apple.quarantine "/Library/BeyondTrust/bomgar-scc-w0eec30ije1dwggejejf6d5yhixjwji51ewx5zwc40hc90.dmg" 2>>"$LOGFILE"; then
        echo "[$(date)] Quarantine attribute removed successfully." >>"$LOGFILE"
    fi
else
    echo "[$(date)] No quarantine attribute present on DMG." >>"$LOGFILE"
fi

# Mount DMG
echo "[$(date)] Mounting DMG..." >> "$LOGFILE"
MOUNT_OUTPUT=$(hdiutil attach -nobrowse -mountpoint /Volumes/bomgar-scc "/Library/BeyondTrust/bomgar-scc-w0eec30ije1dwggejejf6d5yhixjwji51ewx5zwc40hc90.dmg" 2>> "$LOGFILE")
if [ $? -eq 0 ]; then
    echo "[$(date)] DMG mounted successfully." >> "$LOGFILE"
else
    echo "[$(date)] Failed to mount DMG." >> "$LOGFILE"
    exit 1
fi

# Install silently (update path if needed)
echo "[$(date)] Running BeyondTrust installer silently..." >> "$LOGFILE"
if sudo /Volumes/bomgar-scc/Open\ To\ Start\ Support\ Session.app/Contents/MacOS/sdcust --silent >> "$LOGFILE" 2>&1; then
    echo "[$(date)] BeyondTrust installer ran successfully." >> "$LOGFILE"
else
    echo "[$(date)] BeyondTrust installer failed." >> "$LOGFILE"
    exit 2
fi

# Wait for installation to complete
echo "[$(date)] Sleeping for 15 seconds to allow installation to complete..." >> "$LOGFILE"
sleep 30

# Unmount the DMG
echo "[$(date)] Unmounting DMG..." >> "$LOGFILE"
if hdiutil detach /Volumes/bomgar-scc >> "$LOGFILE" 2>&1; then
    echo "[$(date)] DMG unmounted successfully." >> "$LOGFILE"
else
    echo "[$(date)] Failed to unmount DMG." >> "$LOGFILE"
fi

echo "[$(date)] BeyondTrust Jump Client Installation Completed" >> "$LOGFILE"