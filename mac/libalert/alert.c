#include <CoreFoundation/CoreFoundation.h>

bool alert(const char * header, const char * message, uint32_t level) {
	// convert the strings from char * to CFStringRef
	CFStringRef header_ref  = CFStringCreateWithCString(NULL, header,  strlen(header));
	CFStringRef message_ref = CFStringCreateWithCString(NULL, message, strlen(message));
	
	CFOptionFlags result;  // result code from the message box
	
	// launch the message box
	CFUserNotificationDisplayAlert(
		0, // timeout
		level   == 0 ? kCFUserNotificationPlainAlertLevel
		: level == 1 ? kCFUserNotificationNoteAlertLevel
		: level == 2 ? kCFUserNotificationCautionAlertLevel
		             : kCFUserNotificationStopAlertLevel,
		NULL, // iconURL
		NULL, // soundURL
		NULL, // localizationURL
		header_ref, // alertHeader 
		message_ref, // alertMessage
		NULL, // defaultButtonTitle
		CFSTR("Cancel"), // alternateButtonTitle
		NULL, // otherButtonTitle
		&result // responseFlags
	);
	
	//Clean up the strings
	CFRelease(header_ref);
	CFRelease(message_ref);
	
	//Convert the result
	if (result == kCFUserNotificationDefaultResponse)
		return true;
	else
		return false;
}
