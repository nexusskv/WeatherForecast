//
//  SettingsViewController.m
//  WeatherForecast
//
//  Created by rost on 14.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#define VIEW_WIDTH      self.view.bounds.size.width

#import "SettingsViewController.h"
#import "SettingsCell.h"


@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@end


@implementation SettingsViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings"
                                                        image:[UIImage imageNamed:@"Settings"]
                                                selectedImage:nil];
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, VIEW_WIDTH, VIEW_HEIGHT - 70.0f) style:UITableViewStylePlain];
    settingsTable.delegate       = self;
    settingsTable.dataSource     = self;
    settingsTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    settingsTable.backgroundColor   = [UIColor clearColor];    
    [self.view addSubview:settingsTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.topItem.title = @"Settings";    
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 50.0f)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, tableView.frame.size.width, 20.f)];
    headerLabel.textColor = BLUE_COLOR;
    headerLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    headerLabel.text = @"GENERAL";
    headerLabel.textAlignment = NSTextAlignmentLeft;

    [headerView addSubview:headerLabel];
    
    UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 49.0f, tableView.frame.size.width, 1.0f)];
    separatorImage.image = [UIImage imageNamed:@"divider-bottom"];
    [headerView addSubview:separatorImage];

    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingsCellId = @"settingsCell";
    tableView.separatorColor = [UIColor clearColor];
    
    SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:settingsCellId];
    
    if(cell == nil)
    {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingsCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
            [cell setTitle:@"Unit of length"];
        [cell setValue:@"Meters"];
    } else {
        [cell setTitle:@"Unit of temperature"];
        [cell setValue:@"Celsius"];
    }

    return cell;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
