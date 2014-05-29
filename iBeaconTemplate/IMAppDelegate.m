//
//  IMAppDelegate.m
//  iBeaconTemplate
//
//  Created by James Nick Sears on 5/29/14.
//  Copyright (c) 2014 iBeaconModules.us. All rights reserved.
//

#import "IMAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation IMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:@"8DEEFBB9-F738-4297-8040-96668BB44281"];
    NSString *regionIdentifier = @"us.iBeaconModules";
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:regionIdentifier];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    [self.locationManager startUpdatingLocation];
    
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"You entered the region.");
    [self sendLocalNotificationWithMessage:@"You entered the region."];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"You exited the region.");
    [self sendLocalNotificationWithMessage:@"You exited the region."];
}

-(void)sendLocalNotificationWithMessage:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        if(nearestBeacon.proximity == self.lastProximity) {
            return;
        }
        self.lastProximity = nearestBeacon.proximity;
        
        switch(nearestBeacon.proximity) {
            case CLProximityFar:
                NSLog(@"You are far away from the beacon");
                [self sendLocalNotificationWithMessage:@"You are far away from the beacon"];
                break;
            case CLProximityNear:
                NSLog(@"You are near the beacon");
                [self sendLocalNotificationWithMessage:@"You are near the beacon"];
                break;
            case CLProximityImmediate:
                NSLog(@"You are in the immediate proximity of the beacon");
                [self sendLocalNotificationWithMessage:@"You are in the immediate proximity of the beacon"];
                break;
            case CLProximityUnknown:
                NSLog(@"Where did the beacon go?");
                [self sendLocalNotificationWithMessage:@"Where did the beacon go?"];
                break;
        }
    } else {
        NSLog(@"No beacons are nearby");
        [self sendLocalNotificationWithMessage:@"No beacons are nearby"];
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
