//
//  dashboardViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 20.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "dashboardViewController.h"
#import "PanelsController.h"
#import "UIViewController+JASidePanel.h"
#import "UIBarButtonItem+Badge.h"

@interface dashboardViewController ()

@end

@implementation dashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:NSLocalizedStringFromTable(@"Dashboard", @"Main", nil)];

   
        UIImage* image = [UIImage imageNamed:@"right_but_sidebar"];
        CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self.sidePanelController action:@selector(toggleRightPanel:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem.badgeValue = @"0";
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(incrementBadge:)
                                   userInfo:nil
                                    repeats:YES];
    
}
-(void)incrementBadge:(id)sender
{
    NSInteger val = [self.navigationItem.rightBarButtonItem.badgeValue integerValue];
    val++;
    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%ld",val%150];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
