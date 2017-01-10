//
//  AppDelegate.m
//  MessageForwardingDemo
//
//  Created by yuedongkui on 2017/1/9.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTestObject.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    MyTestObject *obj = [[MyTestObject alloc] init];
    [obj resolveThisMethodDynamically];
}


@end
