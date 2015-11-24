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

@interface CPMenuViewController ()
{
    CGFloat mainViewOffsetX;
    CGFloat mainViewOffsetY;
}

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (strong, nonatomic) CPAnimation3DMenuView *menu3DView;
@property (strong, nonatomic) CPEffectLabelView     *effectLabel;
@property (strong, nonatomic) UIView *effectViewMask;
@end

@implementation CPMenuViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.titleView addSubview:self.effectLabel];
    [self.effectLabel performEffectAnimation:2 repeats:YES];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:kVersion];
    [self.versionLabel setText:[NSString stringWithFormat:@"v %@",version]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)initWithNib
{
    CPMenuViewController *vc = [[CPMenuViewController alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( _effectLabel )
    {
        self.effectLabel.center = self.titleView.center;
    }
    
    if( !_menu3DView )
    {
        [self.mainView addSubview:self.menu3DView];
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
            label.textColor = [UIColor redColor];
            label.effectColor = @[(id)[UIColor blackColor].CGColor,
                                        (id)[UIColor yellowColor].CGColor,
                                        (id)[UIColor greenColor].CGColor,
                                        (id)[UIColor blueColor].CGColor];
            
            label;
        });
        
    }
    
    return _effectLabel;
}

- (CPAnimation3DMenuView *)menu3DView
{
    if( !_menu3DView )
    {
        CPAnimation3DItem *easy = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [easy setTitle:@"Classic" forState:UIControlStateNormal];
        [easy setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]]  forState:UIControlStateNormal];
        [easy setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
        [easy.titleLabel setTextColor:[UIColor blackColor]];
        [easy.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [easy addTarget:self action:@selector(easyMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *hard = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [hard setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]]  forState:UIControlStateNormal];
        [hard setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateHighlighted];
        [hard setTitle:@"Fantasy" forState:UIControlStateNormal];
        [hard.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [hard addTarget:self action:@selector(hardMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *setting = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [setting setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]]  forState:UIControlStateNormal];
        [setting setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
        [setting setTitle:@"Setting" forState:UIControlStateNormal];
        [setting.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [setting addTarget:self action:@selector(settingMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *about = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [about setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]]  forState:UIControlStateNormal];
        [about setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forState:UIControlStateHighlighted];
        [about setTitle:@"About" forState:UIControlStateNormal];
        [about.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [about addTarget:self action:@selector(aboutMode:) forControlEvents:UIControlEventTouchUpInside];
        
        CPAnimation3DItem *guide = [CPAnimation3DItem buttonWithType:UIButtonTypeSystem];
        [guide setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]]  forState:UIControlStateNormal];
        [guide setBackgroundImage:[UIImage imageWithColor:[UIColor purpleColor]] forState:UIControlStateHighlighted];
        [guide setTitle:@"Tutorial" forState:UIControlStateNormal];
        [guide.titleLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:15]];
        [guide addTarget:self action:@selector(guideMode:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *items = @[easy, hard, setting, about, guide];
        
        _menu3DView = [[CPAnimation3DMenuView alloc] initWithFrame:self.mainView.bounds itemsArray:items radius:80 duration:0.5];

    }

    return _menu3DView;
}

#pragma mark - events

- (void)easyMode:(id)sender
{
    CPGameViewController *gameVC = [[CPGameViewController alloc] initWithGameMode:CPGameClassicMode];
    
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (void)hardMode:(id)sender
{
    CPGameViewController *gameVC = [[CPGameViewController alloc] initWithGameMode:CPGameFantasyMode];
    
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (void)settingMode:(id)sender
{
    CPSettingViewController *settingVC = [CPSettingViewController initWithNib];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)aboutMode:(id)sender
{
    CPAboutViewController *aboutVC = [CPAboutViewController initWithNib];
    
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)guideMode:(id)sender
{
    CPTutorialViewController *tutoriaVC = [CPTutorialViewController initWithNib];
    
    [self.navigationController pushViewController:tutoriaVC animated:YES];
}


@end
