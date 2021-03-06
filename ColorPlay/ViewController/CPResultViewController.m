//
//  CPResultViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPResultViewController.h"
#import "CPAnimation3DMenuView.h"
#import "UIImage+Color.h"
#import "CPGameViewController.h"
#import "CPSettingViewController.h"
#import "CPTutorialViewController.h"
#import "CPGameScoreView.h"
#import "CPEffectLabelView.h"
#import "GCDTimer.h"
#import "CPStarsOverlayView.h"

@interface CPResultViewController()

@property (weak, nonatomic) IBOutlet UIView         *titleView;
@property (weak, nonatomic) IBOutlet UIView         *scoreView;
@property (weak, nonatomic) IBOutlet UIView         *menuView;
@property (weak, nonatomic) IBOutlet UILabel        *bannerLabel;

@property (strong, nonatomic) CPAnimation3DMenuView *menu3DView;
@property (strong, nonatomic) CPGameScoreView       *gameScoreView;
@property (strong, nonatomic) CPEffectLabelView     *effectView;
@property (strong, nonatomic) CPStarsOverlayView    *starOverlayView;

@end

@implementation CPResultViewController

#pragma mark - load nib

+ (instancetype)initWithNib
{
    CPResultViewController *vc = [[CPResultViewController alloc] initWithNibName:NSStringFromClass([self class])
                                                                          bundle:nil];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.starOverlayView )
    {
        [self.starOverlayView restartFireWork];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /**
     *  如果这里不删除粒子layer，在进行push或pop动画时，会出现粒子“静态假象”，动画非常不连贯
     *  此bug困扰很久，*fuck*
     */
    if( self.starOverlayView )
    {
        [self.starOverlayView stopFireWork];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    if( !_starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
    
    if( !_effectView )
    {
        [self.titleView addSubview:self.effectView];
        self.effectView.center = self.titleView.center;
        [self.effectView performEffectAnimation:2 repeats:YES];
    }
    
    if( !_gameScoreView )
    {
        [self.scoreView addSubview:self.gameScoreView];
        [self.gameScoreView startAnimation];
        
        [GCDTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^{
            
            NSInteger highScore = self.gameScoreView.highScore;
            
            if( self.score >= highScore )
            {
                self.bannerLabel.text = @"继续努力!";
            }
            else
            {
                self.bannerLabel.text = @"还需要努力!";
            }
            
        }];
    }
    
    if( !_menu3DView )
    {
        [self.menuView addSubview:self.menu3DView];
        [self.menu3DView startAnimation];
    }
    
}

- (CPEffectLabelView *)effectView
{
    if( !_effectView )
    {
        _effectView = ({
            CPEffectLabelView *label = [[CPEffectLabelView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:40];
            label.text = @"ColorPlay";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.effectColor = @[(id)[UIColor blackColor].CGColor,
                                  (id)[UIColor yellowColor].CGColor,
                                  (id)[UIColor greenColor].CGColor,
                                  (id)[UIColor blueColor].CGColor];
            
            label;
        });
    }
    
    return _effectView;

}

- (CPGameScoreView *)gameScoreView
{
    if( !_gameScoreView )
    {
        _gameScoreView =  ({
            
            CPGameScoreView *view = [[CPGameScoreView alloc] initWithFrame:self.scoreView.bounds
                                                                    Mode:self.gameMode
                                                                   score:self.score];
            view;
        });
    }
    
    return _gameScoreView;
}

- (CPAnimation3DMenuView *)menu3DView
{
    if( !_menu3DView )
    {
        CPAnimation3DItem *replay = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [replay setTitle:@"Replay" forState:UIControlStateNormal];
        [replay setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]]  forState:UIControlStateNormal];
        [replay setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
        [replay.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [replay addTarget:self action:@selector(replayMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *shared = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [shared setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]]  forState:UIControlStateNormal];
        [shared setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateHighlighted];
        [shared setTitle:@"Share" forState:UIControlStateNormal];
        [shared.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [shared addTarget:self action:@selector(sharedMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *setting = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [setting setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]]  forState:UIControlStateNormal];
        [setting setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
        [setting setTitle:@"Setting" forState:UIControlStateNormal];
        [setting.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [setting addTarget:self action:@selector(settingMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *home = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [home setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]]  forState:UIControlStateNormal];
        [home setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateHighlighted];
        [home setTitle:@"Home" forState:UIControlStateNormal];
        [home.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [home addTarget:self action:@selector(homeMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *guide = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [guide setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]]  forState:UIControlStateNormal];
        [guide setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]] forState:UIControlStateHighlighted];
        [guide setTitle:@"Tutorial" forState:UIControlStateNormal];
        [guide.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [guide addTarget:self action:@selector(guideMode:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *items = @[replay, shared, setting, guide, home];
        
        _menu3DView = [[CPAnimation3DMenuView alloc] initWithFrame:self.menuView.bounds
                                                        itemsArray:items
                                                            radius:90
                                                          duration:0.5];

    }
    
    return _menu3DView;

}

- (void)replayMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;
    
    [item touchUpInsideAnimation:^{
        
        CPGameViewController *gameVC = [[CPGameViewController alloc] initWithGameMode:self.gameMode];
        [self.navigationController pushViewController:gameVC animated:YES];
        
        // 注意：如果不这样清理，里面会一直增加VC
        self.navigationController.viewControllers = @[self.navigationController.childViewControllers[0],
                                                      self.navigationController.topViewController];
        
    }];
    
}

- (void)sharedMode:(id)sender
{
    
}

- (void)settingMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;
    
    [item touchUpInsideAnimation:^{
        
        CPSettingViewController *settingVC = [CPSettingViewController initWithNib];
        [self.navigationController pushViewController:settingVC animated:YES];
        
        self.navigationController.viewControllers = @[self.navigationController.childViewControllers[0],
                                                      self.navigationController.topViewController];
    }];
}

- (void)homeMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;
    
    [item touchUpInsideAnimation:^{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
}

- (void)guideMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;
    
    [item touchUpInsideAnimation:^{
        
        CPTutorialViewController *tutoriaVC = [CPTutorialViewController initWithNib];
        [self.navigationController pushViewController:tutoriaVC animated:YES];
        
        self.navigationController.viewControllers = @[self.navigationController.childViewControllers[0],
                                                      self.navigationController.topViewController];
        
    }];
    
}

@end
