//
//  CPAnimation3DMenuView.m
//  ColorPlay
//
//  Created by huangzhifei on 15/10/21.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPAnimation3DMenuView.h"
#import "GCDTimer.h"

@interface CPAnimation3DItem()

@property (nonatomic) CGFloat currentAngle;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) CGFloat radius;

@end

@implementation CPAnimation3DItem

#pragma  mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.radius = 40;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.layer.borderWidth = 2.5f;
    
    self.layer.cornerRadius = self.radius;
    
    [self setClipsToBounds:YES];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    
    [self commonInit];
}

@end

/**
 *  swipe direction, left or right
 */
typedef NS_ENUM(NSInteger, Rotationdirection) {

    RotationSwipeLeft = 0,
    RotationSwipeRight,
    RotationdirectionCount
};

/**
 *  appearance direction
 */
typedef NS_ENUM(NSInteger, Raisedirection) {

    RaiseFromBottom = 0,
    RaiseFromRight,
    RaiseFromLeft,
    RaisedirectionCount
};

@interface CPAnimation3DMenuView()

@property (strong, nonatomic) NSArray *scaleArray;
@property (strong, nonatomic) NSArray *itemsArray;
@property (strong, nonatomic) NSArray *itemsCenterArray;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGPoint circleCenter;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL animationFinished;

@end

const NSInteger itemTag = 1000;

@implementation CPAnimation3DMenuView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
                   itemsArray:(NSArray *)array
                       radius:(CGFloat)radius
                     duration:(CGFloat)duration
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        self.itemsArray = array;
        self.radius = radius;
        self.duration = duration;
        self.animationFinished = NO;
        [self commonInitScale];
        [self commonInitCenter];
    }
    
    return self;
}

- (void)commonInitScale
{
    NSInteger itemsCount = [self.itemsArray count];

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:itemsCount];
    for(int index = 0; index < itemsCount; ++ index)
    {
        CGFloat scale = fabs(index - itemsCount*1.0/2);
        for(int j = 0; j < itemsCount; ++ j)
        {
            CGFloat target = fabs(j - itemsCount*1.0/2);
            if( target == scale )
            {
                CGFloat obj = powf(0.7, j*1.0);
                [array addObject:@(obj)];
                break;
            }
        }
    }
    self.scaleArray = [[NSArray alloc] initWithArray:array];
    
}

- (void)commonInitCenter
{
    NSInteger itemsCount = [self.itemsArray count];
    self.circleCenter = CGPointMake(self.center.x, self.center.y - 20);
    CGFloat originStartAngle = M_PI / 2;
    CGFloat averageAngle = M_PI * 2 / itemsCount;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:itemsCount];
    
//    CAShapeLayer *circle = [CAShapeLayer layer];
//    circle.fillColor = [UIColor clearColor].CGColor;
//    circle.strokeColor = [UIColor grayColor].CGColor;
//    circle.lineWidth = 2.0;
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter
//                                                        radius:90
//                                                    startAngle:0
//                                                      endAngle:M_PI * 2
//                                                     clockwise:YES];
//    circle.path          = path.CGPath;

//    [self.layer addSublayer:circle];
    
    for(NSInteger index = 0; index < itemsCount; ++index)
    {
        //正余弦求item中心点到圆中心点距离
        CGFloat dx = sin(averageAngle * index) * self.radius;
        CGFloat dy = cos(averageAngle * index) * self.radius;
        
        CGPoint itemPoint = CGPointMake(self.circleCenter.x - dx, self.circleCenter.y + dy);
        [array addObject:[NSValue valueWithCGPoint:itemPoint]];
        
        CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
        [item setBounds:CGRectMake(0, 0, self.radius-10, self.radius-10)];
        item.currentIndex = index;
        item.tag = itemTag + index;
        
        CGFloat endAngle = originStartAngle + index * 1.0 / itemsCount * M_PI * 2.0;
        item.currentAngle = endAngle;
        item.center = [array[0] CGPointValue];
        item.alpha = 0;
        
        [self addSubview:item];
        
        
    }
    self.itemsCenterArray = [[NSArray alloc] initWithArray:array];
    
    [GCDTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^{
       
        [self performMyAnimation: arc4random_uniform(RaisedirectionCount)];
        
    }];
}

- (void)updateItemsAlpha:(CGFloat)alpha
{
    for(int index = 0; index < self.itemsArray.count; ++ index)
    {
        CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
        item.alpha = alpha;
    }
}

#pragma mark - animation

- (void)performMyAnimation:(Raisedirection)direction
{
    self.currentIndex = 0;

    [self updateItemsFrame:direction];
    
    // raise
    [self startRaiseAnimation:direction];
    
}

- (void)updateItemsFrame:(Raisedirection)direction
{
    [self updateItemsAlpha:0];
    for(NSInteger index=0; index < self.itemsArray.count; ++ index)
    {
        switch (direction)
        {
            case RaiseFromBottom:
            {
                CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
                CGRect frame = item.frame;
                frame.origin.y += self.bounds.size.height;
                item.frame = frame;
            }
                break;
            
            case RaiseFromLeft:
            {
                CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
                CGRect frame = item.frame;
                frame.origin.x -= self.bounds.size.width;
                item.frame = frame;
            }
                break;
                
//            case RaiseFromTop:
//            {
//                CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
//                CGRect frame = item.frame;
//                frame.origin.y -= self.bounds.size.height;
//                item.frame = frame;
//            }
//                break;
                
            case RaiseFromRight:
            {
                CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
                CGRect frame = item.frame;
                frame.origin.x += self.bounds.size.width;
                item.frame = frame;
            }
                break;
                
            default:
                break;
        }
    }
    
    [self updateItemsAlpha:1];
}

- (void)startRaiseAnimation:(Raisedirection)direction
{
    if( self.currentIndex >= self.itemsArray.count)
    {
        self.currentIndex = 0;
        
        // rotate
        [self startRotateAnimation];
        
        return;
    }
    
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         switch (direction)
                         {
                             case RaiseFromBottom:
                             {
                                 CPAnimation3DItem *item = [self.itemsArray objectAtIndex:self.currentIndex];
                                 CGRect frame = item.frame;
                                 frame.origin.y -= self.bounds.size.height;
                                 item.frame = frame;
                             }
                                 break;
                                 
                             case RaiseFromLeft:
                             {
                                 CPAnimation3DItem *item = [self.itemsArray objectAtIndex:self.currentIndex];
                                 CGRect frame = item.frame;
                                 frame.origin.x += self.bounds.size.width;
                                 item.frame = frame;
                             }
                                 break;
                                 
                                 //                             case RaiseFromTop:
                                 //                             {
                                 //                                 CPAnimation3DItem *item = [self.itemsArray objectAtIndex:self.currentIndex];
                                 //                                 CGRect frame = item.frame;
                                 //                                 frame.origin.y += self.bounds.size.height;
                                 //                                 item.frame = frame;
                                 //                             }
                                 //                                 break;
                                 
                             case RaiseFromRight:
                             {
                                 CPAnimation3DItem *item = [self.itemsArray objectAtIndex:self.currentIndex];
                                 CGRect frame = item.frame;
                                 frame.origin.x -= self.bounds.size.width;
                                 item.frame = frame;
                             }
                                 break;
                                 
                             default:
                                 break;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         self.currentIndex ++;
                         
                         [self startRaiseAnimation:direction];
                         
                     }];
    
}

- (void)startRotateAnimation
{
    if(self.currentIndex >= self.itemsArray.count)
    {
        self.currentIndex = 0;
        
        // scale
        [self startScaleAnimation];
        
        return;
    }
    
    CGFloat originStartAngle = M_PI / 2;
    CGFloat averageAngle = M_PI * 2.0 / self.itemsArray.count;
    for(NSInteger startIndex = self.currentIndex+1; startIndex < self.itemsArray.count; ++ startIndex)
    {
        CPAnimation3DItem *item = [self.itemsArray objectAtIndex:startIndex];
        
        //每个menu都需要移动的位置个数
        NSInteger moveCount = 1;
        
        //menu移动的弧形路径
        CGMutablePathRef arcPath = CGPathCreateMutable();
        
        CGFloat startAngle = originStartAngle + averageAngle * self.currentIndex;
        
        //结束角度
        CGFloat endAngle = startAngle + averageAngle * moveCount;
        CGPathAddArc(arcPath, nil, self.circleCenter.x, self.circleCenter.y, self.radius, startAngle,
                     endAngle, NO);
        
        //更改menu坐标，通过center数组和currentIndex来更新
        NSInteger nextIndex = self.currentIndex+1;
        item.center = [self.itemsCenterArray[nextIndex] CGPointValue];
        
        //menu弧形移动动画
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = arcPath;
        positionAnimation.calculationMode = @"paced";
        positionAnimation.repeatCount = 1;
        
        //menu缩放动画, 注意要使用bounds， 不能使用frame
        CGRect bound = item.bounds;
        bound.size = CGSizeMake(item.radius*2, item.radius*2);
        item.bounds = bound;
        
        //动画组
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[positionAnimation];
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        animationGroup.duration = 0.25;
        animationGroup.autoreverses = NO;
        [item.layer addAnimation:animationGroup forKey:@"animationGroup"];
        
        item.currentAngle = endAngle;
        
    }
    
    self.currentIndex++;
    
    //增加连贯性
    if(self.currentIndex >= self.itemsArray.count)
    {
        [self startRotateAnimation];
        
        return;
    }
    
    [GCDTimer scheduledTimerWithTimeInterval:0.25 repeats:NO block:^{
        
        [self startRotateAnimation];
        
    }];
}

- (void)startScaleAnimation
{
    if( self.currentIndex >= self.itemsArray.count )
    {
        self.currentIndex = 0;
        
        self.animationFinished = YES;
        
        [self addSwipeGesture];
        
        return;
    }
    
    CPAnimation3DItem *item = [self.itemsArray objectAtIndex:self.currentIndex];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.fromValue = self.scaleArray[0];
    scaleAnimation.toValue = self.scaleArray[item.currentIndex];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.duration = 0.1;
    
    [item.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
    
    self.currentIndex++;
    
    [GCDTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^{
        
        [self startScaleAnimation];
        
    }];
}

#pragma mark - gesture

- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipeGestureToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(swipeNext:)];
    swipeGestureToLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGestureToLeft];
    
    UISwipeGestureRecognizer *swipeGestureToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeNext:)];
    swipeGestureToRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGestureToRight];
    
    [self updateItemUserInteractionEnabled];
}

- (void) swipeNext:(UISwipeGestureRecognizer *)gesture
{    
    Rotationdirection direction = RotationSwipeLeft;
    
    if( gesture.direction == UISwipeGestureRecognizerDirectionRight )
    {
        direction = RotationSwipeRight;
    }

    [self performMoveAndScaleAnimation:0 direction:direction];
    
}

# pragma mark - rotate&scale
- (void)performMoveAndScaleAnimation:(NSInteger)index direction:(Rotationdirection)direction
{
    CGFloat averageAngle = M_PI * 2.0 / self.itemsArray.count;

    for(NSInteger startIndex = 0; startIndex < self.itemsArray.count; ++ startIndex)
    {
        CPAnimation3DItem *item = [self.itemsArray objectAtIndex:startIndex];
        
        NSInteger moveCount = 1 * direction == RotationSwipeLeft ? 1 : -1 ;
        
        CGMutablePathRef arcPath = CGPathCreateMutable();

        CGFloat endAngle = item.currentAngle + averageAngle * moveCount;
        
        switch(direction)
        {
            case RotationSwipeRight:
            {
                // YES 顺时针
                CGPathAddArc(arcPath, nil, self.circleCenter.x, self.circleCenter.y, self.radius, item.currentAngle,
                             endAngle, YES);
            }
                break;
                
            case RotationSwipeLeft:
            {
                // NO 顺时针
                CGPathAddArc(arcPath, nil, self.circleCenter.x, self.circleCenter.y, self.radius, item.currentAngle,
                             endAngle, NO);
            }
                break;
                
            default:
                break;
                
        }

        NSInteger nextIndex = (item.currentIndex+moveCount+self.itemsArray.count)%self.itemsArray.count;
        item.center = [self.itemsCenterArray[nextIndex] CGPointValue];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = arcPath;
        positionAnimation.calculationMode = @"paced";
        positionAnimation.repeatCount = 1;
        
        CGRect bound = item.bounds;
        bound.size = CGSizeMake(item.radius*2, item.radius*2);
        item.bounds = bound;
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = self.scaleArray[item.currentIndex];
        scaleAnimation.toValue = self.scaleArray[nextIndex];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[positionAnimation, scaleAnimation];
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        animationGroup.duration = self.duration/2;
        animationGroup.autoreverses = NO;
        [item.layer addAnimation:animationGroup forKey:@"animationGroup"];
        
        item.currentIndex = nextIndex;
        item.currentAngle = endAngle;
    }
    
    [self updateItemUserInteractionEnabled];
}

# pragma mark - private method
- (void)updateItemUserInteractionEnabled
{
    for(NSInteger index = 0; index < self.itemsArray.count; ++ index)
    {
        CPAnimation3DItem *item = [self.itemsArray objectAtIndex:index];
        
        if( item.currentIndex == 0 && self.animationFinished )
        {
            [item setUserInteractionEnabled:YES];
        }
        else
        {
            [item setUserInteractionEnabled:NO];
        }
    }
}

@end
