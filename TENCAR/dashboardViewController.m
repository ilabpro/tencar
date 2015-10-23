//
//  dashboardViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 19.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "dashboardViewController.h"
#import "IHKeyboardAvoiding.h"
#import "JVFloatLabeledTextField.h"

@interface dashboardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_elem;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstDateField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *secondDateField;

@end

@implementation dashboardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
    
    //[_firstDateField addTarget:self action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    //[_secondDateField addTarget:self action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [IHKeyboardAvoiding setAvoidingView:self.scroll_elem];
    
    
   
    //dispatch_time_t delay = dispatch_time( DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC );
    //dispatch_after( delay, dispatch_get_main_queue(), ^{
        [self.frostedViewController presentMenuViewControllerNoAnimation];
        [self.frostedViewController hideMenuViewController];
    self.frostedViewController.panGestureEnabled = YES;
  

        
    //});
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if(textField.tag==1)
    {
        [self performSegueWithIdentifier:@"set_date" sender:nil];
        return NO;
    }
    else if (textField.tag==2)
    {
        [self performSegueWithIdentifier:@"set_date" sender:nil];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (IBAction)showMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
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
