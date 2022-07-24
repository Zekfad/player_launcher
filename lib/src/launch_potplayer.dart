import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'potplayer_launch_arguments.dart';


void launchPotPlayer(String executablePath, PotPlayerLaunchArguments arguments) {
  final lpApplicationName = TEXT(executablePath);
  final lpCommandLine = TEXT('"$executablePath" $arguments');
  final lpStartupInfo = calloc<STARTUPINFO>();
  final lpProcessInformation = calloc<PROCESS_INFORMATION>();

  CreateProcess(
    lpApplicationName,
    lpCommandLine,
    nullptr,
    nullptr,
    FALSE,
    CREATE_DEFAULT_ERROR_MODE | CREATE_NEW_PROCESS_GROUP | DETACHED_PROCESS,
    nullptr,
    nullptr,
    lpStartupInfo,
    lpProcessInformation,
  );

  free(lpApplicationName);
  free(lpCommandLine);
  free(lpStartupInfo);
  free(lpProcessInformation);
}
