//
//  PrivacyViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 14.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *agree_privacyButton;
@property (weak, nonatomic) IBOutlet UIWebView *m_webView;

@end
int agree_privacySelected;

@implementation PrivacyViewController
@synthesize agree_privacyButton;
@synthesize m_webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    agree_privacySelected = 0;
    
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"privacy"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [m_webView loadRequest:request];
   
    
    
}

- (IBAction)agree_privacy_touch:(id)sender {
    if (agree_privacySelected == 0){
        [agree_privacyButton setSelected:YES];
        agree_privacySelected = 1;
    } else {
        [agree_privacyButton setSelected:NO];
        agree_privacySelected = 0;
    };
}
- (IBAction)next_screen:(id)sender {
    [self performSegueWithIdentifier:@"go_check_reginfo" sender:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
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
