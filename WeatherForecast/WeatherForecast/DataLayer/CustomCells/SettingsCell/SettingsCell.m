//
//  SettingsCell.m
//  WeatherForecast
//
//  Created by rost on 16.09.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#define WIDTH self.bounds.size.width

#import "SettingsCell.h"


@interface SettingsCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *valueLabel;
@end


@implementation SettingsCell

#pragma mark - Constructor
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [self setLabel:self.titleLabel withRect:CGRectMake(20.0f, 15.0f, 150.0f, 20.0f) andType:TypeTitle];
        [self addSubview:self.titleLabel];
        self.valueLabel = [self setLabel:self.valueLabel withRect:CGRectMake(WIDTH - 160.0f, 15.0f, 150.0f, 20.0f) andType:TypeValue];
        [self addSubview:self.valueLabel];
        
        UIImageView *separatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 49.0f, WIDTH, 1.0f)];
        separatorImage.image = [UIImage imageNamed:@"divider-bottom"];
        [self addSubview:separatorImage];
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
    
    if (type == TypeTitle) {
        label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
    } else if (type == TypeValue) {
        label.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
        label.textColor = BLUE_COLOR;
        label.textAlignment = NSTextAlignmentRight;
    }
    
    return label;
}
#pragma mark -


#pragma mark - Value setters
- (void)setTitle:(NSString *)titleString  {
    if ((titleString) && (titleString.length > 0))
        self.titleLabel.text = titleString;
}

- (void)setValue:(NSString *)valueString {
    if ((valueString) && (valueString.length > 0))
        self.valueLabel.text = valueString;
}
#pragma mark -

@end
