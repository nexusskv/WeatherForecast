//
//  LocationsViewController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"
#import "AddLocationViewController.h"
#import "ApiConnector.h"

#import "AFHTTPRequestOperation.h"
#import "AFURLConnectionOperation.h"
#import "ConfigUrlBridge.h"



@interface LocationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *locationTable;
@property (strong, nonatomic) NSArray *locationsArray;
@property (strong) NSArray *weatherArray;
@end


@implementation LocationsViewController

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

    self.title = @"Location";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonSelector)];
    
    UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, 5.0f)];
    separatorImage.image = [UIImage imageNamed:@"LocationLine"];
    
    self.locationTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, VIEW_WIDTH, VIEW_HEIGHT - 70.0f) style:UITableViewStylePlain];
    self.locationTable.delegate       = self;
    self.locationTable.dataSource     = self;
    self.locationTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.locationTable.backgroundColor   = [UIColor clearColor];

    [self.view addSubview:separatorImage];
    [self.view addSubview:self.locationTable];
    
    UIButton *addLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addLocationButton.frame = CGRectMake((VIEW_WIDTH / 2.0f) - 35.0f, VIEW_HEIGHT - 85.0f, 70.0f, 70.0f);
    [addLocationButton setImage:[UIImage imageNamed:@"Button"] forState:UIControlStateNormal];
    [addLocationButton addTarget:self action:@selector(addLocationButtonSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addLocationButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    self.locationsArray = [[NSUserDefaults standardUserDefaults] arrayForKey:kLocations];

    if ([self.locationsArray count] > 0) {
        ApiConnector *connector = [[ApiConnector alloc] initWithCallback:^(id resultObject) {
            if ((resultObject) && ([resultObject isKindOfClass:[NSArray class]]))
                if ([(NSArray *)resultObject count] > 0) {
                    self.weatherArray = (NSArray *)resultObject;
                    [self.locationTable reloadData];
                }
        }];
        
        [connector getWeatherByConditions:nil orLocations:self.locationsArray];
    }
}
#pragma mark -


#pragma mark - Buttons selectors
- (void)doneButtonSelector {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addLocationButtonSelector {
    AddLocationViewController *addLocationVC = [[AddLocationViewController alloc] init];
    [self.navigationController pushViewController:addLocationVC animated:YES];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weatherArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *currentLocCellId = @"currentLocationCell";
    static NSString *locationCellId = @"locationCell";
    
    LocationCell *cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCellId];
    
    if (indexPath.row == 0)
        cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currentLocCellId];

    NSString *urlString = [[[[self.weatherArray objectAtIndex:indexPath.row] valueForKey:@"weatherIconUrl"] objectAtIndex:0] valueForKey:@"value"];

    if (urlString)
        [cell setImgView:urlString];
    
    [cell setTitle:[self.locationsArray objectAtIndex:indexPath.row]];
    [cell setSubTitle:[[[[self.weatherArray objectAtIndex:indexPath.row] valueForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"]];
    [cell setTemperature:[[self.weatherArray objectAtIndex:indexPath.row] valueForKey:@"tempMaxC"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *weatherMutArr = [NSMutableArray arrayWithArray:self.weatherArray];
		[weatherMutArr removeObjectAtIndex:indexPath.row];
        self.weatherArray = weatherMutArr;
        
        NSMutableArray *locationsMutArr = [NSMutableArray arrayWithArray:self.locationsArray];
		[locationsMutArr removeObjectAtIndex:indexPath.row];
        self.locationsArray = locationsMutArr;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.locationsArray forKey:kLocations];
        [defaults synchronize];
        
		[tableView beginUpdates];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[tableView endUpdates];
		[tableView reloadData];
    }
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
