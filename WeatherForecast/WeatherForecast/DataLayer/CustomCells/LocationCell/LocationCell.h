//
//  LocationCell.h
//  WeatherForecast
//
//  Created by rost on 15.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

typedef NS_ENUM(NSInteger, LocationCellLabelTypes) {
    TypeTitle,
    TypeSubTitle,
    TypeTemperature
};

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

- (void)setTitle:(NSString *)titleString;
- (void)setSubTitle:(NSString *)subTitleString;
- (void)setTemperature:(NSString *)temperatureString;
- (void)setImgView:(NSString *)urlString;

@end
