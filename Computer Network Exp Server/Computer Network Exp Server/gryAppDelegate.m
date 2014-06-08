//
//  gryAppDelegate.m
//  Computer Network Exp Server
//
//  Created by Gong Ruya on 6/8/14.
//  Copyright (c) 2014 Gong Ruya. All rights reserved.
//

#import "gryAppDelegate.h"

@implementation gryAppDelegate

@synthesize mytext;
@synthesize port;
@synthesize start_listening_btn;
@synthesize socket;
@synthesize msg;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    port.stringValue = @"43250";
}
-(void)addtext:(NSString *)str
{
    str = [NSString stringWithFormat: @"%@<br />--------------------------<br />", str];
    NSData *htmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *formattedHTML = [[NSAttributedString alloc] initWithHTML:htmlData documentAttributes: NULL];
    [[mytext textStorage] appendAttributedString: formattedHTML];

    NSLog(@"%@", str);
}
- (IBAction)start_listening:(id)sender {
    NSLog(@"listen");
    
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if(![socket acceptOnPort:[port integerValue] error:&err]) {
        [self addtext:err.description];
    } else {
        [self addtext:[NSString stringWithFormat:@"Starting listening at port %d.", port.integerValue]];
        [start_listening_btn setTitle: @"Socket Server Enabled"];
        [start_listening_btn setEnabled: NO];
    }
}
- (void)socket:(GCDAsyncSocket *)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // The "sender" parameter is the listenSocket we created.
    // The "newSocket" is a new instance of GCDAsyncSocket.
    // It represents the accepted incoming client connection.
    
    // Do server stuff with newSocket...
    [self addtext:[NSString stringWithFormat:@"Established connection with %@",newSocket.connectedHost]];
    
    s[cli_num] = newSocket;
    s[cli_num].delegate = self;
    [s[cli_num++] readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *receive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addtext:[NSString stringWithFormat:@"%@:%@",sock.connectedHost, receive]];
    
    NSLog(@"%d", cli_num);
    for (int i = 0; i < cli_num; ++i) {
        [s[i] writeData:[receive dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        [s[i] readDataWithTimeout:-1 tag:0];
    }
}

- (IBAction)sendmsg:(id)sender {
    NSString *msg_to_send = [NSString stringWithFormat:@"<span style=\"font-size:14px\"><b>Server</b></span> says:<br /><span style=\"font-size:18px\">%@</span>", msg.stringValue];
    for (int i = 0; i < cli_num; ++i)
        [s[i] writeData:[msg_to_send dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
@end
