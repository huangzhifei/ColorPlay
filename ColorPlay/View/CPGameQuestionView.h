//
//  CPGameQuestionView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/11/12.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPGameQuestion.h"
#import "CPMacro.h"

@protocol CPGameQuestionViewDelegate <NSObject>

@required

- (void)timeout;

- (void)checkAnswerWithClickOption:(BOOL)right;

@end

@interface CPGameQuestionView : UIView

@property (weak, nonatomic) id<CPGameQuestionViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame question:(CPGameQuestion *)question gameMode:(CPGameMode)mode;

@end
