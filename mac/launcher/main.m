#include "main.h"


@implementation AppDelegate {
	NSString * url;
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *) event
		   withReplyEvent:(NSAppleEventDescriptor *) replyEvent {
	url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
}

- (void)applicationWillFinishLaunching:(NSNotification *) notification {
	NSAppleEventManager * appleEventManager = [NSAppleEventManager sharedAppleEventManager];
	[appleEventManager setEventHandler:self
					   andSelector:@selector(handleGetURLEvent:withReplyEvent:)
					   forEventClass:(AEEventClass)kInternetEventClass
					   andEventID:(AEEventID)kAEGetURL];
}

- (void)applicationDidFinishLaunching:(NSNotification *) notification {
	[NSApp stop:nil];

	// Assuming key exist and valid
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSString * targetExecutable = [mainBundle objectForInfoDictionaryKey:@"moe.null.zekfad.launcher.target_executable"];
	NSString * targetExecutablePath = [mainBundle pathForAuxiliaryExecutable:targetExecutable];

	NSTask * task = [NSTask new];
	[task setLaunchPath:targetExecutablePath];

	if (url == nil) {
		NSArray * arguments = [[NSProcessInfo processInfo] arguments];
		[task setArguments:[arguments subarrayWithRange:NSMakeRange(1, arguments.count - 1)]];
	} else {
		[task setArguments:@[url]];
	}

	[task launch];
}
@end

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		[NSApplication sharedApplication];
		[NSApp setDelegate:[AppDelegate new]];
		return NSApplicationMain(argc, argv);
	}
}
