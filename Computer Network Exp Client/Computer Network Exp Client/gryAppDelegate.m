//
//  gryAppDelegate.m
//  Computer Network Exp Client
//
//  Created by Gong Ruya on 6/8/14.
//  Copyright (c) 2014 Gong Ruya. All rights reserved.
//

#import "gryAppDelegate.h"

@implementation gryAppDelegate
@synthesize mytext;
@synthesize host;
@synthesize port;
@synthesize nickname;
@synthesize socket;
@synthesize msg;
@synthesize connect_btn;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    host.stringValue = @"127.0.0.1";
    port.stringValue = @"43250";
    nickname.stringValue = [self createNickName];
}

- (NSString*) createNickName
{
    int numberLen = 8;
    char *dic = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890";
    char data[numberLen];
    for (int i = 0; i < numberLen; ++i)
        data[i] = dic[arc4random_uniform(62)];
    return [[NSString alloc] initWithBytes:data length:numberLen encoding:NSUTF8StringEncoding];
}
- (void)addtext:(NSString *)str
{
    str = [NSString stringWithFormat: @"%@<br />--------------------------<br />", str];
    NSData *htmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *formattedHTML = [[NSAttributedString alloc] initWithHTML:htmlData documentAttributes: NULL];
    [[mytext textStorage] appendAttributedString: formattedHTML];
    [formattedHTML release];
    NSLog(@"%@", str);
}

- (IBAction)send:(id)sender {
    NSString *msg_to_send = [NSString stringWithFormat:@"<span style=\"font-size:14px\"><b>%@</b></span> says:<br /><span style=\"font-size:18px\">%@</span>", nickname.stringValue, msg.stringValue];
    [socket writeData:[msg_to_send dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];

    [msg resignFirstResponder];
    [socket readDataWithTimeout:-1 tag:0];
}

- (IBAction)connect:(id)sender {
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![socket connectToHost: host.stringValue onPort:[port integerValue] error:&err]) {
        [self addtext:err.description];
    } else {
        [self addtext: [NSString stringWithFormat: @"You have connected to the server [%@]:%@ successfully.", host.stringValue, port.stringValue]];
        [socket readDataWithTimeout:-1 tag:0];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self addtext:[NSString stringWithFormat:@"%@", newMessage]];
    [socket readDataWithTimeout:-1 tag:0];
}
@end
