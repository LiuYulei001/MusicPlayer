//
//  PlayListVC.m
//  BasicFramework
//
//  Created by Rainy on 16/9/5.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "PlayListVC.h"
#import "PlayListCell.h"

@interface PlayListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titile_lab;

@property(nonatomic,strong)NSArray *myArray;

@end

@implementation PlayListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _page = 1;
    
    [self setDataWith:_page];
    
    [self layoutUI];
    
    
}
-(void)addFooterPullAction
{
    [APPSINGLE addFooderPullOnView:self.myTableView waitTime:1 action:^{
        
        _page ++;
        
        [self setDataWith:_page];
        [self.myTableView reloadData];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:_playListCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.titleText_lab.text = [self getTitleInURL:self.myArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row != self.index_number) {
        
        cell.marker_img.image = nil;
        cell.play_img.image = kPlayImg;
    }else
    {
        cell.marker_img.image = kMarkerImg;
        cell.play_img.image = nil;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [kNotificationCenter postNotificationName:kListOnPlay object:[NSString stringWithFormat:@"%ld",indexPath.row]];
    [self cancelAction:nil];
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setData
-(void)setDataWith:(int)page
{
    if (self.myData_array.count >= 20) {
        
        [self addFooterPullAction];
        
        self.myArray = [self.myData_array subarrayWithRange:NSMakeRange(0, 20 * page)];
        if (page != 1) {
            
            [APPSINGLE footerEndRefreshingOnView:self.myTableView];
        }
        
    }else
    {
        self.myArray = self.myData_array;
    }
    
}
#pragma mark - layoutUI
-(void)layoutUI
{
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    self.myTableView.separatorColor = kWhiteColor;
    
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
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
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.myTableView registerNib:[UINib nibWithNibName:_playListCellIdentifier bundle:nil] forCellReuseIdentifier:_playListCellIdentifier];
    self.titile_lab.textColor = kWhiteColor;
    self.titile_lab.text = @"本地播放资源";
}
-(NSString *)getTitleInURL:(NSString *)url
{
    NSArray *temp_arr = [url componentsSeparatedByString:@"/"];
    return [temp_arr lastObject];
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
