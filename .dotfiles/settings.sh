#!/usr/bin/env bash

# Thanks to Mathias Bynens! https://mths.be/macos

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set standby delay to 24 hours (default is 1 hour)
# sudo pmset -a standbydelay 86400

echo "Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

# echo "Remove duplicates in the 'Open With' menu (also see 'lscleanup' alias)"
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user


echo "Disable menu bar transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

echo "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "Disable the \“Are you sure you want to open this application?\” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo "Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

echo "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "Trackpad: enable three-finger drag"
# Note: Setting three finger drag disables other three finger settings when set through preference pane
defaults write com.apple.AppleMultitouch.trackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.AppleMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1

echo "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Use scroll gesture with the Ctrl (^) modifier key to zoom"
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
#defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write "com.apple.AppleMultitouchTrackpad" HIDScrollZoomModifierMask -int 262144
defaults write "com.apple.driver.AppleBluetoothMultitouch.trackpad" HIDScrollZoomModifierMask -int 262144

echo "Follow the keyboard focus while zoomed in"
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

echo "Set language and text formats"
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

echo "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

echo "Require password 15 seconds after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 15

echo "Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

echo "Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "Allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true

echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# echo "Enable snap-to-grid for icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $HOME/Library/Preferences/com.apple.finder.plist

# echo "Increase grid spacing for icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" $HOME/Library/Preferences/com.apple.finder.plist

# echo "Increase the size of icons on the desktop and in other icon views"
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" $HOME/Library/Preferences/com.apple.finder.plist

echo "Show the ~/Library folder"
chflags nohidden $HOME/Library

echo "Expand the following File Info panes: General, Open with, and Sharing & Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Auto hide menu bar
# defaults write NSGlobalDomain _HIHideMenuBar -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

echo "Dark menu bar and dock"
defaults write $HOME/Library/Preferences/.GlobalPreferences.plist AppleInterfaceTheme -string "Dark"

echo "Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo "Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo "Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

# Group windows by application in Mission Control
# defaults write com.apple.dock expose-group-by-app -bool true

# Disable Dashboard
# defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true

echo "Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo "Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "Show Bluetooth in menu bar"
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "Show Volume in menu bar"
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Volume.menu"

# Add iOS & Watch Simulator to Launchpad
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Put display to sleep
# defaults write com.apple.dock wvous-tr-corner -int 10
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Put display to sleep
defaults write com.apple.dock wvous-br-corner -int 10
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

echo "Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
# defaults write com.apple.mail DisableReplyAnimations -bool true
# defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachments (just show the icons)
# defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

echo "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Time Machine                                                                #
###############################################################################

echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true


###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "Visualize CPU history in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 6

echo "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility
###############################################################################

echo "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0
echo "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "Show 24 hours a day"
defaults write com.apple.ical "number of hours displayed" 24

echo "Week should start on Monday"
defaults write com.apple.ical "first day of the week" 1

echo "Day starts at 9AM"
defaults write com.apple.ical "first minute of work hours" 540

###############################################################################
# Battery.                                                                    #
###############################################################################

echo "Show battery percentage"
defaults write com.apple.menuextra.battery ShowPercent -string YES

###############################################################################
# Date & Time                                                                 #
###############################################################################

# Custom DateFormat
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  H:mm a"
defaults write com.apple.menuextra.clock IsAnalog -bool false

###############################################################################
# Photos                                                                      #
###############################################################################

echo "Prevent Photos from opening automatically when devices are plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# iTunes                                                                      #
###############################################################################

# echo "Stop iTunes from responding to the keyboard media keys"
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

###############################################################################
# iTerm2                                                                      #
###############################################################################

defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -bool false

###############################################################################
# Remove unwanted apps from the dock and add preferred apps                   #
###############################################################################

dockutil --remove 'Siri'
dockutil --remove 'Notes'
dockutil --remove 'Reminders'
dockutil --remove 'Contacts'

dockutil --add /Applications/Firefox.app --replacing 'Safari'
dockutil --add /Applications/Spotify.app

###############################################################################
# Kill affected applications                                                  #
###############################################################################

# for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#     "Dock" "Finder" "Mail" "Messages" "Photos" "Safari" "SystemUIServer" \
#     "Terminal" "Tweetbot" "iCal"; do
#     killall "${app}" &> /dev/null
# done

echo "Done. Note that some of these changes require a logout/restart to take effect."
