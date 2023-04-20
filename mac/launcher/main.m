// Mac OS URL handler wrapper.
// This utility redirects URL handler call call to target app,
// Similarly, how it's done on Windows. Also, this utility redirects stdin,
// stdout and stderr with all command line arguments to target application.

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

	NSFileHandle * stdIn = [NSFileHandle fileHandleWithStandardInput];
	NSFileHandle * stdOut = [NSFileHandle fileHandleWithStandardOutput];
	NSFileHandle * stdErr = [NSFileHandle fileHandleWithStandardError];

	NSPipe * taskStdInPipe = [NSPipe pipe];
	NSPipe * taskStdOutPipe = [NSPipe pipe];
	NSPipe * taskStdErrPipe = [NSPipe pipe];

	[task setStandardInput:taskStdInPipe];
	[task setStandardOutput:taskStdOutPipe];
	[task setStandardError:taskStdErrPipe];

	NSFileHandle * taskStdIn = [taskStdInPipe fileHandleForWriting];
	NSFileHandle * taskStdOut = [taskStdOutPipe fileHandleForReading];
	NSFileHandle * taskStdErr = [taskStdErrPipe fileHandleForReading];

	// Redirect stdin
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSData * data = [stdIn availableData];
		while ([data length] > 0) {
			[taskStdIn writeData:data];
			data = [stdIn availableData];
		}
	});

	// Redirect stdout
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSData * data = [taskStdOut availableData];
		while ([data length] > 0) {
			[stdOut writeData:data];
			data = [taskStdOut availableData];
		}
	});

	// Redirect stderr
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSData * data = [taskStdErr availableData];
		while ([data length] > 0) {
			[stdErr writeData:data];
			data = [taskStdErr availableData];
		}
	});

	[task launch];
	[task waitUntilExit];

	// Terminate app when running from the command line
	[NSApp terminate:self];
}
@end

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		[NSApplication sharedApplication];
		[NSApp setDelegate:[AppDelegate new]];
		return NSApplicationMain(argc, argv);
	}
}
