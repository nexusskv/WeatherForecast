//
//  SettingsCell.h
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

typedef NS_ENUM(NSInteger, SettingsCellLabelTypes) {
    TypeTitle,
    TypeValue,
};

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell

- (void)setTitle:(NSString *)titleString;
- (void)setValue:(NSString *)valueString;

@end
