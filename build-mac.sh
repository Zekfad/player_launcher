#!/bin/bash

app_folder="./build/Player Launcher.app"
app_executable="$app_folder/Contents/MacOS/player-launcher"
libs_folder="$app_folder/Contents/Frameworks"
rm -rf ./build
mkdir -p "$app_folder"
mkdir -p "$libs_folder"
cp -r ./mac/App/* "$app_folder"
dart compile exe bin/launcher.dart -o "$app_executable" --target-os macos
clang -dynamiclib -undefined dynamic_lookup -fvisibility=default -o "$libs_folder/libalert.dylib" ./mac/libalert/alert.c
chmod -R 755 "$app_folder"
chmod 644 "$app_folder/Contents/Info.plist"
