//
//  ApiConnector.h
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ApiConnectorCallback)(id);


@interface ApiConnector : NSObject

@property (nonatomic, copy) ApiConnectorCallback callbackBlock;

- (id)initWithCallback:(ApiConnectorCallback)block;
- (void)getWeatherByConditions:(NSDictionary *)conditions orLocations:(NSArray *)locations;

@end