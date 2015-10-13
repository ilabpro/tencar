//
//  LoginViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 13.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
    //[self registerForKeyboardNotifications];

}
- (IBAction)tryLogin:(id)sender {
    NSLog(@"try to login");
}
- (IBAction)tryRegister:(id)sender {
    NSLog(@"try to register");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    if(nextTag==2)
    {
        NSLog(@"try to login");
        [textField resignFirstResponder];
        return NO;
    }
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
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
