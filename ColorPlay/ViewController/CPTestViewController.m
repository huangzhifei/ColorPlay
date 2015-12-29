//
//  CPTestViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/12/7.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPTestViewController.h"
#import "CPStarsOverlayView.h"

@interface CPTestViewController ()

@property (strong, nonatomic) CPStarsOverlayView *starOverlayView;

@end

@implementation CPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if( _starOverlayView )
    {
        _starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_starOverlayView];
        [self.view sendSubviewToBack:_starOverlayView];
    }
}

+ (instancetype)initWithNib
{
    //NSString *string = @"CPTestIconController";
    NSString *string1 = @"CPTestViewController";
    return [[CPTestViewController alloc] initWithNibName:string1 bundle:nil];
}

@end
