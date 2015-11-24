//
//  CPGameCardView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameCardView.h"

@interface CPGameCardView()

@property (weak, nonatomic) IBOutlet UILabel *cardTextLabel;
@property (strong, nonatomic) CPGameCard *card;

@end

@implementation CPGameCardView

#pragma mark - init

+ (instancetype)loadDIYNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (instancetype)initWithFrame:(CGRect)frame card:(CPGameCard *)card
{
    self = [CPGameCardView loadDIYNib];

    if( self )
    {
        [self setFrame:frame];
        
        self.card = card;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [self setBackgroundColor:self.card.bgColor.color];
    [self.cardTextLabel setText:self.card.textMeaningColor.colorName];
    [self.cardTextLabel setTextColor:self.card.textColor.color];
    
}

@end
