//
//  Created by Joey Jarosz on 7/11/13.
//  Copyright (c) 2013 hot-n-GUI, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate () <CLLocationManagerDelegate>
    @property (nonatomic, strong) CLLocationManager *locationManager;
    @property (nonatomic, weak) ViewController *vc;
@end

//test from minimac 1


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //
    self.vc = (ViewController *)self.window.rootViewController;
    
    //
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    self.locationManager = lm;
    
    lm.delegate = self;
    lm.pausesLocationUpdatesAutomatically = NO;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;

    /*
     * Start normal updates and significant location changes. We use the normal update to 
     * get an accurate fix, then immediately stop it (in the delegate).
     */
    [lm startUpdatingLocation];
    [lm startMonitoringSignificantLocationChanges];
    
    NSLog(@"pausesLocationUpdatesAutomatically: %@", lm.pausesLocationUpdatesAutomatically ? @"YES" : @"NO");
    NSLog(@"desiredAccuracy: %f", lm.desiredAccuracy);
    NSLog(@"distanceFilter: %f", lm.distanceFilter);
    NSLog(@"activityType: %d", lm.activityType);
    
    //
    id backgroundLocation = launchOptions[UIApplicationLaunchOptionsLocationKey];
    NSLog(@"backgroundLocation: %@", backgroundLocation);
    
    //
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Will Resign Active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Did Enter Background");
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        __block UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^ {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        }];
        
        [self.locationManager startUpdatingLocation];
        
        if (bgTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Will Enter Foreground");
    [self.locationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Did Become Active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Will Terminate");
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Protocol

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        __block UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^ {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        }];
        
        [self recordLocations:locations forLocationManager:manager];
        
        if (bgTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }
    }
    else {
        [self recordLocations:locations forLocationManager:manager];
    }
}

//
// Add a pin to our map. Also stop normal updates (leaving signification location changes running).
//
- (void)recordLocations:(NSArray *)locations forLocationManager:(CLLocationManager *)manager
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Longitude: %f\tLatitude: %f", location.coordinate.longitude, location.coordinate.latitude);
    
    [self.vc addPin:location];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"didFinishDeferredUpdatesWithError: %@", error);
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Location Updates: Paused");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Location Updates: Resumed");
}


@end
