//
//  PlayListCell.h
//  BasicFramework
//
//  Created by Rainy on 16/9/5.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText_lab;
@property (weak, nonatomic) IBOutlet UIImageView *play_img;
@property (weak, nonatomic) IBOutlet UIImageView *marker_img;

@end
