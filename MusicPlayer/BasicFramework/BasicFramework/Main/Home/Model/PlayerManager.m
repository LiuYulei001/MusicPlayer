//
//  PlayerManager.m
//  BasicFramework
//
//  Created by Rainy on 16/9/2.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "PlayerManager.h"


@interface PlayerManager ()<AVAudioPlayerDelegate>



@end

@implementation PlayerManager


#pragma mark - start
-(void)startWithUrl:(NSString *)url playAtTime:(NSTimeInterval)time
{
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:url] error:nil];
    _player.volume = 1.0;
    [_player prepareToPlay];
    
    _player.delegate = self;
    [_player playAtTime:time];
    _player.currentTime = time;
    
    //设置锁屏仍能继续播放
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}
-(void)stop
{
    [self.player stop];
}
-(void)pause
{
    [self.player pause];
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.playerDelegate && [self.playerDelegate respondsToSelector:@selector(playerDidFinishPlaying:successfully:)]) {
        
        [self.playerDelegate playerDidFinishPlaying:player successfully:flag];
    }
}



-(NSArray *)getMp3URLsForBundle
{
    NSString *bundlePath=[[NSBundle mainBundle]resourcePath];

    NSMutableArray *mp3_URLS = [NSMutableArray array];
    NSArray *arrMp3=[NSBundle pathsForResourcesOfType:@"mp3" inDirectory:bundlePath];
    for (NSString *filePath in arrMp3) {
        
        [mp3_URLS addObject:filePath];
    }
    
    return mp3_URLS;
}
-(NSArray *)mp3_URLS
{
    if (!_mp3_URLS) {
        
        _mp3_URLS = [self getMp3URLsForBundle];
    }
    return _mp3_URLS;
}
@end
