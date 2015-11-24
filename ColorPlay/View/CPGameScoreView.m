//
//  CPGameScoreView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/23.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameScoreView.h"

@interface CPGameScoreView()

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scoreImage;

@property (nonatomic) CPGameMode mode;
@property (nonatomic) NSInteger score;

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
        
        //[self layoutIfNeeded];
        
        self.mode = mode;
        self.score = score;
        
        self.modeLabel.text = [self stringFromMode:mode];
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld", score];
    }
    
    return self;
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

@end
