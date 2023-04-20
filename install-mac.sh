#!/bin/bash
rm -rf "/Applications/Player Launcher.app"
cp -r "./build/Player Launcher.app" /Applications/
# sudo codesign --force --deep --sign - "/Applications/Player Launcher.app"
# sudo xattr -d -r com.apple.quarantine "/Applications/Player Launcher.app"
rm -rf "./build/Player Launcher.app"
