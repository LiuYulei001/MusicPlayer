//
//  PlayerManagerVC.m
//  BasicFramework
//
//  Created by Rainy on 16/9/2.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "PlayerManagerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerManager.h"
#import "PlayListVC.h"

@interface PlayerManagerVC ()<PlayerManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIButton *toListBT;

@property (weak, nonatomic) IBOutlet LGScrollLabel *title_lab;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;

@property (weak, nonatomic) IBOutlet UISlider *playProgress;

@property (weak, nonatomic) IBOutlet UIButton *beforBT;
@property (weak, nonatomic) IBOutlet UIButton *nextBT;

@property (weak, nonatomic) IBOutlet UIButton *playBT;

@property (weak, nonatomic) IBOutlet UILabel *allTime;

@property (weak, nonatomic) IBOutlet UILabel *currentTime;


@property(nonatomic,strong)PlayerManager *playerManager;

@property(nonatomic,strong)NSTimer *myTimer;
@property(nonatomic,strong)NSTimer *RotationTimer;

@end

@implementation PlayerManagerVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    [self setData];
    [self layoutUI];
    
}
#pragma mark - listOnPlay
-(void)listOnPlay:(NSNotification *)obj
{
    _isPlay = NO;
    if (obj.object) {
        
        _kPlayListNumber = [obj.object integerValue];
    }
    [self.myTimer invalidate];
    [self.RotationTimer invalidate];
    self.playProgress.userInteractionEnabled = NO;
    _myPlayCurrentTime = 0;
    [self.playerManager stop];
    [self playAction:nil];
}
#pragma mark - play
- (IBAction)playAction:(id)sender {
    
    if (_isPlay) {
        
        [self.playBT setBackgroundImage:kPlayImg forState:UIControlStateNormal];
        _isPlay = NO;
        [self.playerManager pause];
        [self.myTimer invalidate];
        [self.RotationTimer invalidate];
        self.playProgress.userInteractionEnabled = NO;
        
    }else
    {
        
        self.playProgress.userInteractionEnabled = YES;
        [self.playBT setBackgroundImage:kPauseImg forState:UIControlStateNormal];
        _isPlay = YES;
        
        [self.playerManager startWithUrl:self.playerManager.mp3_URLS[_kPlayListNumber] playAtTime:_myPlayCurrentTime];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(songProgress:) userInfo:nil repeats:YES];
        self.RotationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(songRotationAnimation:) userInfo:nil repeats:YES];
        self.playProgress.maximumValue = self.playerManager.player.duration;
        [self.title_lab setStrings:@[[self getTitleInURL:self.playerManager.mp3_URLS[_kPlayListNumber]]]];
        self.allTime.text = [self timeFormatted:self.playerManager.player.duration];
        
        [APPSINGLE saveInMyLocalStoreForValue:[NSString stringWithFormat:@"%ld",(long)_kPlayListNumber] atKey:KEY_PlayHistoryNum];
        
    }
}
#pragma mark - next
- (IBAction)nextAction:(id)sender {
    
    if (_kPlayListNumber == self.playerManager.mp3_URLS.count-1) {
        
        _kPlayListNumber = 0;
    }else
    {
        
        _kPlayListNumber ++;
    }
    [self listOnPlay:nil];
}
#pragma mark - befor
- (IBAction)beforAction:(id)sender {
    
    if (!_kPlayListNumber) {
        _kPlayListNumber = self.playerManager.mp3_URLS.count-1;
        
    }else
    {
        _kPlayListNumber --;
    }
    [self listOnPlay:nil];
}
#pragma mark - Go list
- (IBAction)goListVC:(id)sender {
    
    PlayListVC *list = [[PlayListVC alloc]init];
    list.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    list.myData_array = self.playerManager.mp3_URLS;
    list.index_number = _kPlayListNumber;
    [self presentViewController:list animated:YES completion:nil];
}



#pragma mark - songProgress
-(void)songProgress:(NSTimer *)timer
{
    _myPlayCurrentTime = self.playerManager.player.currentTime;
    self.playProgress.value = self.playerManager.player.currentTime;
    self.currentTime.text = [self timeFormatted:self.playerManager.player.duration - self.playerManager.player.currentTime];
}
static CGFloat rotat = 0;
-(void)songRotationAnimation:(NSTimer *)timer
{
    if (rotat > 360) {
        
        rotat = 0;
    }else
    {
        rotat += 0.005;
    }
    self.animationImageView.transform = CGAffineTransformMakeRotation(rotat);
}
#pragma mark - AVAudioPlayerDelegate
- (void)playerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self nextAction:nil];
}




#pragma mark - pullPlayProgress
-(void)pullPlayProgress:(UISlider *)slider
{
    _myPlayCurrentTime = slider.value;
    [self.playerManager startWithUrl:self.playerManager.mp3_URLS[_kPlayListNumber] playAtTime:slider.value];
}







#pragma mark - getter
-(PlayerManager *)playerManager
{
    if (!_playerManager) {
        
        _playerManager = [[PlayerManager alloc]init];
        _playerManager.playerDelegate = self;
    }
    return _playerManager;
}











#pragma mark - time calculate
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
-(NSString *)getTitleInURL:(NSString *)url
{
    NSArray *temp_arr = [url componentsSeparatedByString:@"/"];
    return [temp_arr lastObject];
}
#pragma mark - setData
-(void)setData
{
    if (kPlayHistoryNum) {
        
        _kPlayListNumber = kPlayHistoryNum;
    }
    
    [kNotificationCenter addObserver:self selector:@selector(listOnPlay:) name:kListOnPlay object:nil];
}
#pragma mark - layoutUI
-(void)layoutUI
{
    [self.title_lab setStrings:@[[self getTitleInURL:self.playerManager.mp3_URLS[_kPlayListNumber]]]];
    [_title_lab setTextFont:[UIFont systemFontOfSize:17]];
    [_title_lab setDirection:LGScrollLabelDirectionRTL];
    [_title_lab setSpeed:100];
    [_title_lab start];
    
    self.allTime.textColor = self.currentTime.textColor = kWhiteColor;
    self.allTime.text = self.currentTime.text = @"--:--";
    
    self.title_lab.textColor = kThemeColor;
    self.playProgress.maximumTrackTintColor = kBackDefaultGrayColor;
    self.playProgress.minimumTrackTintColor = kThemeColor;
    [self.playProgress setThumbImage:kProgressThumbImg forState:UIControlStateNormal];
    [self.playProgress addTarget:self action:@selector(pullPlayProgress:) forControlEvents:UIControlEventValueChanged];
    self.playProgress.userInteractionEnabled = NO;
    self.playProgress.minimumValue = 0;
    self.playProgress.value = 0;
    [APPSINGLE addBorderOnView:self.animationImageView cornerRad:self.animationImageView.Sw/2 lineCollor:[kThemeColor colorWithAlphaComponent:0.5] lineWidth:2];

    self.backImageView.image = kBackImageViewImg;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.9;
    effectView.frame = kScreenBounds;
    [self.backImageView addSubview:effectView];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//        blurFilter.blurRadiusInPixels = 8.0;
//        UIImage *image = [blurFilter imageByFilteringImage:kBackImageViewImg];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.backImageView.image = image;
//        });
//    });
    
    self.animationImageView.image = kanimationImageViewImg;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
