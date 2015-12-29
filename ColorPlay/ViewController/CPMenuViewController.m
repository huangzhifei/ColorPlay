//
//  SPMainViewController.m
//  StroopPlay
//
//  Created by huangzhifei on 15/11/4.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPMenuViewController.h"
#import "CPEmitterView.h"
#import "CPEffectLabelView.h"
#import "UIColor+Common.h"
#import "UIImage+Color.h"
#import "CPAnimation3DMenuView.h"
#import "CPGameViewController.h"
#import "CPSettingViewController.h"
#import "CPAboutViewController.h"
#import "CPTutorialViewController.h"
#import "CPSoundManager.h"
#import "CPSettingData.h"
#import "CPStarsOverlayView.h"
#import "GCDTimer.h"
#import "CPFlipAnimationController.h"
#import "CPSharedViewController.h"

@interface CPMenuViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView     *titleView;
@property (weak, nonatomic) IBOutlet UIView     *mainView;
@property (weak, nonatomic) IBOutlet UILabel    *versionLabel;

@property (strong, nonatomic) CPAnimation3DMenuView     *menu3DView;
@property (strong, nonatomic) CPEffectLabelView         *effectLabel;
@property (strong, nonatomic) CPSoundManager            *soundManager;
@property (strong, nonatomic) CPSettingData             *setting;
@property (strong, nonatomic) CPStarsOverlayView        *starOverlayView;
@property (strong, nonatomic) CPFlipAnimationController *filpAnimation;

@end

@implementation CPMenuViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.filpAnimation = [[CPFlipAnimationController alloc] init];
    self.setting = [CPSettingData sharedInstance];
    self.soundManager = [CPSoundManager sharedInstance];
    if( self.setting.musicSelected )
    {
        [self.soundManager preloadBackgroundMusic:kMainMusic];
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kVersion];
    [self.versionLabel setText:[NSString stringWithFormat:@"v %@",version]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)initWithNib
{
    // ps: initWithNibName 懒加载，此时View上的控件是nil，只有到需要显示时，才会不是nil
    CPMenuViewController *vc = [[CPMenuViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    return vc;
}

/**
 *  我们应该在willAppear里面set delegate
 *  在willDisappear里面set delegate = nil
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    if( self.setting.musicSelected )
    {
        [self.soundManager playBackgroundMusic:kMainMusic loops:YES];
        
        [self refreshSettingMusic];
    }
    else
    {
        [self.soundManager stopBackgroundMusic];
    }
    
    if( self.setting.effectSelected )
    {
        [self.soundManager preloadEffect:kSenceEffect];
        
        [self refreshSettingEffect];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
    
    if( self.starOverlayView )
    {
        [self.starOverlayView stopFireWork];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    if( !_starOverlayView)
    {
        NSLog(@"MenuView alloc startOver");
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
    
    if( !_effectLabel )
    {
        [self.titleView addSubview:self.effectLabel];
        self.effectLabel.center = self.titleView.center;
        [self.effectLabel performEffectAnimation:2 repeats:YES];
    }
    if( !_menu3DView )
    {
        [self.mainView addSubview:self.menu3DView];
        [self.menu3DView startAnimation];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if( !self.setting.bgEffectSelected && self.starOverlayView.isEffectRunning )
    {
        [self.starOverlayView stopFireWork];
    }
    else if( self.setting.bgEffectSelected && !self.starOverlayView.isEffectRunning )
    {
        [self.starOverlayView restartFireWork];
    }
}

#pragma mark - getter

- (UIView *)effectLabel
{
    if( !_effectLabel )
    {
        _effectLabel = ({
            
            CPEffectLabelView *label = [[CPEffectLabelView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            label.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:40];
            label.text = @"ColorPlay";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            
            label;
        });
        
    }
    
    return _effectLabel;
}

- (CPAnimation3DMenuView *)menu3DView
{
    if( !_menu3DView )
    {
        CPAnimation3DItem *easy = ({
            
            CPAnimation3DItem *item = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
            
            [item setTitle:@"Classic" forState:UIControlStateNormal];
            [item setTintColor:[UIColor whiteColor]];
            [item.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
            
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF1493"]]
                            forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FF1493"]]
                            forState:UIControlStateHighlighted];
            
            [item addTarget:self action:@selector(easyMode:) forControlEvents:UIControlEventTouchUpInside];
            
            item;
        });
        
        
        CPAnimation3DItem *hard = ({
            
            CPAnimation3DItem *item = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
            
            [item setTitle:@"Fantasy" forState:UIControlStateNormal];
            [item setTintColor:[UIColor whiteColor]];
            [item.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
            
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#9932CC"]]
                            forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#9932CC"]]
                            forState:UIControlStateHighlighted];
            
            [item addTarget:self action:@selector(hardMode:) forControlEvents:UIControlEventTouchUpInside];
            
            item;
        });
        
        
        CPAnimation3DItem *setting = ({
            
            CPAnimation3DItem *item = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
            
            [item setTitle:@"Setting" forState:UIControlStateNormal];
            [item setTintColor:[UIColor whiteColor]];
            [item.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
            
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4169E1"]]
                            forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#4169E1"]]
                            forState:UIControlStateHighlighted];
            
            [item addTarget:self action:@selector(settingMode:) forControlEvents:UIControlEventTouchUpInside];
            
            item;
        });
        
        
        CPAnimation3DItem *about = ({
            
            CPAnimation3DItem *item = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
            
            [item setTitle:@"About" forState:UIControlStateNormal];
            [item setTintColor:[UIColor whiteColor]];
            [item.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];

            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00FF00"]]
                            forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#00FF00"]]
                            forState:UIControlStateHighlighted];
            
            [item addTarget:self action:@selector(aboutMode:) forControlEvents:UIControlEventTouchUpInside];

            item;
        });
        
        CPAnimation3DItem *guide = ({
            
            CPAnimation3DItem *item = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
            
            [item setTitle:@"Tutorial" forState:UIControlStateNormal];
            [item setTintColor:[UIColor whiteColor]];
            [item.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
            
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFD700"]]
                            forState:UIControlStateNormal];
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FFD700"]]
                            forState:UIControlStateHighlighted];
            
            [item addTarget:self action:@selector(guideMode:) forControlEvents:UIControlEventTouchUpInside];
            
            item;
        });
        
        NSArray *items = @[easy, hard, setting, about, guide];
        
        CGFloat radius = 90;
        if( kScreen.size.height > 568 ) radius = 100;
        else if( kScreen.size.height < 568 ) radius = 80;
        NSLog(@"radius %f", radius);
        _menu3DView = [[CPAnimation3DMenuView alloc] initWithFrame:self.mainView.bounds
                                                        itemsArray:items
                                                            radius:radius
                                                          duration:0.5];

    }

    return _menu3DView;
}

#pragma mark - events

- (void)easyMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;
    
    if( self.setting.effectSelected )
    {
        [self.soundManager playEffect:kSenceEffect vibrate:NO];
    }
    
    [item touchUpInsideAnimation:^{
        
        self.filpAnimation.presenting = YES;
        CPGameViewController *gameVC = [[CPGameViewController alloc] initWithGameMode:CPGameClassicMode];
        [self.navigationController pushViewController:gameVC animated:YES];
        
    }];
    
}

- (void)hardMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;

    if( self.setting.effectSelected )
    {
        [self.soundManager playEffect:kSenceEffect vibrate:NO];
    }
    
    [item touchUpInsideAnimation:^{
        
        self.filpAnimation.presenting = YES;
        CPGameViewController *gameVC = [[CPGameViewController alloc] initWithGameMode:CPGameFantasyMode];
        [self.navigationController pushViewController:gameVC animated:YES];
        
    }];
}

- (void)settingMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;

    if( self.setting.effectSelected )
    {
        [self.soundManager playEffect:kSenceEffect vibrate:NO];
    }
    
    [item touchUpInsideAnimation:^{
        
        self.filpAnimation.presenting = YES;
        CPSettingViewController *settingVC = [CPSettingViewController initWithNib];
        [self.navigationController pushViewController:settingVC animated:YES];
        
    }];
}

- (void)aboutMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;

    if( self.setting.effectSelected )
    {
        [self.soundManager playEffect:kSenceEffect vibrate:NO];
    }
    
    [item touchUpInsideAnimation:^{
        
        self.filpAnimation.presenting = YES;
        CPAboutViewController *aboutVC = [CPAboutViewController initWithNib];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }];
}

- (void)guideMode:(id)sender
{
    CPAnimation3DItem *item = (CPAnimation3DItem *)sender;

    if( self.setting.effectSelected )
    {
        [self.soundManager playEffect:kSenceEffect vibrate:NO];
    }
    
    [item touchUpInsideAnimation:^{
        
        self.filpAnimation.presenting = YES;
        CPTutorialViewController *tutoriaVC = [CPTutorialViewController initWithNib];
        [self.navigationController pushViewController:tutoriaVC animated:YES];
        
    }];
}

#pragma mark - private Methods

- (void)refreshSettingMusic
{
    self.soundManager.musicVolume = self.setting.musicVolumn / 100;
}

- (void)refreshSettingEffect
{
    self.soundManager.effectVolume = self.setting.effectVolumn / 100;
}

#pragma mark - delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    //return self.filpAnimation;
    return nil;
}

@end
