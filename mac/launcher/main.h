#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject<NSApplicationDelegate>
- (void)handleGetURLEvent:(NSAppleEventDescriptor *) event
		   withReplyEvent:(NSAppleEventDescriptor *) replyEvent;
@end
