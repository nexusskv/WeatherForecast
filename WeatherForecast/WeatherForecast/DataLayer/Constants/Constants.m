//
//  Constants.m
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//


#import "Constants.h"


NSString *const kApiKey = @"3e5b67312caa91498586ce576a94d67a4e891d20";

NSString *const kApiURL          = @"http://api.worldweatheronline.com/free/v1/weather.ashx?format=json";
NSString *const kLocationParam   = @"&q=";               // required
NSString *const kDateParam       = @"&date=";            // opt // format >>> today or tomorrow or 2013-04-21
NSString *const kTodayDateParam  = @"&date=today";       // opt // format >>> today or tomorrow or 2013-04-21
NSString *const kDayParam        = @"&num_of_days=1";    // required
NSString *const kWeekParam       = @"&num_of_days=5";    // required

NSString *const kGeoURL          = @"http://api.worldweatheronline.com/free/v1/search.ashx?format=json&num_of_results=100";

NSString *const kLocations       = @"LocationsKey";

@implementation Constants

#pragma mark - Class shared method
+ (Constants *)shared
{
    static Constants *shared = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
#pragma mark -


#pragma mark - Day from date formatter
- (NSString *)setDayFromDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"EEEE"];
    
    return [dateFormatter stringFromDate:date];
}
#pragma mark -

@end
