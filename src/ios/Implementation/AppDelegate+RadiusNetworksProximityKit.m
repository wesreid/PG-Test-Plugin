//
// Created by Wes Reid on 5/23/14.
//

#import "AppDelegate+RadiusNetworksProximityKit.h"
#import "proximityPlugin.h"
#import <objc/runtime.h>


@implementation AppDelegate (RadiusNetworksProximityKit)

PKManager *pkManager;
NSString *cmdInstanceName = @"proximityPlugin";


- (id) getCommandInstance:(NSString*)className
{
    return [self.viewController getCommandInstance:className];
}

// its dangerous to override a method from within a category.
// Instead we will use method swizzling. we set this up in the load call.
+ (void)load
{
    Method original, swizzled;

    original = class_getInstanceMethod(self, @selector(init));
    swizzled = class_getInstanceMethod(self, @selector(swizzled_init));
    method_exchangeImplementations(original, swizzled);
}

- (AppDelegate *)swizzled_init
{
    pkManager = [PKManager managerWithDelegate:self];
    [pkManager start];

    // This actually calls the original init method over in AppDelegate. Equivilent to calling super
    // on an overrided method, this is not recursive, although it appears that way. neat huh?
    return [self swizzled_init];
}

-(void)proximityKit:(PKManager *)manager didEnter:(PKRegion *)region {
    proximityPlugin *proximityPluginRef = [self getCommandInstance:cmdInstanceName];
    [proximityPluginRef proximityKit:manager didEnter:region];
}

- (void)proximityKit:(PKManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(PKRegion *)region{
    proximityPlugin *proximityPluginRef = [self getCommandInstance:cmdInstanceName];
    [proximityPluginRef proximityKit:manager didRangeBeacons:beacons inRegion:region];
}

- (void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region{
    proximityPlugin *proximityPluginRef = [self getCommandInstance:cmdInstanceName];
    [proximityPluginRef proximityKit:manager didDetermineState:state forRegion:region];
}

- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region{
    proximityPlugin *proximityPluginRef = [self getCommandInstance:cmdInstanceName];
    [proximityPluginRef proximityKit:manager didExit:region];
}

- (void)proximityKit:(PKManager *)manager didFailWithError:(NSError *)error{
    proximityPlugin *proximityPluginRef = [self getCommandInstance:cmdInstanceName];
    [proximityPluginRef proximityKit:manager didFailWithError:error];
}



@end