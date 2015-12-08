//
//  CPGameViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameViewController.h"
#import "CPStopWatchView.h"
#import "CPOutlineLabel.h"
#import "CPGameScene.h"
#import "CPGameQuestionView.h"
#import "CPResultViewController.h"
#import "GCDTimer.h"
#import "CPGameCardView.h"
#import "CPSoundManager.h"
#import "CPSettingData.h"
#import "AppDelegate.h"
#import "CPStarsOverlayView.h"

@interface CPGameViewController ()<CPGameQuestionViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet CPOutlineLabel *scoreLabel;

@property (nonatomic, strong) CPGameScene           *scene;
@property (nonatomic, assign) CPGameMode            gameMode;
@property (nonatomic, strong) CPGameQuestionView    *currentQuestionView;
@property (nonatomic, strong) CPGameQuestionView    *lastQuestionView;
@property (nonatomic, strong) NSMutableArray        *cardViewList;
@property (nonatomic, strong) CPSettingData         *setting;
@property (nonatomic, strong) CPSoundManager        *soundManager;
@property (nonatomic, strong) CPStarsOverlayView    *starOverlayView;

@end

@implementation CPGameViewController

#pragma mark - init

- (instancetype)initWithGameMode:(CPGameMode)gameMode
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    
    if( self )
    {
        _gameMode = gameMode;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cardViewList = [[NSMutableArray alloc] init];
    
    self.setting = [CPSettingData sharedInstance];
    self.soundManager = [CPSoundManager sharedInstance];
    [self.soundManager preloadBackgroundMusic:kMainMusic];
    self.soundManager.musicVolume = self.setting.musicVolumn / 100;
}

#pragma mark - life cycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( !_starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
    }
    
    if( !_scene )
    {
        self.scene = [[CPGameScene alloc] initWithGameMode:self.gameMode];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    //[self.soundManager playBackgroundMusic:kMainMusic loops:YES];
    
    if( self.setting.musicSelected )
    {
        
    }
    else
    {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter

- (void)setScene:(CPGameScene *)scene
{
    _scene = scene;
    
    [self addCardViews];
    
    [self showCardViewsAnimation];
}

#pragma mark - private Method

- (void)updateScore
{
    [self.scoreLabel setAlpha:1.0f];
    [self.scoreLabel setText:[NSString stringWithFormat:@"%ld\t",(long)self.scene.score]];
    [self.view bringSubviewToFront:self.scoreLabel];
}

- (void)gameOver
{
    CPResultViewController *resultVC = [CPResultViewController initWithNib];
    resultVC.gameMode = self.gameMode;
    resultVC.score = self.scene.score;
    [self.navigationController pushViewController:resultVC animated:YES];
    
}

- (void)addQuestionView
{
    self.currentQuestionView = [[CPGameQuestionView alloc] initWithFrame:kScreen
                                                                question:self.scene.gameQuestion
                                                                gameMode:self.gameMode];
    self.currentQuestionView.delegate = self;
    
    [self.view addSubview:self.currentQuestionView];
    
    [self updateScore];

}

- (void)addCardViews
{
    [self.scoreLabel setAlpha:0.0f];
    if( self.gameMode == CPGameClassicMode )
    {
        return;
    }
    
    NSArray *cardList = self.scene.gameQuestion.questionCards;
    [self.cardViewList removeAllObjects];
    for(NSInteger index = 0; index < cardList.count; ++ index)
    {
        CPGameCard *card = [cardList objectAtIndex:index];
    
        CPGameCardView *cardView = [[CPGameCardView alloc] initWithFrame:self.view.frame card:card];
    
        [self.cardViewList addObject:cardView];
    }
    
    for(NSInteger index = self.cardViewList.count - 1; index >=0 ; -- index)
    {
        [self.view addSubview:[self.cardViewList objectAtIndex:index]];
    }
}

- (void)showCardViewsAnimation
{
    if( self.gameMode == CPGameClassicMode )
    {
        [self addQuestionView];
        
        return;
    }
    
    static NSInteger cardIndex = 0;
    NSArray *cardList = self.scene.gameQuestion.questionCards;
    if( cardIndex >= cardList.count )
    {
        cardIndex = 0;
        
        [self addQuestionView];
        
        return;
    }
    
    CPGameCardView *cardView = [self.cardViewList objectAtIndex:cardIndex];
    
    CGFloat delay = 1.6 - 3.0/self.scene.gameQuestion.limitTime;
    
    [GCDTimer scheduledTimerWithTimeInterval:delay repeats:NO block:^{
                                           
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             cardView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0);
                             
                         } completion:^(BOOL finished) {
                             
                             [cardView removeFromSuperview];
                             
                             cardIndex ++;
                             
                             [self showCardViewsAnimation];
                             
                         }];
        
     }];

}

#pragma mark - question view delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if( [toVC isKindOfClass:[CPResultViewController class]] )
    {
        CPExplodeAnimationController *explodeAnimation = [[CPExplodeAnimationController alloc] init];
        return explodeAnimation;
    }
    else
    {
        return nil;
    }
}

- (void)timeout
{
    [self gameOver];
}

- (void)checkAnswerWithClickOption:(BOOL)right
{
    if( right )
    {
        [self.scene nextQuestion];
        
        self.currentQuestionView.delegate = nil;
        self.lastQuestionView = self.currentQuestionView;
        
        //先添加，防止出现动画切换时不连贯
        [self addCardViews];
        
        //将新添加的view放到当前view后面
        if( self.lastQuestionView )
        {
            [self.view bringSubviewToFront:self.lastQuestionView];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.lastQuestionView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            [self.lastQuestionView removeFromSuperview];
            
            [self showCardViewsAnimation];
            
        }];
        
    }
    
    else
    {
        self.currentQuestionView.delegate = nil;
        [self gameOver];
    }
}

@end
