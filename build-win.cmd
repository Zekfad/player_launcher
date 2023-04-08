rmdir build /s /q
mkdir build
dart compile exe bin/launcher.dart -o build/launcher.exe --target-os windows
