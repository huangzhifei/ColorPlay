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

@interface CPGameViewController ()<CPGameQuestionViewDelegate>

@property (weak, nonatomic) IBOutlet CPOutlineLabel *scoreLabel;

@property (strong, nonatomic) CPGameScene *scene;
@property (nonatomic) CPGameMode gameMode;
@property (nonatomic, strong) CPGameQuestionView *currentQuestionView;
@property (nonatomic, strong) CPGameQuestionView *lastQuestionView;
@property (nonatomic, strong) NSMutableArray *cardViewList;

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
    
}

#pragma mark - life cycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( !_scene )
    {
        self.scene = [[CPGameScene alloc] initWithGameMode:self.gameMode];
    }
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

- (void)timeout
{
#pragma mark - tag 
    // 将来在失败或者超时，还添加一个毛玻璃效果，展现一个失败画面，例如：大哭gif
    
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
        
        [UIView animateWithDuration:0.5 animations:^{
            
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
