//
//  gryAppDelegate.h
//  Computer Network Exp Client
//
//  Created by Gong Ruya on 6/8/14.
//  Copyright (c) 2014 Gong Ruya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"

@interface gryAppDelegate : NSObject <NSApplicationDelegate, GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
}
@property(strong)  GCDAsyncSocket *socket;

@property (assign) IBOutlet NSTextView *mytext;
@property (assign) IBOutlet NSTextField *nickname;
@property (assign) IBOutlet NSTextField *host;
@property (assign) IBOutlet NSTextField *port;
@property (assign) IBOutlet NSTextField *msg;
- (IBAction)send:(id)sender;
- (IBAction)connect:(id)sender;
@property (assign) IBOutlet NSButton *connect_btn;

@property (assign) IBOutlet NSWindow *window;

@end
