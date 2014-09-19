//
//  BaseViewController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationsViewController.h"


@interface BaseViewController ()

@end


@implementation BaseViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, 5.0f)];
    separatorImage.image = [UIImage imageNamed:@"LocationLine"];
    [self.view addSubview:separatorImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton addTarget:self action:@selector(leftBarButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    [barButton setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    barButton.frame = CGRectMake(VIEW_WIDTH - 30.0f, 10.0f, 20.0f, 20.0f);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
}
#pragma mark -


#pragma mark - UI factory methods
- (UILabel *)todayLabel:(UILabel *)label withRect:(CGRect)rect {
    label = [[UILabel alloc] initWithFrame:rect];
    label.font = [UIFont fontWithName:@"Helevtica" size:7.0f];
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)addRightBarButton {
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton addTarget:self action:@selector(leftBarButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    [barButton setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    barButton.frame = CGRectMake(VIEW_WIDTH - 30.0f, 10.0f, 20.0f, 20.0f);
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
}
#pragma mark - 


#pragma mark - Button action selector
- (void)leftBarButtonSelector {
    LocationsViewController *locationsVC = [[LocationsViewController alloc] init];
    [self.navigationController pushViewController:locationsVC animated:YES];
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
