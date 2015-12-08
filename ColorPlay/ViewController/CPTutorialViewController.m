//
//  CPTutorialViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPTutorialViewController.h"
#import "CPStarsOverlayView.h"

@interface CPTutorialViewController ()

- (IBAction)back:(id)sender;

@property (strong, nonatomic) CPStarsOverlayView        *starOverlayView;

@end

@implementation CPTutorialViewController

+ (instancetype)initWithNib
{
    return [[CPTutorialViewController alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    if( !_starOverlayView )
    {
        self.starOverlayView = [[CPStarsOverlayView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.starOverlayView];
        [self.view sendSubviewToBack:self.starOverlayView];
    }
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
