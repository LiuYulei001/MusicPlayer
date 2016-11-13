//
//  PlayListCell.m
//  BasicFramework
//
//  Created by Rainy on 16/9/5.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleText_lab.textColor = kWhiteColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
