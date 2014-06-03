//
// Created by Wes Reid on 5/22/14.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>
#import "ProximityKit/ProximityKit.h"

@interface proximityPlugin : CDVPlugin
{}

@property (nonatomic, weak) NSString *callbackId;
@property (nonatomic, weak) NSString *callback;

+ (NSString*) cbDidEnterRegion;
+ (void) setCbDidEnterRegion:(NSString *)value;

+ (NSString*) cbDidExitRegion;
+ (void) setCbDidExitRegion:(NSString *)value;

+ (NSString*) cbDidDetermineStateForRegion;
+ (void) setCbDidDetermineStateForRegion:(NSString *)value;

+ (NSString*) cbDidRangeBeaconsInRegion;
+ (void) setCbDidRangeBeaconsInRegion:(NSString *)value;

+ (NSString*) cbDidFailWithError;
+ (void) setCbDidFailWithError:(NSString *)value;


- (void)initCallbacks:(CDVInvokedUrlCommand *)command;

- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didFailWithError:(NSError *)error;

@end