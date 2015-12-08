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
    CPStartStatusHalf,
    CPStartStatusOne,
    CPStartStatusOneHalf,
    CPStartStatusTwo,
    CPStartStatusTwoHalf,
    CPStartStatusThree
};

@interface CPGameScoreView()

@property (weak, nonatomic) IBOutlet UILabel        *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel        *highscoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView    *starred_1;
@property (weak, nonatomic) IBOutlet UIImageView    *starred_2;
@property (weak, nonatomic) IBOutlet UIImageView    *starred_3;

@property (assign, nonatomic) CPGameMode mode;
@property (assign, nonatomic) NSInteger score;

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
        
        _mode = mode;
        _score = score;
        
        _modeLabel.text = [self stringFromMode:mode];
        _scoreLabel.text = [NSString stringWithFormat:@"%ld", score];
        
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
        
        _highscoreLabel.text = [NSString stringWithFormat:@"%ld", _highScore];
        
        [self syncHighScore];

    }
    
    return self;
}

#pragma mark - private Methods

- (CPStartStatus)startShow
{
    if( self.score <= 0 || (self.score - self.highScore + 5) <= 0 ) return CPStartStatusHalf;
    
    else
    {
        NSInteger rank = self.score - self.highScore + 5;
        
        switch (rank)
        {
            case CPStartStatusHalf:
                return CPStartStatusHalf;
            
            case CPStartStatusOne:
                return CPStartStatusOne;
                
            case CPStartStatusOneHalf:
                return CPStartStatusOneHalf;
                
            case CPStartStatusTwo:
                return CPStartStatusTwo;
                
            case CPStartStatusTwoHalf:
                return CPStartStatusTwoHalf;
                
            default:
                return CPStartStatusThree;
                
        }
        
        return 0;
    }
}

- (void)syncStarts
{
    switch ([self startShow])
    {
        case CPStartStatusHalf:
        {
            self.starred_1.image  = [UIImage imageNamed:@"starredhalf"];
            self.starred_1.alpha = 1;
        }
            break;
            
        case CPStartStatusOne:
        {
            self.starred_1.alpha = 1;
        }
            break;
            
        case CPStartStatusOneHalf:
        {
            self.starred_1.alpha = 1;
            self.starred_2.image  = [UIImage imageNamed:@"starredhalf"];
            self.starred_2.alpha = 1;
        }
            break;
            
        case CPStartStatusTwo:
        {
            self.starred_1.alpha = 1;
            self.starred_2.alpha = 1;
        }
            break;
            
        case CPStartStatusTwoHalf:
        {
            self.starred_1.alpha = 1;
            self.starred_2.alpha = 1;
            self.starred_3.image  = [UIImage imageNamed:@"starredhalf"];
            self.starred_3.alpha = 1;
        }
            break;
            
        case CPStartStatusThree:
        {
            self.starred_1.alpha = 1;
            self.starred_2.alpha = 1;
            self.starred_3.alpha = 1;
        }
            break;
            
        default:
            break;
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
    self.starred_1.alpha = 0;
    self.starred_2.alpha = 0;
    self.starred_3.alpha = 0;
    
    [GCDTimer scheduledTimerWithTimeInterval:0.1f repeats:NO block:^{
        
        CGFloat moveDistance = self.frame.size.width;
        CGRect frame = self.frame;
        frame.origin.x -= moveDistance;
        self.frame = frame;
        
        [UIView animateWithDuration:1.0f
                              delay:0.0f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:5.0f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             CGRect frame = self.frame;
                             frame.origin.x += moveDistance;
                             self.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             
                             CGMutablePathRef path = CGPathCreateMutable();
                             CGPathMoveToPoint(path, NULL, -self.bounds.size.width, 0);
                             CGPathAddCurveToPoint(path, NULL, -self.bounds.size.width/2, 0.0,
                                                   self.bounds.size.width/6, 120,
                                                   270 , 95);
                             
                             CPFireWorkView *fireView = [[CPFireWorkView alloc] initWithFrame:self.bounds movePath:path];
                             
                             [self addSubview:fireView];
                             [fireView startAnimation:2.0f block:^{

                                 [UIView animateWithDuration:1.0f
                                                       delay:0.0f
                                                     options:UIViewAnimationOptionCurveLinear
                                                  animations:^{
                                                      
                                                      [self syncStarts];
                                                      
                                                  } completion:^(BOOL finished) {
                                                      
                                                      [fireView removeFromSuperview];
                                                      
                                                  }];
                             }];
                             
                         }];

        
    }];
}

@end
