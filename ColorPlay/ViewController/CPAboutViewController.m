//
//  CPAboutViewController.m
//  ColorPlay
//
//  Created by huangzhifei on 15/11/10.
//  Copyright © 2015年 huangzhifei. All rights reserved.
//

#import "CPAboutViewController.h"
#import "GCDTimer.h"

@interface CPAboutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) GCDTimer *gcdTimer;

- (IBAction)backClick:(id)sender;

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
    
    //[self.backButton setBounds:CGRectMake(20, 30, 60, 35)];
    
    CATransform3D scale = CATransform3DIdentity;
    
    self.backButton.layer.transform = CATransform3DScale(scale, 1.25, 1.0, 1.0);
    
//    self.gcdTimer = [GCDTimer scheduledTimerWithTimeInterval:1.5F repeats:YES block:^{
//        
//        [self backAnimations];
//        
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)backAnimations
{
    //self.backButton.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.25, 1.0, 1.0);
    
    [UIView animateWithDuration:1.0f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.backButton.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.25, 1.0, 1.0);
                         
                     } completion:^(BOOL finished) {
                         
                         self.backButton.layer.transform = CATransform3DIdentity;
                         
                         
                     }];
    
    NSLog(@"3 %@", self.backButton);
}

#pragma mark - IB

- (IBAction)backClick:(id)sender {
    
    [self.gcdTimer invalidate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
