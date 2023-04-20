#!/bin/bash

app_folder="./build/Player Launcher.app"
executables_folder="$app_folder/Contents/MacOS"
libs_folder="$app_folder/Contents/Frameworks"

launcher_executable="$executables_folder/launcher"
app_executable="$executables_folder/player-launcher"

rm -rf ./build
mkdir -p "$executables_folder"
mkdir -p "$libs_folder"
cp -r ./mac/App/* "$app_folder"

# Compile Dart app
dart compile exe bin/launcher.dart -o "$app_executable" --target-os macos

# Compile libalert
clang -dynamiclib -undefined dynamic_lookup -fvisibility=default \
	-o "$libs_folder/libalert.dylib" \
	./mac/libalert/alert.c

# # Compile libalert
# clang -fobjc-arc -fmodules -dynamiclib -undefined dynamic_lookup -fvisibility=default \
# 	-o "$libs_folder/libalert.dylib" \
# 	./mac/libalert/alert.m

# Compile launcher
clang -fobjc-arc -fmodules -undefined dynamic_lookup -fvisibility=default \
	-o "$launcher_executable" \
	./mac/launcher/main.m

chmod -R 755 "$app_folder"
chmod 644 "$app_folder/Contents/Info.plist"
