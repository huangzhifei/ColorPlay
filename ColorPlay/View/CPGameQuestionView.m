//
//  CPGameQuestionView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameQuestionView.h"
#import "CPGameCard.h"
#import "CPStopWatchView.h"
#import "GCDTimer.h"
#import "CPRippleView.h"
#import "CPSoundManager.h"
#import "CPSettingData.h"

typedef NS_ENUM(NSInteger, CPGameQuestionAnimations)
{

    CPAnimationTopToBottomCrossover = 0,

    CPAnimationRightToLeftSpring,
    
    CPAnimationCurlDown,
    
    CPAnimationScale,
    
    CPAnimationDrop,
    
    CPAnimationFlipBottomToTop,
    
    CPGameQuestionAnimationsCount
};

@interface CPGameQuestionView()

@property (weak, nonatomic) IBOutlet UIView         *cardView;
@property (weak, nonatomic) IBOutlet UIView         *optionView;

@property (strong, nonatomic) UILabel               *cardText;
@property (strong, nonatomic) UILabel               *questionText;
@property (strong, nonatomic) UIControl             *optionA;
@property (strong, nonatomic) UIControl             *optionB;
@property (strong, nonatomic) UIControl             *optionC;
@property (strong, nonatomic) CPRippleView          *rippleView;
@property (strong, nonatomic) CPStopWatchView       *stopWatchView;
@property (assign, nonatomic) CPGameMode            gameMode;
@property (strong, nonatomic) CPGameQuestion        *question;
@property (assign, nonatomic, getter=isStartPlay) BOOL startPlay;

@end

@implementation CPGameQuestionView

#pragma mark - load nib

+ (instancetype)loadDIYNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

#pragma mark - initlize

- (instancetype)initWithFrame:(CGRect)frame question:(CPGameQuestion *)question gameMode:(CPGameMode)mode
{
    self = [CPGameQuestionView loadDIYNib];;
    
    if( self )
    {
        [self setFrame:frame];
            
        self.gameMode = mode;
        
        self.question = question;
        
        self.startPlay = NO;
        
        /**
         *  强行立即布局，他与setNeedsLayout不同的是，setNeedsLayout会使当前失效，在下一次事件中布局
         *  如果不强行布局，此时view上面的所有subview都还是autolayout时的值，并没有根据当前屏幕来适配
         */
        [self layoutIfNeeded];
        
        [self commonInit];
        
        [self setting];
        
        [self updateComponentAlpha:0];
        
        /**
         *  transitionWithView 动画要么在viewWillAppear里面调用，要么设置延时启动。
         *  because The container view has to be placed in the hierarchy before the animation starts
         * http://stackoverflow.com/questions/28264017/transitionwithview-not-performing-flip-animation
         */
        [GCDTimer scheduledTimerWithTimeInterval:0.02
                                         repeats:NO
                                           block:^{
                                               
                                               [self addAnimation: arc4random_uniform(CPGameQuestionAnimationsCount)];
                                               
                                           }];
        
    }
    
    return self;
}

- (void)commonInit
{
    CGRect cardViewFrame = self.cardView.frame;
    CGFloat cardOffsetY = cardViewFrame.size.height / 3;
    
    self.cardText = ({
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = cardViewFrame.size.width;
        CGFloat height = cardOffsetY;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:30.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.userInteractionEnabled = NO;
        label;
    });
    [self.cardView addSubview:self.cardText];
    
    self.stopWatchView = ({
        
        CGFloat x = 0;
        CGFloat y = cardOffsetY;
        CGFloat width = cardViewFrame.size.width;
        CGFloat height = cardOffsetY;
        
        CPStopWatchView *view = [[CPStopWatchView alloc] initWithFrame:CGRectMake(x, y, width, height)
                                                             stopWatch:self.question.limitTime];
        [view setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:90.0]];
        [view setOutlineWidth:5.0f];
        view.userInteractionEnabled = NO;
        view;
    });
    [self.cardView addSubview:self.stopWatchView];
    
    self.questionText = ({
        
        CGFloat x = 0;
        CGFloat y = cardOffsetY + cardOffsetY;
        CGFloat width = cardViewFrame.size.width;
        CGFloat height = cardViewFrame.size.height - self.cardText.frame.size.height - self.stopWatchView.frame.size.height;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:35.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.userInteractionEnabled = NO;
        label;
        
    });
    [self.cardView addSubview:self.questionText];
    
    CGRect optionFrame = self.optionView.frame;
    CGFloat optionOffsetWidth = optionFrame.size.width / 3;
    
    self.optionA = ({
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = optionOffsetWidth;
        CGFloat height = optionFrame.size.height;
        
        UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
        /**
         *  http://stackoverflow.com/questions/9350041/uicontrol-not-receiving-touches
         *  set userInteractionEnabled=NO, receiving touches
         *  send UIControlEventTouchUpInside in touchesEnd
         */
        view.userInteractionEnabled = NO;
        [view addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = 1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [label setText:@"A"];
        [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:45]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        label.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        view;
    });
    [self.optionView addSubview:self.optionA];
    
    self.optionB = ({
        
        CGFloat x = optionOffsetWidth;
        CGFloat y = 0;
        CGFloat width = optionOffsetWidth;
        CGFloat height = optionFrame.size.height;
        
        UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
        view.userInteractionEnabled = NO;
        [view addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = 2;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [label setText:@"B"];
        [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:45]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        [view addSubview:label];
        
        view;
    });
    [self.optionView addSubview:self.optionB];
    
    self.optionC = ({
    
        CGFloat x = optionOffsetWidth*2;
        CGFloat y = 0;
        CGFloat width = optionOffsetWidth;
        CGFloat height = optionFrame.size.height;
        
        UIControl *view = [[UIControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
        view.userInteractionEnabled = NO;
        [view addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        view.tag = 3;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [label setText:@"C"];
        [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:45]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        [view addSubview:label];
        
        view;
    });
    [self.optionView addSubview:self.optionC];
    
//    self.rippleView = ({
//    
//        CGFloat width = self.optionA.frame.size.width / 1.2;
//        
//        CPRippleView *view = [[CPRippleView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        
//        view;
//    });
}

- (void)setting
{
    switch(self.gameMode)
    {
        case CPGameClassicMode:
        {
            CPGameCard *gameCard = [self.question.questionCards firstObject];
            [self.cardText setTextColor:gameCard.textColor.color];
            [self.cardText setText:gameCard.textMeaningColor.colorName];
            [self.cardText setBackgroundColor:gameCard.bgColor.color];
            [self.stopWatchView setBackgroundColor:gameCard.bgColor.color];
            [self.questionText setBackgroundColor:gameCard.bgColor.color];
            NSLog(@"color %@", gameCard.bgColor.colorName);
            if ([gameCard.bgColor.colorName isEqualToString:@"Black"] ||
                [gameCard.bgColor.colorName isEqualToString:@"Yellow"])
            {
                [self.questionText setTextColor:[UIColor whiteColor]];
                [self.stopWatchView setTextColor:[UIColor whiteColor]];
                [self.stopWatchView setOutlineColor:[UIColor darkGrayColor]];
            }
            
        }
            break;
            
        case CPGameFantasyMode:
        {
            [self.cardView setBackgroundColor:[UIColor clearColor]];
            
            [self.stopWatchView setOutlineColor:[UIColor whiteColor]];
            
            [self.cardText setText:[NSString stringWithFormat:@"#%ld", (long)(self.question.targetIndex + 1)]];
            [self.cardText setTextColor:[UIColor whiteColor]];
            [self.questionText setTextColor:[UIColor whiteColor]];
            
        }
            break;
    }
    
    [self.questionText setText:[self.question getQuestion]];
    
    //options
    NSArray *options = self.question.questionOptions;
    [options enumerateObjectsUsingBlock:^(CPGameCardColor *option, NSUInteger idx, BOOL *stop) {
        UIView *optionView = [self.optionView viewWithTag:idx+1];
        [optionView setBackgroundColor:option.color];
        if ([option.colorName isEqual:@"Black"])
        {
            UILabel *label = [optionView subviews][0];
            [label setTextColor:[UIColor whiteColor]];
        }
    }];

}

#pragma mark - private Method anmimations

- (void)addAnimation:(CPGameQuestionAnimations)anim
{
    switch (anim)
    {
        case CPAnimationTopToBottomCrossover:
        {
            [self updateTopToBottomCrossoverFrame];
            
            [UIView animateWithDuration:0.6f
                                           delay:0.0f
                                         options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.optionA.transform = CGAffineTransformMakeTranslation(0, -self.optionView.frame.size.height);
                self.optionC.transform = CGAffineTransformMakeTranslation(0, -self.optionView.frame.size.height);
                self.optionB.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height);
                
            } completion:^(BOOL finished) {
                
            }];
            
            [UIView animateWithDuration:0.7f
                                  delay:0.0f
                 usingSpringWithDamping:0.4f
                  initialSpringVelocity:20.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                
                                 self.cardText.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            [UIView animateWithDuration:0.8f
                                  delay:0.0f
                 usingSpringWithDamping:0.4f
                  initialSpringVelocity:18.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
                                 self.stopWatchView.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                 
                             } completion:^(BOOL finished) {

                                 [self startTimer];
                                 
                             }];
            
            [UIView animateWithDuration:0.8f
                                  delay:0.0f
                 usingSpringWithDamping:0.4f
                  initialSpringVelocity:16.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                 
                                 self.questionText.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];

        }
            
            break;
            
        case CPAnimationRightToLeftSpring:
        {
            [self updateRightToLeftSpringFrame];
            
            [UIView animateWithDuration:0.25f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    
                                    self.optionA.transform = CGAffineTransformMakeTranslation(-self.optionView.frame.size.width, 0);
                                    
                                } completion:^(BOOL finished) {
                                    
                                    [UIView animateWithDuration:0.2f
                                                          delay:0.0f
                                                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                            
                                                            self.optionB.transform = CGAffineTransformMakeTranslation(-self.frame.size.width, 0);
                                                            
                                                        } completion:^(BOOL finished) {
                                                            
                                                            [UIView animateWithDuration:0.2f
                                                                                  delay:0.0f
                                                                                options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                                                    
                                                                                    self.optionC.transform = CGAffineTransformMakeTranslation(-self.frame.size.width,0);
                                                                                    
                                                                                } completion:^(BOOL finished) {
                                                                                    
                                                                                }];
                                                            
                                                        }];
                                }];
            
            [UIView animateWithDuration:0.6f
                                  delay:0.0f
                 usingSpringWithDamping:0.4f
                  initialSpringVelocity:20.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
                                    self.cardText.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                    
                                } completion:^(BOOL finished) {
                                    
                                }];
            
            [UIView animateWithDuration:0.8f
                                  delay:0.0f
                 usingSpringWithDamping:0.3f
                  initialSpringVelocity:18.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
                                    self.stopWatchView.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                    
                                } completion:^(BOOL finished) {
                                    
                                    [self startTimer];
                                    
                                }];
            
            [UIView animateWithDuration:0.8f
                                  delay:0.0f
                 usingSpringWithDamping:0.3f
                  initialSpringVelocity:16.0f
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                    
                                    self.questionText.transform = CGAffineTransformMakeTranslation(self.cardView.frame.size.width, 0);
                                    
                                } completion:^(BOOL finished) {
                                    
                                }];
        }
            
            break;
            
        case CPAnimationCurlDown:
        {
            [self updateCurlDown];

            [UIView transitionWithView:self.cardText duration:0.8f options: UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCurlUp
                            animations:^{
                                
                                self.cardText.alpha = 1;
                                
                            } completion:nil];
            
            [UIView transitionWithView:self.stopWatchView duration:0.8f options: UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCurlDown
                            animations:^{
                                
                                self.stopWatchView.alpha = 1;
                                
                            } completion:nil];
            
            [UIView transitionWithView:self.questionText duration:0.8f options: UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCurlUp
                            animations:^{
                                
                                self.questionText.alpha = 1;
                                
                            } completion:nil];

            [UIView transitionWithView:self.optionA duration:0.8f options: UIViewAnimationOptionTransitionCurlDown|UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                
                                self.optionA.alpha = 1;
                                
                            } completion:nil];
            
            [UIView transitionWithView:self.optionB duration:0.8f options: UIViewAnimationOptionTransitionCurlDown|UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                
                                self.optionB.alpha = 1;
                                
                            } completion:nil];
            
            [UIView transitionWithView:self.optionC duration:0.9f options: UIViewAnimationOptionTransitionCurlDown|UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                
                                self.optionC.alpha = 1;
                                
                            } completion:^(BOOL finished){
                                
                                [self startTimer];
                                
                            }];

        }
            break;
            
        case CPAnimationScale:
        {
            [self updateScaleFrame];
            
            self.cardText.alpha = 1;
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:15.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 self.cardText.transform = CGAffineTransformMakeScale(1, 1);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 self.stopWatchView.alpha = 1;
                                 [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:20.0f
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      
                                                      self.stopWatchView.transform = CGAffineTransformMakeScale(1, 1);
                                                      
                                                  } completion:^(BOOL finished) {
                                                      
                                                      self.questionText.alpha = 1;
                                                      [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:20.0f
                                                                          options:UIViewAnimationOptionCurveEaseInOut
                                                                       animations:^{
                                                                           
                                                                           self.questionText.transform = CGAffineTransformMakeScale(1, 1);
                                                                           
                                                                       } completion:^(BOOL finished) {
                                                                           
                                                                           [self startTimer];
                                                                           
                                                                       }];
                                                      
                                                  }];
                                 
                             }];
            
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                self.optionA.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    self.optionB.alpha = 1;
                    
                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        self.optionC.alpha = 1;
                        
                    } completion:^(BOOL finished) {
                        
                    }];
                    
                }];
                
            }];
            
        }
            break;
            
        case CPAnimationDrop:
        {
            [self updateDropFrame];
            
            self.cardText.alpha = 1;
            [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:5.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 self.cardText.transform = CGAffineTransformMakeTranslation(0, self.cardView.frame.size.height);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 self.optionA.alpha = 1;
                                 self.stopWatchView.alpha = 1;
                                 [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:5.0f
                                                     options:UIViewAnimationOptionCurveEaseOut
                                                  animations:^{
                                                      
                                                      self.stopWatchView.transform = CGAffineTransformMakeTranslation(0, self.cardView.frame.size.height);
                                                      
                                                  } completion:^(BOOL finished) {
                                                      
                                                      self.optionB.alpha = 1;
                                                      self.questionText.alpha = 1;
                                                      [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:10.0f
                                                                          options:UIViewAnimationOptionCurveEaseOut
                                                                       animations:^{
                                                                           
                                                                           self.questionText.transform = CGAffineTransformMakeTranslation(0, self.cardView.frame.size.height);
                                                                           
                                                                       } completion:^(BOOL finished) {
                                                                           
                                                                           self.optionC.alpha = 1;
                                                                           [self startTimer];
                                                                           
                                                                       }];
                                                  }];
                                 
                             }];
            
        }
            break;
        
        case CPAnimationFlipBottomToTop:
        {
            self.cardText.alpha = 1;
            
            [UIView transitionWithView:self.cardText duration:0.2f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                
            } completion:^(BOOL finished) {
                
                self.stopWatchView.alpha = 1;
                [UIView transitionWithView:self.stopWatchView duration:0.2f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                    
                } completion:^(BOOL finished) {
                    
                    self.questionText.alpha = 1;
                    [UIView transitionWithView:self.questionText duration:0.2f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                        
                    } completion:^(BOOL finished) {
                        
                        self.optionA.alpha = 1;
                        [UIView transitionWithView:self.optionA duration:0.2f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                            
                        } completion:^(BOOL finished) {
                            
                            self.optionB.alpha = 1;
                            [UIView transitionWithView:self.optionB duration:0.2f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                                
                            } completion:^(BOOL finished) {
                                
                                self.optionC.alpha = 1;
                                [UIView transitionWithView:self.optionC duration:0.2f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    
                                    [self startTimer];
                                    
                                }];
                            }];
                        }];
                    }];
                    
                }];
            }];
        }
            break;
            
        default:
            
            break;
    }
}

- (void)updateTopToBottomCrossoverFrame
{
    [self updateComponentAlpha:0];
    
    CGRect frame = self.optionA.frame;
    frame.origin.y += self.optionA.frame.size.height;
    self.optionA.frame = frame;
    
    frame = self.optionB.frame;
    frame.origin.y -= self.frame.size.height;
    self.optionB.frame = frame;
    
    frame = self.optionC.frame;
    frame.origin.y += self.optionC.frame.size.height;
    self.optionC.frame = frame;
    
    frame = self.cardText.frame;
    frame.origin.x -= self.cardText.frame.size.width;
    self.cardText.frame = frame;
    
    frame = self.stopWatchView.frame;
    frame.origin.x -= self.stopWatchView.frame.size.width;
    self.stopWatchView.frame = frame;
    
    frame = self.questionText.frame;
    frame.origin.x -= self.questionText.frame.size.width;
    self.questionText.frame = frame;
    
    [self updateComponentAlpha:1];
}

- (void)updateRightToLeftSpringFrame
{
    [self updateComponentAlpha:0];
    
    CGRect frame = self.optionA.frame;
    frame.origin.x += self.frame.size.width;
    self.optionA.frame = frame;
    
    frame = self.optionB.frame;
    frame.origin.x += self.frame.size.width;
    self.optionB.frame = frame;
    
    frame = self.optionC.frame;
    frame.origin.x += self.frame.size.width;
    self.optionC.frame = frame;
    
    frame = self.cardText.frame;
    frame.origin.x -= self.cardText.frame.size.width;
    self.cardText.frame = frame;
    
    frame = self.stopWatchView.frame;
    frame.origin.x -= self.stopWatchView.frame.size.width;
    self.stopWatchView.frame = frame;
    
    frame = self.questionText.frame;
    frame.origin.x -= self.questionText.frame.size.width;
    self.questionText.frame = frame;
    
    [self updateComponentAlpha:1];

}

- (void)updateCurlDown
{
    [self updateComponentAlpha:0];
}

- (void)updateScaleFrame
{
    [self updateComponentAlpha:0];
    
    self.cardText.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.stopWatchView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.questionText.transform = CGAffineTransformMakeScale(0.2, 0.2);
}

- (void)updateDropFrame
{
    [self updateComponentAlpha:0];
    
    CGRect frame = self.cardText.frame;
    frame.origin.y -= self.cardView.frame.size.height;
    self.cardText.frame = frame;
    
    frame = self.stopWatchView.frame;
    frame.origin.y -= self.cardView.frame.size.height;
    self.stopWatchView.frame = frame;
    
    frame = self.questionText.frame;
    frame.origin.y -= self.cardView.frame.size.height;
    self.questionText.frame = frame;
    
}

- (void)updateComponentAlpha:(CGFloat)alpha
{
    self.cardText.alpha = alpha;
    self.stopWatchView.alpha = alpha;
    self.questionText.alpha = alpha;
    self.optionA.alpha = alpha;
    self.optionB.alpha = alpha;
    self.optionC.alpha = alpha;
}

- (BOOL)checkOptionsContainsPoint:(CGPoint)point
{
    BOOL flag = NO;
    
    CGRect rectA = [self.optionA convertRect:self.optionA.bounds toView:self];
    CGRect rectB = [self.optionB convertRect:self.optionB.bounds toView:self];
    CGRect rectC = [self.optionC convertRect:self.optionC.bounds toView:self];
    
    if( CGRectContainsPoint(rectA, point) )
    {
        flag = YES;
        [self showRippleLocation:point];
        [GCDTimer scheduledTimerWithTimeInterval:0.3f repeats:NO block:^{
            
            [self performSelector:@selector(touchClick:) withObject:self.optionA];
            
        }];
    }
    
    else if( CGRectContainsPoint(rectB, point) )
    {
        flag = YES;
        [self showRippleLocation:point];
        [GCDTimer scheduledTimerWithTimeInterval:0.3f repeats:NO block:^{
            
            [self performSelector:@selector(touchClick:) withObject:self.optionB];
            
        }];
    }
    
    else if( CGRectContainsPoint(rectC, point) )
    {
        flag = YES;
        [self showRippleLocation:point];
        
        [GCDTimer scheduledTimerWithTimeInterval:0.3f repeats:NO block:^{
            
            [self performSelector:@selector(touchClick:) withObject:self.optionC];
            
        }];
        
    }
    
    return flag;
}

- (void)showRippleLocation:(CGPoint)location
{
    CGFloat width = self.optionA.frame.size.width / 1.2;
    CPRippleView *rippleView = [[CPRippleView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self addSubview:rippleView];
    rippleView.center = location;
    rippleView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         rippleView.transform = CGAffineTransformMakeScale(1,1);
                         rippleView.alpha=0;
                         
                     } completion:^(BOOL finished) {
                         [rippleView removeFromSuperview];
                     }];

}

#pragma mark - touch event

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    
//    NSLog(@"location: %@", NSStringFromCGPoint(location));
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    [self checkOptionsContainsPoint:location];
}

- (void)touchClick:(id)sender
{
    if( self.startPlay )
    {
        if( [CPSettingData sharedInstance].effectSelected )
        {
            [[CPSoundManager sharedInstance] playEffect:kShotEffect vibrate:NO];
        }
        
        UIControl *control = (UIControl *)sender;
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(checkAnswerWithClickOption:)] )
        {
            [self.delegate checkAnswerWithClickOption:[self.question checkAnswer:control.tag - 1]];
        }
    }
}

#pragma mark - private method

- (void)startTimer
{
    self.startPlay = YES;
    
    weakify(self);
    [self.stopWatchView fireStopWatch:0.0f timeOut:^{

        strongify(self);
        self.startPlay = NO;
        if( self.delegate && [self.delegate respondsToSelector:@selector(timeout)] )
        {
            [self.delegate timeout];
        }
        
    }];
}
@end
