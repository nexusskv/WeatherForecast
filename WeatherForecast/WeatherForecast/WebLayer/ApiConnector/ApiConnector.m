//
//  ApiConnector.m
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "ApiConnector.h"
#import "AFHTTPRequestOperation.h"
#import "ConfigUrlBridge.h"

@implementation ApiConnector

#pragma mark - Constructor with block callback
- (id)initWithCallback:(ApiConnectorCallback)block
{
    if (self = [super init]) {
        self.callbackBlock = block;
    }
    
    return self;
}
#pragma mark -


#pragma mark - Weather load selector
- (void)getWeatherByConditions:(NSDictionary *)conditions orLocations:(NSArray *)locations {
    if (!locations) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[self prepareRequestByConditions:conditions]];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]])
                if ([[(NSDictionary *)responseObject allKeys] count] > 0) {
                    self.callbackBlock(responseObject);
                }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request error: %@", error.description);
        }];
        [operation start];
    }
    else {
        __block NSMutableArray *tempMutArray = [NSMutableArray array];
        __block NSUInteger responseCounter = 0;
        
        NSMutableArray *operationsArray = [NSMutableArray array];
        
        for (NSString *location in locations) {
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:
                                                 [self prepareRequestByConditions:@{@"type"       : @(Today),
                                                                                    @"location"   : location}]];
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ((responseObject) && ([responseObject isKindOfClass:[NSDictionary class]]))
                    if ([[(NSDictionary *)responseObject allValues] count] > 0) {
                        [tempMutArray addObject:[[(NSDictionary *)responseObject valueForKeyPath:@"data.weather"] objectAtIndex:0]];
                        responseCounter++;
                        
                        if (responseCounter == [locations count])
                            if ([tempMutArray count] > 0)
                                self.callbackBlock(tempMutArray);
                    }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Request error: %@", error.description);
            }];
            [operationsArray addObject:operation];
        }
                
        NSArray *ops = [AFURLConnectionOperation batchOfRequestOperations:operationsArray
                                                            progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) { }
                                                          completionBlock:^(NSArray *operations) { }];
        [[NSOperationQueue mainQueue] addOperations:ops waitUntilFinished:NO];
    }
}
#pragma mark -


#pragma mark - Request prepare helper
- (NSURLRequest *)prepareRequestByConditions:(NSDictionary *)conditions {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[ConfigUrlBridge configURL:conditions]]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:60.0f];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    
    return request;
}
#pragma mark -

@end
