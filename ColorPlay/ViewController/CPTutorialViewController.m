//
//  CPTutorialViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPTutorialViewController.h"
#import "CPStarsOverlayView.h"
#import "CPPageData.h"
#import "CPPageView.h"

@interface CPTutorialViewController ()

- (IBAction)back:(id)sender;

@property (strong, nonatomic) CPStarsOverlayView        *starOverlayView;
@property (strong, nonatomic) CPPageView                *pageView;
@property (strong, nonatomic) CPPageData                *page;

@end

@implementation CPTutorialViewController

#pragma mark - init

+ (instancetype)initWithNib
{
    return [[CPTutorialViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _page = [[CPPageData alloc] init];
    
    NSLog(@"%@", _page.photos);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [super viewDidLayoutSubviews];
    
    [self.view layoutIfNeeded];
    
    if( _starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
    
    if( !_pageView )
    {
        _pageView = [[CPPageView alloc] initWithFrame:self.view.frame page:self.page.photos];
        [self.view addSubview:_pageView];
        [self.view sendSubviewToBack:_pageView];
    }
}

#pragma mark - IB

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
