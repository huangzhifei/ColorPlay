//
//  CPPageView.h
//  ColorPlay
//
//  Created by huangzhifei on 15/12/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

// 增加点击图片切换代理
@class CPPageView;

@protocol CPPageViewScrollDelegate <NSObject>

@optional
- (void)didClickPage:(CPPageView *)view atIndex:(NSInteger)index;

@end

// 性能优化，利用最多两个 UIImageView 来优化内存及显示
@interface CPPageView : UIView

@property (weak, nonatomic) id<CPPageViewScrollDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame page:(NSArray *)photos;

@end

