//
//  CPAboutViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPAboutViewController.h"
#import "GCDTimer.h"
#import "ZCFallLabel.h"
#import "CPStarsOverlayView.h"

@interface CPAboutViewController ()

@property (weak, nonatomic) IBOutlet UIView             *effectView;
@property (weak, nonatomic) IBOutlet UIButton           *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView       *scrollView;

@property (strong, nonatomic) GCDTimer                  *scrollGCDTimer;
@property (strong, nonatomic) ZCFallLabel               *fallLabel;
@property (strong, nonatomic) NSString                  *showData;
@property (assign, nonatomic) CGFloat                   scrollOrignalHeight;
@property (strong, nonatomic) CPStarsOverlayView        *starOverlayView;

- (IBAction)backClick:(id)sender;

/**
 http://natashatherobot.com/ios-autolayout-scrollview/
 https://grayluo.github.io/WeiFocusIo/autolayout/2015/01/27/autolayout3/
 使用autolayout创建UIScrollview
 */
@end

@implementation CPAboutViewController

#pragma mark - init

+ (instancetype)initWithNib
{
    return [[CPAboutViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.showData = ({
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutContent" ofType:@".plist"];
    
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
        NSDictionary *dict = [array firstObject];
        
        NSString *data = [dict objectForKey:@"value"];
        
        NSLog(@"data: %@", data);
        
        data;
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.starOverlayView )
    {
        [self.starOverlayView restartFireWork];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if( self.starOverlayView )
    {
        [self.starOverlayView stopFireWork];
    }
}

- (void)viewDidLayoutSubviews
{
    /**
     *  UIVIewController.viewDidLayoutSubviews这个方法是在所管理的UIView布局完后就调用了，
     *  但是这时候UIView里的SubView的并还没有布局好！！！fuck
     *  http://weiqingfei.iteye.com/blog/2214974
     */
    [self.view layoutIfNeeded];
    
    if( !_starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
    
    if( !_fallLabel )
    {
        [self.effectView addSubview:self.fallLabel];
        
        [GCDTimer scheduledTimerWithTimeInterval:0.5f repeats:NO block:^{
            
            [self startShowData];
            
            self.scrollGCDTimer = [GCDTimer scheduledTimerWithTimeInterval:self.fallLabel.animationDuration
                                                                   repeats:YES
                                                                     block:^{
                                                                         
                                                                         [self currentCursorWithFallLabel];
                                                                         
                                                                     }];
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZCFallLabel *)fallLabel
{
    if( !_fallLabel )
    {
        //NSLog(@"3: effectView %@", NSStringFromCGRect(self.effectView.frame));
        
        _fallLabel = ({
            
            CGFloat width = self.effectView.bounds.size.width - 0;
            CGFloat height = self.effectView.bounds.size.height - 0;
            self.scrollOrignalHeight = height;
            
            ZCFallLabel *label = [[ZCFallLabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            label.animationDuration = 0.5;
            
            label;
        });
    }
    
    return _fallLabel;
}

#pragma mark - private method

- (void)startShowData
{
    //NSLog(@"2: effectView %@", NSStringFromCGRect(self.effectView.frame));
    
    /**
     *  一个小bug，不能提前设置好内容，必须在设置完内容后，立即调用
     *  startAppearAnimation
     */
    self.fallLabel.text = self.showData;

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *fontAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                     NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor colorWithRed:1.0f green:1.0f blue:1 alpha:1.0f]};
    
    NSMutableAttributedString *mutableString = [[[NSAttributedString alloc] initWithString:self.fallLabel.text
                                                                               attributes: fontAttributes] mutableCopy];
    //self.fallLabel.layoutTool.groupType = ZCLayoutGroupWord;
    self.fallLabel.attributedString = mutableString;
    [self.fallLabel sizeToFit];
    
    [self.fallLabel startAppearAnimation];
}

- (void)currentCursorWithFallLabel
{
    static CGFloat lastOffsetY = 0;
    if( !self.fallLabel.isFinished )
    {
        CGFloat offsetY = self.fallLabel.currentCursorY;
        
        if( offsetY == lastOffsetY ) return;
        
        lastOffsetY = offsetY;
        
        if( offsetY > self.scrollOrignalHeight / 1.3 )
        {
            //NSLog(@"%f", offsetY);
            
            CGPoint newOffset = self.scrollView.contentOffset;
            
            newOffset.y += 25;
            
            self.scrollView.contentOffset = newOffset;
            
            self.scrollContainerViewHeightConstraint.constant = offsetY;
        }
    }
    else
    {
        lastOffsetY = 0;
        [self.scrollGCDTimer invalidate];
    }
}

#pragma mark - IB

- (IBAction)backClick:(id)sender {
    
    [self.scrollGCDTimer invalidate];
        
    [self.navigationController popViewControllerAnimated:YES];
}

@end
