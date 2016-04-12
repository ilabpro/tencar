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

NSURLConnection *connpasscode;
NSURLConnection *connaddr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
   
    
    
    
}
- (IBAction)passcodequery:(id)sender {
   
    
    NSString *post = [NSString stringWithFormat:@"passcode=%@",self.passcode.text];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://tencar.ru/getpassissued.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    connpasscode = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connpasscode) {
        //NSLog(@"Connection Successful");
    } else {
        //NSLog(@"Connection could not be made");
    }
    
    
    
}
- (IBAction)addrendedit:(id)sender {
    
    NSString *post = [NSString stringWithFormat:@"addr=%@",self.addr.text];
    NSLog(@"%@", self.addr.text);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://tencar.ru/DadataClient.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    connaddr = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connaddr) {
        //NSLog(@"Connection Successful");
    } else {
        //NSLog(@"Connection could not be made");
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    if(connection==connpasscode)
    {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.passissued.text = responseString;
    }
    if(connection==connaddr)
    {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        self.addr.text = responseString;
    }
    
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
