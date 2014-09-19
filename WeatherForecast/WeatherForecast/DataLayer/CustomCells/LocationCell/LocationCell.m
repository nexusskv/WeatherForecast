//
//  LocationCell.m
//  WeatherForecast
//
//  Created by rost on 15.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#define WIDTH self.bounds.size.width

#import "LocationCell.h"
#import "UIImageView+AFNetworking.h"


@interface LocationCell ()
@property (strong, nonatomic) UIImageView *weatherImage;
@property (strong, nonatomic) UIImageView *curLocImage;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UILabel *temperatLabel;
@end


@implementation LocationCell

#pragma mark - Constructor
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.weatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 80.0f, 80.0f)];
        self.weatherImage.layer.cornerRadius = 15.0f;
        self.weatherImage.layer.masksToBounds = YES;
        [self addSubview:self.weatherImage];
        
        if ([reuseIdentifier isEqualToString:@"currentLocationCell"]) {
            self.curLocImage = [[UIImageView alloc] init];
            self.curLocImage.image = [UIImage imageNamed:@"Current"];
            [self addSubview:self.curLocImage];
        }
        
        self.titleLabel = [self setLabel:self.titleLabel withRect:CGRectMake(100.0f, 15.0f, 100.0f, 40.0f) andType:TypeTitle];
        self.titleLabel.numberOfLines = 2;
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = [self setLabel:self.subTitleLabel withRect:CGRectMake(100.0f, 55.0f, 100.0f, 20.0f) andType:TypeSubTitle];
        [self addSubview:self.subTitleLabel];
        
        self.temperatLabel = [self setLabel:self.temperatLabel withRect:CGRectMake(WIDTH - 90.0f, 15.0f, 80.0f, 60.0f) andType:TypeTemperature];
        [self addSubview:self.temperatLabel];
    }
    return self;
}
#pragma mark -


#pragma mark - Selected cell actions
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
#pragma mark -


#pragma mark - Create labels helper
- (UILabel *)setLabel:(UILabel *)label withRect:(CGRect)rect andType:(NSUInteger)type {
    label = [[UILabel alloc] initWithFrame:rect];
    
    switch (type) {
        case TypeTitle: {
            label.font = [UIFont boldSystemFontOfSize:14.0f];
            label.textColor = [UIColor blackColor];
            return label;
        }
            break;
        case TypeSubTitle: {
            label.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            label.textColor = [UIColor blackColor];
            return label;
        }
            break;
        case TypeTemperature: {
            label.font = [UIFont fontWithName:@"Helvetica" size:52.0f];
            label.textColor = BLUE_COLOR;
            return label;
        }
            break;
    }
    
    return nil;
}
#pragma mark -


#pragma mark - Value setters
- (void)setImgView:(NSString *)urlString {
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
    }
}

- (void)setTitle:(NSString *)titleString {
    if ((titleString) && (titleString.length > 0))
        self.titleLabel.text = titleString;
    
    if (self.curLocImage) {
        float titleLabelWidth = [self.titleLabel.text boundingRectWithSize:self.titleLabel.frame.size
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{ NSFontAttributeName:self.titleLabel.font }
                                                                   context:nil].size.width;
        self.curLocImage.frame = CGRectMake(titleLabelWidth + 105.0f, 30.0f, 12.0f, 12.0f);
    }
}

- (void)setSubTitle:(NSString *)subTitleString {
    if ((subTitleString) && (subTitleString.length > 0))
        self.subTitleLabel.text = subTitleString;
}

- (void)setTemperature:(NSString *)temperatString {
    if ((temperatString) && (temperatString.length > 0))
        self.temperatLabel.text = [NSString stringWithFormat:@"%@°", temperatString];
}
#pragma mark -

@end
