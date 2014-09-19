//
//  BaseViewController.h
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (UILabel *)todayLabel:(UILabel *)label withRect:(CGRect)rect;

- (void)addRightBarButton;
- (void)leftBarButtonSelector;

@end
