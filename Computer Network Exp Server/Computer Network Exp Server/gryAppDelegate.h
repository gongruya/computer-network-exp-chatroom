//
//  gryAppDelegate.h
//  Computer Network Exp Server
//
//  Created by Gong Ruya on 6/8/14.
//  Copyright (c) 2014 Gong Ruya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"
int cli_num = 0;
@interface gryAppDelegate : NSObject <NSApplicationDelegate,
    GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    GCDAsyncSocket *s[256];
}
@property(strong)  GCDAsyncSocket *socket;

@property (strong) IBOutlet NSTextField *port;
@property (strong) IBOutlet NSButton *start_listening_btn;
- (IBAction)start_listening:(id)sender;
@property (strong) IBOutlet NSTextField *msg;
- (IBAction)sendmsg:(id)sender;
@property (strong) IBOutlet NSButton *sendmsg_btn;
@property (unsafe_unretained) IBOutlet NSTextView *mytext;


@property (assign) IBOutlet NSWindow *window;

@end
