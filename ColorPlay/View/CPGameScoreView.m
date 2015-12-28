//
//  CPGameScoreView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/23.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameScoreView.h"
#import "GCDTimer.h"
#import "CPFireWorkView.h"

typedef NS_ENUM(NSInteger,CPStartStatus)
{
    CPStartStatusZero,
    CPStartStatusOne,
    CPStartStatusTwo,
    CPStartStatusThree,
    CPStartStatusFour,
    CPStartStatusFive
};

@interface CPGameScoreView()

@property (weak, nonatomic) IBOutlet UILabel        *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel        *highscoreLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starredepts;

@property (assign, nonatomic) CPGameMode            mode;
@property (assign, nonatomic) NSInteger             score;
@property (strong, nonatomic) CPFireWorkView        *fireWorkView;

@end

@implementation CPGameScoreView

#pragma mark - init

+ (instancetype)loadDIYNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (instancetype)initWithFrame:(CGRect)frame Mode:(CPGameMode)mode score:(NSInteger)score
{
    self = [CPGameScoreView loadDIYNib];

    if( self )
    {
        [self setFrame:frame];
        [self updateStarsAlpha:NO];
        
        _mode = mode;
        _score = score;
        
        _modeLabel.text = [self stringFromMode:mode];
        _scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
        
        _highScore = ({
            
            NSInteger score = 0;
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            switch (_mode)
            {
                case CPGameClassicMode:
                {
                    score = [userDefault integerForKey:kClassicHighScore];
                }
                    break;
                    
                case CPGameFantasyMode:
                {
                    score = [userDefault integerForKey:kFantasyHighScore];
                }
                    break;
                    
                default:
                    break;
            }
            
            score;
        });
        
        _highscoreLabel.text = [NSString stringWithFormat:@"%ld", (long)_highScore];
        
        [self syncHighScore];

    }
    
    return self;
}

#pragma mark - private Methods

- (void)updateStarsAlpha:(BOOL)value
{
    for( UIImageView *view in self.starredepts )
    {
        view.alpha = value;
    }
}

- (CPStartStatus)startShow
{
    if( self.score <= 0 ) return CPStartStatusZero;
    else if( self.score > 0 && self.score + 5 >= self.highScore && self.score > 30 ) return CPStartStatusFour;
    else if( self.score > 0 && self.score + 10 >= self.highScore && self.score > 15) return CPStartStatusThree;
    else if( self.score > 0 && self.score + 15 >= self.highScore && self.score > 10) return CPStartStatusTwo;
    else if( self.score > 99 ) return CPStartStatusFive;
    else return CPStartStatusOne;
}

- (void)syncStarts
{
    NSInteger index = 0;
    
    for( ; index < [self startShow]; index ++)
    {
        UIImageView *imageView = [self.starredepts objectAtIndex:index];
        imageView.image = [UIImage imageNamed:@"starred"];
        imageView.alpha = 1;
    }
    
    for( ; index < self.starredepts.count; ++ index)
    {
        UIImageView *imageView = [self.starredepts objectAtIndex:index];
        imageView.alpha = 1;
    }
}

- (void)syncHighScore
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (self.mode)
    {
        case CPGameClassicMode:
        {
            if( self.highScore < self.score )
            {
                [userDefault setInteger:self.score forKey:kClassicHighScore];
            }
        }
            break;
            
        case CPGameFantasyMode:
        {
            if( self.highScore < self.score )
            {
                [userDefault setInteger:self.score forKey:kFantasyHighScore];
            }
        }
            break;
            
        default:
            
            break;
    }

}

- (NSString*)stringFromMode:(CPGameMode)mode
{

    switch (mode) {
        case CPGameClassicMode:
            return @"Classical";
            break;
            
        case CPGameFantasyMode:
            return @"Fantasy";
            break;
            
        default:
            return @"";
            break;
    }

}

#pragma mark - public Methods

- (void)startAnimation
{
    [GCDTimer scheduledTimerWithTimeInterval:0.1f repeats:NO block:^{
        
        CGFloat moveDistance = self.frame.size.width;
        CGRect frame = self.frame;
        frame.origin.x -= moveDistance;
        self.frame = frame;
        
        [UIView animateWithDuration:0.8f
                              delay:0.0f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:5.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             NSLog(@"first start1");
                             CGRect frame = self.frame;
                             frame.origin.x += moveDistance;
                             self.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             NSLog(@"first end");
                             CGMutablePathRef path = CGPathCreateMutable();
                             CGPathMoveToPoint(path, NULL, -self.bounds.size.width, 0);
                             CGPathAddCurveToPoint(path, NULL, -self.bounds.size.width/2, 0.0,
                                                   self.bounds.size.width/6, 120,
                                                   self.bounds.size.width - 40, 95);
                             
                             self.fireWorkView = [[CPFireWorkView alloc] initWithFrame:self.bounds movePath:path];
                             [self addSubview:self.fireWorkView];
                             
                             weakify(self);
                             [self.fireWorkView startAnimation:1.0f block:^{
                                 
                                 strongify(self)
                                 [UIView animateWithDuration:1.0f
                                                       delay:0.0f
                                                     options:UIViewAnimationOptionCurveEaseOut
                                                  animations:^{
                                                      NSLog(@"start1");
                                                      /**
                                                       *  syncStarts 里面没有 UIView 动画的默认元素，是不执行动画的
                                                       *  直接跳到completion里面，并且finished 的值还是 true
                                                       *  后续在里面增加了alpha值的变化就可以正常执行动画了。
                                                       */
                                                      [self syncStarts];
                                                      
                                                  } completion:^(BOOL finished) {
                                                      NSLog(@"end2 finished %d", finished);
                                                      CGPathRelease(path);
                                                      [self.fireWorkView removeFromSuperview];
                                                  }];
                                 
                             }];
                             
                         }];

        
    }];
}

@end
