//
//  MacrosResourse.h
//  BasicFramework
//
//  Created by Rainy on 16/9/5.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#ifndef MacrosResourse_h
#define MacrosResourse_h


/**
 *  常量
 */
static BOOL _isPlay = NO;
static NSInteger _kPlayListNumber = 0;
static NSTimeInterval _myPlayCurrentTime = 0;
static NSString *_playListCellIdentifier = @"PlayListCell";

/**
 *  image
 */
#define kProgressThumbImg [UIImage imageNamed:@"滑块"]
#define kPauseImg [UIImage imageNamed:@"pause"]
#define kPlayImg [UIImage imageNamed:@"play"]
#define kBackImageViewImg [UIImage imageNamed:@"backImg.png"]
#define kanimationImageViewImg [UIImage imageNamed:@"animationImg"]
#define kCancelImg [UIImage imageNamed:@"cancel"]
#define kMarkerImg [UIImage imageNamed:@"marker"]


#define kListOnPlay @"listOnPlay"


/**
 *  上次播放历史
 */
#define kPlayHistoryNum [[[AppSingle Shared]getValueInMyLocalStoreForKey:KEY_PlayHistoryNum] integerValue]
#define KEY_PlayHistoryNum @"PlayHistoryNum"


#endif /* MacrosResourse_h */
