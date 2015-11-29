//
//  CPSettingViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPSettingViewController.h"
#import "CPSettingData.h"

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

- (void)viewDidLayoutSubviews
{
//    if( !self.viewCornerFlag )
//    {
//        self.viewCornerFlag = YES;
//        
//        self.soundView.layer.borderWidth = 2.0f;
//        self.soundView.layer.cornerRadius = 15.0f;
//        
//        self.functionView.layer.borderWidth = 2.0f;
//        self.functionView.layer.cornerRadius = 15.0f;
//        
//        self.saveView.layer.borderWidth = 2.0f;
//        self.saveView.layer.cornerRadius = 15.0f;
//    }
    
    if( !_musicSlider )
    {
        [self.soundMusicSlider addSubview:self.musicSlider];
        CPSettingData *setting = [CPSettingData sharedInstance];
        [self.musicSlider setValue:setting.musicVolumn animated:YES];
    }
    
    if( !_effectSlider )
    {
        [self.soundEffectSlider addSubview:self.effectSlider];
        CPSettingData *setting = [CPSettingData sharedInstance];
        [self.effectSlider setValue:setting.effectVolumn animated:NO];
    }
}

- (void)commonInit
{
    self.viewCornerFlag = false;
    
    CPSettingData *setting = [CPSettingData sharedInstance];
    
    self.soundEffectCheck.selected = setting.effectSelected;
    self.soundEffectCheck.tag = ButtonEffect;
    
    self.soundMusicCheck.selected = setting.musicSelected;
    self.soundMusicCheck.tag = ButtonMusic;
    
    self.bgEffectCheck.selected = setting.bgEffectSelected;
    self.bgEffectCheck.tag = ButtonBgEffect;
    
    self.notificationPusCheck.selected = setting.notificationSelected;
    self.notificationPusCheck.tag = ButtonNotification;
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
    CPSettingData *setting = [CPSettingData sharedInstance];
    
    self.soundEffectCheck.selected = setting.effectSelected;
    
    self.soundMusicCheck.selected = setting.musicSelected;
    
    self.bgEffectCheck.selected = setting.bgEffectSelected;
    
    self.notificationPusCheck.selected = setting.notificationSelected;
    
    [self.musicSlider setValue:setting.musicVolumn animated:YES];
    
    [self.effectSlider setValue:setting.effectVolumn animated:YES];

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
            
            CPSettingData *setting = [CPSettingData sharedInstance];
            setting.musicVolumn = slider.value;
        }
            break;
            
        case SoundEffectSlider:
        {
            self.effectSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.effectSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            
            CPSettingData *setting = [CPSettingData sharedInstance];
            setting.effectVolumn = slider.value;
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
            self.musicSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
            self.musicSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        }
            break;
            
        case SoundEffectSlider:
        {
            self.effectSliderLeft.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
            self.effectSliderRight.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        }
            
        default:
            
            break;
            
    }
}

#pragma mark - actions

- (IBAction)defaultClicked:(id)sender {
    
    CPSettingData *setting = [CPSettingData sharedInstance];
    
    [setting defaultSetting];
    
    [self updateUIState];
}

- (IBAction)saveClicked:(id)sender {
    
    CPSettingData *setting = [CPSettingData sharedInstance];
    
    [setting saveSetting];
}

- (IBAction)selectedClicked:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    button.selected = !button.selected;
    CPSettingData *setting = [CPSettingData sharedInstance];
    
    switch(button.tag)
    {
        case ButtonMusic:
        {
            setting.musicSelected = button.selected;
        }
            break;
        
        case ButtonEffect:
        {
            setting.effectSelected = button.selected;
        }
            break;
            
        case ButtonBgEffect:
        {
            setting.bgEffectSelected = button.selected;
        }
            break;
            
        case ButtonNotification:
        {
            setting.notificationSelected = button.selected;
        }
            break;
    }
    
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
