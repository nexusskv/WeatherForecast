//
//  WeatherTabbarController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "WeatherTabbarController.h"
#import "TodayViewController.h"
#import "ForecastViewController.h"
#import "SettingsViewController.h"
#import "LocationsViewController.h"



@interface WeatherTabbarController ()

@end


@implementation WeatherTabbarController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    TodayViewController *todayVC = [[TodayViewController alloc] initWithLocation:self.dataDictionary];
    ForecastViewController *forecastVC = [[ForecastViewController alloc] init];
    forecastVC.titleString = self.dataDictionary[@"city"];
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    
    self.viewControllers = @[todayVC, forecastVC, settingsVC];
    self.selectedIndex = 1;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
