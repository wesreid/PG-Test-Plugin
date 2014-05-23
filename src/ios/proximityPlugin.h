//
// Created by Wes Reid on 5/22/14.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

@interface proximityPlugin : CDVPlugin
{}

@property (nonatomic, weak) NSString *callbackId;

- (void)saySomething:(CDVInvokedUrlCommand *)command;

@end