//
//  AppDelegate.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "WeatherTabbarController.h"


@interface AppDelegate () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end


@implementation AppDelegate

#pragma mark - App life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

    return YES;
}

#pragma mark - CoreLocation delegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation) {
        CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                              longitude:newLocation.coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:tempLocation completionHandler:
         ^(NSArray* placemarks, NSError* error){
             if ([placemarks count] > 0)
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 
                 [self.locationManager stopUpdatingLocation];
                 
                 WeatherTabbarController *tabBar = [[WeatherTabbarController alloc] init];
                 
                 NSMutableDictionary *dataMutDic = [NSMutableDictionary dictionary];
                 if (newLocation.coordinate.latitude)
                     dataMutDic[@"latitude"] = @(newLocation.coordinate.latitude);
                 
                 if (newLocation.coordinate.latitude)
                     dataMutDic[@"longitude"] = @(newLocation.coordinate.longitude);
                 
                 if (placemark.addressDictionary[@"City"])
                     dataMutDic[@"city"] = placemark.addressDictionary[@"City"];
                 
                 if (placemark.addressDictionary[@"Country"])
                     dataMutDic[@"country"] = placemark.addressDictionary[@"Country"];
                 
                 tabBar.dataDictionary  = dataMutDic;

                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 NSArray *locationsArray = [defaults arrayForKey:kLocations];
                 
                 BOOL cityExistFlag = NO;
                 if ([locationsArray count] > 0) {
                     
                     for (NSString *city in locationsArray) {
                         if ([[placemark.addressDictionary valueForKey:@"City"] isEqualToString:city])
                             cityExistFlag = YES;
                     }
                 }
                 
                 if (!cityExistFlag) {
                     if (placemark.addressDictionary[@"City"]) {
                         NSMutableArray *locationMutArray = [NSMutableArray arrayWithArray:locationsArray];
                         [locationMutArray insertObject:[placemark.addressDictionary valueForKey:@"City"] atIndex:0];
                         [defaults setObject:locationMutArray forKey:kLocations];
                         [defaults synchronize];
                         
                         [self loadTabbar:tabBar];
                     }
                     else {
                         [self showMessage:@"Please restart application & \n set other location in simulator."
                                 withTitle:@"Error!"];
                     }
                 }
                 else
                     [self loadTabbar:tabBar];
             }
         }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);

    [self showMessage:@"Please enable current location \n in settings on your simulator or device."
            withTitle:@"Current location error!"];
}
#pragma mark -


#pragma mark - TabBar load selector
- (void)loadTabbar:(WeatherTabbarController *)tabBar {
    self.navController = [[UINavigationController alloc] initWithRootViewController:tabBar];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
}
#pragma mark -


#pragma mark - Show Alert helper
- (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark -

@end
