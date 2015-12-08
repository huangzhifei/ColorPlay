//
//  CPSettingViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPSettingViewController.h"
#import "CPSettingData.h"
#import "CPSoundManager.h"
#import "CPMacro.h"
#import "CPStarsOverlayView.h"

typedef NS_ENUM(NSInteger, SliderType)
{
    SoundMusicSlider = 100,
    SoundEffectSlider
};

typedef NS_ENUM(NSInteger, ButtonCheckType)
{
    ButtonMusic = 200,
    ButtonEffect,
    ButtonBgEffect,
    ButtonNotification
};

@interface CPSettingViewController ()

- (IBAction)defaultClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
- (IBAction)selectedClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *soundMusicCheck;
@property (weak, nonatomic) IBOutlet UIButton *soundEffectCheck;
@property (weak, nonatomic) IBOutlet UIButton *bgEffectCheck;
@property (weak, nonatomic) IBOutlet UIButton *notificationPusCheck;

@property (weak, nonatomic) IBOutlet UIView *soundMusicSlider;
@property (weak, nonatomic) IBOutlet UIView *soundEffectSlider;

@property (weak, nonatomic) IBOutlet UIView *soundView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *saveView;
@property (weak, nonatomic) IBOutlet UIImageView *musicSliderLeft;
@property (weak, nonatomic) IBOutlet UIImageView *musicSliderRight;
@property (weak, nonatomic) IBOutlet UIImageView *effectSliderLeft;
@property (weak, nonatomic) IBOutlet UIImageView *effectSliderRight;

- (IBAction)backClicked:(id)sender;

@property (strong, nonatomic) UISlider *musicSlider;
@property (strong, nonatomic) UISlider *effectSlider;
@property (nonatomic) BOOL viewCornerFlag;
@property (strong, nonatomic) CPSettingData *setting;
@property (strong, nonatomic) CPSoundManager *soundManager;
@property (strong, nonatomic) CPStarsOverlayView *starOverlayView;

@end

@implementation CPSettingViewController

+ (instancetype)initWithNib
{
    return [[CPSettingViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshSettingData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( !_starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
    
    if( !_musicSlider )
    {
        [self.soundMusicSlider addSubview:self.musicSlider];
        [self.musicSlider setValue:self.setting.musicVolumn animated:YES];
    }
    
    if( !_effectSlider )
    {
        [self.soundEffectSlider addSubview:self.effectSlider];
        [self.effectSlider setValue:self.setting.effectVolumn animated:NO];
    }
}

- (void)commonInit
{
    _viewCornerFlag = false;

    _soundEffectCheck.selected = self.setting.effectSelected;
    _soundEffectCheck.tag = ButtonEffect;
    
    _soundMusicCheck.selected = self.setting.musicSelected;
    _soundMusicCheck.tag = ButtonMusic;
    _bgEffectCheck.selected = self.setting.bgEffectSelected;
    _bgEffectCheck.tag = ButtonBgEffect;
    
    _notificationPusCheck.selected = self.setting.notificationSelected;
    _notificationPusCheck.tag = ButtonNotification;
    
    _soundManager = [CPSoundManager sharedInstance];
    _setting = [CPSettingData sharedInstance];
    
    [self.soundManager playBackgroundMusic:kMainMusic loops:YES];
}

#pragma getter

- (UISlider *)musicSlider
{
    if( !_musicSlider )
    {
        _musicSlider = ({
            
            UISlider *slider = [[UISlider alloc] initWithFrame:self.soundMusicSlider.bounds];
            
            UIImage *stetchLeftTrack= [UIImage imageNamed:@"brightness_bar.png"];
            UIImage *stetchRightTrack = [UIImage imageNamed:@"brightness_bar_1.png"];
            
            UIImage *thumbImage = [UIImage imageNamed:@"bar_mark.png"];
            
            slider.minimumValue=0.0f;
            slider.maximumValue=100.0f;
            slider.value = 0;
            slider.continuous = NO;
            slider.tag = SoundMusicSlider;
            [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
            [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
            
            //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
            [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
            [slider setThumbImage:thumbImage forState:UIControlStateNormal];
            
            [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
            
            slider;
        });
    }
    return _musicSlider;
}

- (UISlider *)effectSlider
{
    if( !_effectSlider )
    {
        _effectSlider = ({
            
            UISlider *slider = [[UISlider alloc] initWithFrame:self.soundMusicSlider.bounds];
            
            UIImage *stetchLeftTrack= [UIImage imageNamed:@"brightness_bar.png"];
            UIImage *stetchRightTrack = [UIImage imageNamed:@"brightness_bar_1.png"];
            
            UIImage *thumbImage = [UIImage imageNamed:@"bar_mark.png"];
            
            slider.minimumValue=0.0f;
            slider.maximumValue=100.0f;
            slider.value = 0;
            slider.continuous = NO;
            slider.tag = SoundEffectSlider;
            [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
            [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
            
            //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
            [slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
            [slider setThumbImage:thumbImage forState:UIControlStateNormal];
            
            [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
            slider;
            
        });
    }
    return _effectSlider;
}

- (void)updateUIState
{
    self.soundEffectCheck.selected = self.setting.effectSelected;
    
    self.soundMusicCheck.selected = self.setting.musicSelected;
    
    self.bgEffectCheck.selected = self.setting.bgEffectSelected;
    
    self.notificationPusCheck.selected = self.setting.notificationSelected;
    
    [self.musicSlider setValue:self.setting.musicVolumn animated:YES];
    
    [self.effectSlider setValue:self.setting.effectVolumn animated:YES];

}

#pragma mark - events

- (void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    switch( slider.tag )
    {
        case SoundMusicSlider:
        {
            self.musicSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.musicSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            
            self.setting.musicVolumn = slider.value;
        }
            break;
            
        case SoundEffectSlider:
        {
            self.effectSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.effectSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            
            self.setting.effectVolumn = slider.value;
        }
            
        default:
            
            break;
            
    }
    
    
}

- (void)sliderTouchDown:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    switch( slider.tag )
    {
        case SoundMusicSlider:
        {
            self.musicSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            self.musicSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        }
            break;
            
        case SoundEffectSlider:
        {
            self.effectSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
            self.effectSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        }
            
        default:
            
            break;
            
    }
}

#pragma mark - actions

- (IBAction)defaultClicked:(id)sender {

    [self.setting defaultSetting];
    
    [self updateUIState];
    
    [self refreshSettingData];
}

- (IBAction)saveClicked:(id)sender {
    
    [self.setting saveSetting];
    
    [self refreshSettingData];
}

- (IBAction)selectedClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
    
    switch(button.tag)
    {
        case ButtonMusic:
        {
            self.setting.musicSelected = button.selected;
        }
            break;
        
        case ButtonEffect:
        {
            self.setting.effectSelected = button.selected;
        }
            break;
            
        case ButtonBgEffect:
        {
            self.setting.bgEffectSelected = button.selected;
        }
            break;
            
        case ButtonNotification:
        {
            self.setting.notificationSelected = button.selected;
        }
            break;
    }
    
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - private Methods

-(void)refreshSettingData
{
    self.soundManager.musicVolume = self.setting.musicVolumn / 100;
}

@end
