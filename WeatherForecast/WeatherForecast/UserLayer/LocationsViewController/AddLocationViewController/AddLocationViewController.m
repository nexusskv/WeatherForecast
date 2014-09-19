//
//  AddLocationViewController.m
//  WeatherForecast
//
//  Created by rost on 15.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "AddLocationViewController.h"
#import "ApiConnector.h"


@interface AddLocationViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) UITableView *searchTable;
@property (nonatomic, strong) NSArray *resultsArray;
@end


@implementation AddLocationViewController

#pragma mark - Constructor
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.view.bounds.size.width, 44.0f)];
    searchBar.placeholder = @"Please enter location";
    searchBar.showsCancelButton = YES;
    searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    searchBar.delegate = self;
    
    for (UIView *searchBarSubview in [searchBar subviews]) {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeySearch];
                [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e) {
                // ignore exception
            }
        }
    }
    
    UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, 5.0f)];
    separatorImage.image = [UIImage imageNamed:@"LocationLine"];
    
    self.searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 70.0f, VIEW_WIDTH, VIEW_HEIGHT - 70.0f) style:UITableViewStylePlain];
    self.searchTable.delegate       = self;
    self.searchTable.dataSource     = self;
    self.searchTable.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.searchTable.backgroundColor   = [UIColor clearColor];
    
    [self.view addSubview:searchBar];
    [self.view addSubview:separatorImage];
    [self.view addSubview:self.searchTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark -


#pragma mark - SearchBar delegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.resultsArray = nil;
    [self.searchTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    ApiConnector *connector = [[ApiConnector alloc] initWithCallback:^(id resultObject) {

        if ((resultObject) && ([resultObject isKindOfClass:[NSDictionary class]]))
            if ([[(NSDictionary *)resultObject allValues] count] > 0) {
                self.resultsArray = [(NSDictionary *)resultObject valueForKeyPath:@"search_api.result"];
                if ([self.resultsArray count] > 0)
                    [self.searchTable reloadData];
            }
    }];
    
    [connector getWeatherByConditions:@{@"type" : @(ListLocations), @"location" : searchBar.text} orLocations:nil];

    [searchBar resignFirstResponder];
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
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *addLocationCellId = @"addLocationCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addLocationCellId];
        
    NSDictionary *locationDictionary = [self.resultsArray objectAtIndex:indexPath.row];
    
    NSString *city = [NSString stringWithFormat:@"%@, ",
                      [[[locationDictionary valueForKey:@"areaName"] objectAtIndex:0] valueForKey:@"value"]];
    NSString *region = [[[locationDictionary valueForKey:@"region"] objectAtIndex:0] valueForKey:@"value"];
    
    NSMutableAttributedString *cityString = [[NSMutableAttributedString alloc] initWithString:city];
    [cityString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f]} range:NSMakeRange(0, cityString.length)];
    
    NSMutableAttributedString *regionString = [[NSMutableAttributedString alloc] initWithString:region];
    [regionString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor]}
                          range:NSMakeRange(0, regionString.length)];
    
    [cityString appendAttributedString:regionString];
    cell.textLabel.attributedText = cityString;

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *locationDictionary = [self.resultsArray objectAtIndex:indexPath.row];    
    NSString *city = [[[locationDictionary valueForKey:@"areaName"] objectAtIndex:0] valueForKey:@"value"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *locationsMutArray = [NSMutableArray arrayWithArray:[defaults arrayForKey:kLocations]];
    [locationsMutArray addObject:city];
    [defaults setObject:locationsMutArray forKey:kLocations];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
