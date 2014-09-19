//
//  ConfigUrlBridge.h
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigUrlBridge : NSObject

+ (NSString *)configURL:(NSDictionary *)conditions;

@end
