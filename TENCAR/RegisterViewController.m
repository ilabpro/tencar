//
//  RegisterViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 15.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "RegisterViewController.h"
#import "IHKeyboardAvoiding.h"


@interface RegisterViewController ()


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
   
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
     [IHKeyboardAvoiding setAvoidingView:self.scroll_reg];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (IBAction)try_confirm:(id)sender {
    [self performSegueWithIdentifier:@"go_confirm" sender:nil];
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
