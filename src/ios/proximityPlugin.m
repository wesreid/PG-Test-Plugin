//
// Created by Wes Reid on 5/22/14.
//

#import "proximityPlugin.h"


@implementation proximityPlugin

@synthesize callbackId;

- (void)saySomething:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;

    NSMutableDictionary* options = [command.arguments objectAtIndex:0];
    NSMutableString *msg = [options valueForKey:@"msg"];
    [msg insertString:@"Yo, " atIndex:0];

    UIAlertView *uiAlertView = [[UIAlertView alloc] initWithTitle:@"Big Alert" message:msg delegate:nil cancelButtonTitle:@"Yep" otherButtonTitles:nil];

    [uiAlertView show];
    [self successWithMessage:[NSString stringWithFormat:@"all goodie: %@", msg]];
}


-(void)successWithMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];

    [self.commandDelegate sendPluginResult:commandResult callbackId:self.callbackId];
}

-(void)failWithMessage:(NSString *)message withError:(NSError *)error
{
    NSString        *errorMessage = (error) ? [NSString stringWithFormat:@"%@ - %@", message, [error localizedDescription]] : message;
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];

    [self.commandDelegate sendPluginResult:commandResult callbackId:self.callbackId];
}

@end