//
//  TodayViewController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "TodayViewController.h"
#import "ApiConnector.h"
#import "UIImageView+AFNetworking.h"


@interface TodayViewController ()
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *countryString;
@property (strong, nonatomic) UIImageView *weatherImage;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *weatherLabel;
@property (strong, nonatomic) UILabel *percentLabel;
@property (strong, nonatomic) UILabel *mmLabel;
@property (strong, nonatomic) UILabel *celsLabel;
@property (strong, nonatomic) UILabel *windLabel;
@property (strong, nonatomic) UILabel *compassLabel;
@end


@implementation TodayViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {
        [self addTabBarItem];
    }
    return self;
}
#pragma mark -


#pragma mark - Custom constructor
- (id)initWithLocation:(NSDictionary *)location {
    self = [super init];
    if (self) {
        [self addTabBarItem];
        
        self.cityString = location[@"city"];
        self.countryString = location[@"country"];
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weatherImage = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH / 2.0f) - 40.0f, 84.0f, 90.0f, 90.0f)];
    self.weatherImage.layer.cornerRadius = 35.0f;
    self.weatherImage.layer.masksToBounds = YES;
    [self.view addSubview:self.weatherImage];
    
    UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 200.0f, 15.0f, 15.0f)];
    currentImage.image = [UIImage imageNamed:@"Current"];
    [self.view addSubview:currentImage];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 196.0f, VIEW_WIDTH, 20.0f)];
    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", self.cityString, self.countryString];
    self.locationLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.locationLabel];
    
    self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 220.0f, VIEW_WIDTH, 30.0f)];
    self.weatherLabel.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
    self.weatherLabel.textColor = BLUE_COLOR;
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.weatherLabel];
    
    UIImageView *topSeparatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH / 2.0f - 50.0f, 270.0f, 100.0f, 1.0f)];
    topSeparatorImage.image = [UIImage imageNamed:@"Divider"];
    [self.view addSubview:topSeparatorImage];
    
    float yImage = 300.0f;
    
    UIImageView *percentImage = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, yImage, 20.0f, 20.0f)];
    percentImage.image = [UIImage imageNamed:@"CR"];
    [self.view addSubview:percentImage];
    
    UIImageView *mmImage = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH / 2.0f) - 10.0f, yImage, 20.0f, 20.0f)];
    mmImage.image = [UIImage imageNamed:@"Rain"];
    [self.view addSubview:mmImage];
    
    UIImageView *celsImage = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH - 62.0f, yImage, 22.0f, 17.0f)];
    celsImage.image = [UIImage imageNamed:@"Celcius"];
    [self.view addSubview:celsImage];
    
    UIImageView *windImage = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH / 2.0f) - 70.0f, 360.0f, 25.0f, 20.0f)];
    windImage.image = [UIImage imageNamed:@"Wind"];
    [self.view addSubview:windImage];
    
    UIImageView *compasImage = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH / 2.0f) + 45.0f, 360.0f, 20.0f, 20.0f)];
    compasImage.image = [UIImage imageNamed:@"Compass"];
    [self.view addSubview:compasImage];
    
    UIImageView *bottomSeparatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH / 2.0f - 50.0f, 440.0f, 100.0f, 1.0f)];
    bottomSeparatorImage.image = [UIImage imageNamed:@"Divider"];
    [self.view addSubview:bottomSeparatorImage];
    
    float yLabel = yImage + 25.0f;
    
    self.percentLabel = [self todayLabel:self.percentLabel withRect:CGRectMake(35.0f, yLabel, 40.0f, 15.0f)];
    [self.view addSubview:self.percentLabel];
    
    self.mmLabel = [self todayLabel:self.mmLabel withRect:CGRectMake((VIEW_WIDTH / 2.0f) - 30.0f, yLabel, 60.0f, 15.0f)];
    [self.view addSubview:self.mmLabel];
    
    self.celsLabel = [self todayLabel:self.celsLabel withRect:CGRectMake(VIEW_WIDTH - 83.0f, yLabel, 75.0f, 15.0f)];
    [self.view addSubview:self.celsLabel];
    
    self.windLabel = [self todayLabel:self.windLabel withRect:CGRectMake((VIEW_WIDTH / 2.0f) - 85.0f, 385.0f, 70.0f, 15.0f)];
    [self.view addSubview:self.windLabel];
    
    self.compassLabel = [self todayLabel:self.compassLabel withRect:CGRectMake((VIEW_WIDTH / 2.0f) + 30.0f, 385.0f, 50.0f, 20.0f)];
    self.compassLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.compassLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0f, 450.0f, VIEW_WIDTH, 40.0f);
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton setTitle:@"Share" forState:UIControlStateHighlighted];
    [shareButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:136.0f/255.0f blue:71.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.topItem.title = @"Today";
    
    [self addRightBarButton];
    
    ApiConnector *connector = [[ApiConnector alloc] initWithCallback:^(id resultObject) {

        if ((resultObject) && ([resultObject isKindOfClass:[NSDictionary class]]))
            if ([[(NSDictionary *)resultObject allValues] count] > 0) {
                NSDictionary *weatherDictionary = [[(NSDictionary *)resultObject valueForKeyPath:@"data.current_condition"] objectAtIndex:0];
                
                NSString *urlString = [[[weatherDictionary valueForKey:@"weatherIconUrl"] objectAtIndex:0] valueForKey:@"value"];
                
                if (urlString) {
                    __weak UIImageView *weakImage = self.weatherImage;
                    [self.weatherImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                             placeholderImage:nil
                                                      success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                                          weakImage.image = image;
                                                      }
                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                                          NSLog(@"failed loading: %@", error);
                                                      }
                     ];
                    self.weatherImage.alpha = 0.3f;
                }
                
                NSString *weatherString = [[[weatherDictionary valueForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"];
                if ((weatherString) && (weatherDictionary[@"temp_C"]))
                    self.weatherLabel.text = [NSString stringWithFormat:@"%@C | %@", weatherDictionary[@"temp_C"], weatherString];
                
                if (weatherDictionary[@"humidity"]) {
                    self.percentLabel.text = [NSString stringWithFormat:@"%@%%", weatherDictionary[@"humidity"]];
                }
                
                if (weatherDictionary[@"precipMM"]) {
                    self.mmLabel.text = [NSString stringWithFormat:@"%@ mm", weatherDictionary[@"precipMM"]];
                }
                
                if (weatherDictionary[@"pressure"]) {
                    self.celsLabel.text = [NSString stringWithFormat:@"%@ hPa", weatherDictionary[@"pressure"]];
                }
                
                if (weatherDictionary[@"windspeedKmph"]) {
                    self.windLabel.text = [NSString stringWithFormat:@"%@ km/h", weatherDictionary[@"windspeedKmph"]];
                }
                
                if (weatherDictionary[@"winddir16Point"]) {
                    self.compassLabel.text = [NSString stringWithFormat:@"%@", weatherDictionary[@"winddir16Point"]];
                }
            }
    }];
    
    [connector getWeatherByConditions:@{@"type" : @(Today), @"location" : self.cityString} orLocations:nil];
}
#pragma mark -


#pragma mark - Constructor helper
- (void)addTabBarItem {
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today"
                                                    image:[UIImage imageNamed:@"Today"]
                                            selectedImage:nil];
}
#pragma mark -


#pragma mark - Button selector
- (void)shareButtonSelector {
	UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.locationLabel.text, self.weatherLabel.text, self.percentLabel.text, self.mmLabel.text, self.celsLabel.text, self.windLabel.text, self.compassLabel.text]
                                                                             applicationActivities:nil];
    activityVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter];
	
	[self presentViewController:activityVC animated:YES completion:nil];
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
