//
// Created by Wes Reid on 5/22/14.
//

#import <Cordova/CDVShared.h>
#import "proximityPlugin.h"


@implementation proximityPlugin

@synthesize callbackId;
@synthesize callback;

static NSString *cbDidEnterRegion = @"";
static NSString *cbDidDetermineStateForRegion = @"";
static NSString *cbDidExitRegion = @"";
static NSString *cbDidFailWithError = @"";
static NSString *cbDidRangeBeaconsInRegion = @"";

+ (NSString*) cbDidEnterRegion { return cbDidEnterRegion; }
+ (void) setCbDidEnterRegion:(NSString *)value { cbDidEnterRegion = value; }

+ (NSString*) cbDidExitRegion { return cbDidExitRegion; }
+ (void) setCbDidExitRegion:(NSString *)value { cbDidExitRegion = value; }

+ (NSString*) cbDidDetermineStateForRegion { return cbDidDetermineStateForRegion; }
+ (void) setCbDidDetermineStateForRegion:(NSString *)value { cbDidDetermineStateForRegion = value; }

+ (NSString*) cbDidRangeBeaconsInRegion { return cbDidRangeBeaconsInRegion; }
+ (void) setCbDidRangeBeaconsInRegion:(NSString *)value { cbDidRangeBeaconsInRegion = value; }

+ (NSString*) cbDidFailWithError { return cbDidFailWithError; }
+ (void) setCbDidFailWithError:(NSString *)value { cbDidFailWithError = value; }


- (void)initCallbacks:(CDVInvokedUrlCommand *)command {
    NSMutableDictionary* options = [command.arguments objectAtIndex:0];
    [proximityPlugin setCbDidEnterRegion:[options objectForKey:@"cbDidEnterRegion"]];
    [proximityPlugin setCbDidDetermineStateForRegion:[options objectForKey:@"cbDidDetermineStateForRegion"]];
    [proximityPlugin setCbDidExitRegion:[options objectForKey:@"cbDidExitRegion"]];
    [proximityPlugin setCbDidFailWithError:[options objectForKey:@"cbDidFailWithError"]];
    [proximityPlugin setCbDidRangeBeaconsInRegion:[options objectForKey:@"cbDidRangeBeaconsInRegion"]];
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

-(NSString *)getRegionJSON:(PKRegion *)region {
    // create json representation of region
    return [NSString stringWithFormat:@"{ \"name\":\"%@\", \"identifier\":\"%@\", \"attributes\": [%@] }"
            , region.name
            , region.identifier
            , [self getJsonString:region.attributes]
    ];
}

-(NSString *)getBeaconJSON:(PKIBeacon *)beacon {
    NSMutableString *jsonStr = [NSMutableString
            stringWithString:[NSString stringWithFormat:@"{ \"name\":\"%@\", \"identifier\":\"%@\", \"attributes\": [%@], \"uuid\":\"%@\", \"major\":\"%d\", \"minor\":\"%d\", \"accuracy\":\"%@\", \"proximity\":\"%@\", \"rssi\":\"%d\"}"
                    , beacon.name
                    , beacon.identifier
                    , [self getJsonString:beacon.attributes]
                    , beacon.uuid.UUIDString
                    , beacon.major
                    , beacon.minor
                    , [self getAccuracyValueString:beacon.accuracy]
                    , [self getProximityValueString:beacon.proximity]
                    , beacon.rssi
            ]
    ];
    return jsonStr;
}

-(NSString *)getAccuracyValueString:(CLLocationAccuracy)accuracy {
    if (accuracy == kCLLocationAccuracyBest)
        return @"Best";
    else if (accuracy == kCLLocationAccuracyBestForNavigation)
        return @"BestForNavigation";
    else if (accuracy == kCLLocationAccuracyHundredMeters)
        return @"HundredMeters";
    else if (accuracy == kCLLocationAccuracyKilometer)
        return @"Kilometer";
    else if (accuracy == kCLLocationAccuracyNearestTenMeters)
        return @"TenMeters";
    else if (accuracy == kCLLocationAccuracyThreeKilometers)
        return @"ThreeKilometers";
    else
        return @"Unknown";
}

-(NSString *)getProximityValueString:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityNear:
            return @"Near";
        case CLProximityImmediate:
            return @"Immediate";
        case CLProximityFar:
            return @"Far";
        default:
            return @"Unknown";
    }
}

-(void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region {
    NSLog(@"Entered region");

    if ([proximityPlugin cbDidEnterRegion])
    {
        NSMutableString *jsonStr = [self getRegionJSON:region];
        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", [proximityPlugin cbDidEnterRegion], jsonStr];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }
}

-(void)proximityKit:(PKManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(PKRegion *)region {
    NSLog(@"Entered region");

    if ([proximityPlugin cbDidRangeBeaconsInRegion])
    {
        NSMutableString *regionJsonStr = [self getRegionJSON:region];
        NSMutableString *beaconsJsonStr = [[NSMutableString alloc] initWithString:@""];
        //for (PKIBeacon *beacon in beacons) {
        for (NSInteger i =0; i<beacons.count; i++) {
            PKIBeacon *beacon = beacons[i];
            NSString *beaconJson = [self getBeaconJSON:beacon];
            [beaconsJsonStr appendString:beaconJson];
            if (i < (beacons.count-1))
                [beaconsJsonStr appendString:@","];
        }
        NSMutableString *jsonStr = [NSMutableString
                stringWithString:[NSString stringWithFormat:@"{ \"region\": %@, \"beacons\": [%@] }", regionJsonStr, beaconsJsonStr]
        ];

        // log serialized json
        NSLog(@"Msg: %@", jsonStr);

        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", [proximityPlugin cbDidRangeBeaconsInRegion], jsonStr];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }
}

-(void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region {
    NSLog(@"Entered region");

    if ([proximityPlugin cbDidDetermineStateForRegion])
    {
        NSMutableString *regionJson = [self getRegionJSON:region];
        NSMutableString *jsonStr = [NSString stringWithFormat:@"{region: %@}", regionJson];
        // log serialized json
        NSLog(@"Msg: %@", jsonStr);

        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", [proximityPlugin cbDidDetermineStateForRegion], jsonStr];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }
}

-(void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region {
    NSLog(@"Entered region");

    if ([proximityPlugin cbDidExitRegion])
    {
        NSMutableString *jsonStr = [self getRegionJSON:region];
        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", [proximityPlugin cbDidExitRegion], jsonStr];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }
}

-(void)proximityKit:(PKManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Entered region");

    if ([proximityPlugin cbDidFailWithError])
    {
        NSString *jsCallBack = [NSString stringWithFormat:@"%@(%@);", [proximityPlugin cbDidFailWithError], [error JSONRepresentation]];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    }
}



// reentrant method to drill down and surface all sub-dictionaries' key/value pairs into the top level json
// legacy code - use getJsonString method instead
-(void)parseDictionary:(NSDictionary *)inDictionary intoJSON:(NSMutableString *)jsonString
{
    NSArray         *keys = [inDictionary allKeys];
    NSString        *key;

    for (key in keys)
    {
        id thisObject = [inDictionary objectForKey:key];

        if ([thisObject isKindOfClass:[NSDictionary class]])
            [self parseDictionary:thisObject intoJSON:jsonString];
        else if ([thisObject isKindOfClass:[NSString class]])
            [jsonString appendFormat:@"\"%@\":\"%@\",",
                                     key,
                                     [[[[inDictionary objectForKey:key]
                                             stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
                                             stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
                                             stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];
        else {
            [jsonString appendFormat:@"\"%@\":\"%@\",", key, [inDictionary objectForKey:key]];
        }
    }
}

-(NSString *)getJsonString:(NSObject *)obj {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil) {
        NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@", jsonString);
        return jsonString;
    }
    return @"";
}

@end