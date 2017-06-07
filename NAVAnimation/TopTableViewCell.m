//
//  TopTableViewCell.m
//  NAVAnimation
//
//  Created by 邓松 on 2017/6/7.
//  Copyright © 2017年 邓松. All rights reserved.
//

#import "TopTableViewCell.h"

@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TopTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
