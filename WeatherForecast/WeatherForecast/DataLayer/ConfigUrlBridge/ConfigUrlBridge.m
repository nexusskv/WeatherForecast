//
//  ConfigUrlBridge.m
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "ConfigUrlBridge.h"

@implementation ConfigUrlBridge

#pragma mark - URL configurator
+ (NSString *)configURL:(NSDictionary *)conditions {
    
    NSString *resultUrlString = nil;

    switch ([conditions[@"type"] intValue]) {
        case Today: {
            resultUrlString = [NSString stringWithFormat:@"%@&key=%@%@%@%@",
                         kApiURL,
                         kApiKey,
                         kTodayDateParam,
                         kLocationParam,
                         conditions[@"location"]];
        }
            break;
            
        case Week: {
            resultUrlString = [NSString stringWithFormat:@"%@&key=%@%@%@%@",
                               kApiURL,
                               kApiKey,
                               kLocationParam,
                               conditions[@"location"],
                               kWeekParam];
        }
            break;
            
        case ListLocations: {
            resultUrlString = [NSString stringWithFormat:@"%@&key=%@%@%@",
                               kGeoURL,
                               kApiKey,
                               kLocationParam,
                               conditions[@"location"]];
        }
            break;
            
        default:
            break;
    }
    
    resultUrlString = [resultUrlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    resultUrlString = [resultUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return resultUrlString;
}
#pragma mark -

@end
