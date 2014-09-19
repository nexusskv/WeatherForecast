//
//  ForecastViewController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "ForecastViewController.h"
#import "LocationCell.h"
#import "ApiConnector.h"


@interface ForecastViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *resultsArray;
@property (strong, nonatomic) UITableView *forecastTable;
@end


@implementation ForecastViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Forecast"
                                                        image:[UIImage imageNamed:@"Forecast"]
                                                selectedImage:nil];
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.forecastTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, VIEW_WIDTH, VIEW_HEIGHT - 70.0f) style:UITableViewStylePlain];
    self.forecastTable.delegate       = self;
    self.forecastTable.dataSource     = self;
    self.forecastTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.forecastTable.backgroundColor   = [UIColor clearColor];
    [self.view addSubview:self.forecastTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.topItem.title = self.titleString;
    
    [self addRightBarButton];
    
    ApiConnector *connector = [[ApiConnector alloc] initWithCallback:^(id resultObject) {

        if ((resultObject) && ([resultObject isKindOfClass:[NSDictionary class]]))
            if ([[(NSDictionary *)resultObject allValues] count] > 0) {
                self.resultsArray = [(NSDictionary *)resultObject valueForKeyPath:@"data.weather"];
                if ([self.resultsArray count] > 0)
                    [self.forecastTable reloadData];
            }
        
    }];
    
    [connector getWeatherByConditions:@{@"type" : @(Week), @"location" : self.titleString} orLocations:nil];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = 0;
    
    if ([self.resultsArray count] > 0)
        rowsCount = [self.resultsArray count];
    
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *forecastCellId = @"forecastCell";
    
    LocationCell *cell = nil;
    
    if(cell == nil)
    {
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:forecastCellId];
        
        NSString *urlString = [[[[self.resultsArray objectAtIndex:indexPath.row] valueForKey:@"weatherIconUrl"] objectAtIndex:0] valueForKey:@"value"];
        if (urlString)
            [cell setImgView:urlString];
        
        NSString *resultString = [NSString stringWithFormat:@"%@ \n%@",
                                  [[Constants shared] setDayFromDate:[[self.resultsArray objectAtIndex:indexPath.row] valueForKey:@"date"]],
                                  [[self.resultsArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        [cell setTitle:resultString];
        [cell setSubTitle:[[[[self.resultsArray objectAtIndex:indexPath.row] valueForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"]];
        [cell setTemperature:[[self.resultsArray objectAtIndex:indexPath.row] valueForKey:@"tempMaxC"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
#pragma mark - 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
