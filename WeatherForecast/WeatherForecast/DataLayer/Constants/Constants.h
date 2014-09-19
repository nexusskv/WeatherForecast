//
//  Constants.h
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#ifndef WeatherForecast_Constants_h
#define WeatherForecast_Constants_h

typedef NS_ENUM(NSInteger, RequestTypeConditions) {
    Today,
    Week,
    ListLocations
};


#define BLUE_COLOR  [UIColor colorWithRed:47.0f/255.0f green:145.0f/255.0f blue:255.0f/255.0f alpha:1.0f];

#define VIEW_WIDTH      self.view.bounds.size.width
#define VIEW_HEIGHT     self.view.bounds.size.height

extern NSString *const kApiKey;

extern NSString *const kApiURL;
extern NSString *const kLocationParam;
extern NSString *const kDateParam;
extern NSString *const kTodayDateParam;
extern NSString *const kDayParam;
extern NSString *const kWeekParam;

extern NSString *const kGeoURL;

extern NSString *const kLocations;


#endif

@interface Constants : NSObject

+ (Constants *)shared;
- (NSString *)setDayFromDate:(NSDate *)date;

@end