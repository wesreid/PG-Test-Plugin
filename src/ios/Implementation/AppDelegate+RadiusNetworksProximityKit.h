//
// Created by Wes Reid on 5/23/14.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ProximityKit/ProximityKit.h"

@interface AppDelegate (RadiusNetworksProximityKit) <PKManagerDelegate>

- (id) getCommandInstance:(NSString*)className;
- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region;
- (void)proximityKit:(PKManager *)manager didFailWithError:(NSError *)error;

@end