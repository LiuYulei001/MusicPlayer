//
//  PlayerManager.h
//  BasicFramework
//
//  Created by Rainy on 16/9/2.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol PlayerManagerDelegate <NSObject>

-(void)playerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end

@interface PlayerManager : NSObject

@property(nonatomic,retain)AVAudioPlayer *player;
@property(nonatomic,strong)NSArray *mp3_URLS;

@property(nonatomic,assign)id<PlayerManagerDelegate> playerDelegate;



-(void)startWithUrl:(NSString *)url playAtTime:(NSTimeInterval)time;
-(void)stop;
-(void)pause;

@end
