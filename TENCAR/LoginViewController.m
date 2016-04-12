//
//  LoginViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 13.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "LoginViewController.h"
#import <SCLAlertView.h>
#import <SimpleKeychain/SimpleKeychain.h>
#import "Application.h"
#import <Lock/Lock.h>
#import <JWTDecode/A0JWTDecoder.h>
#import "JVFloatLabeledTextField.h"
#import <A0FacebookAuthenticator.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *precache_webview;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *login_inp;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *password_inp;

@end

@implementation LoginViewController
@synthesize precache_webview;


SCLAlertView *alert;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    A0SimpleKeychain *store = [Application sharedInstance].store;
    
    
    
    
    NSString *idToken = [store stringForKey:@"id_token"];
    if (idToken) {
        if ([A0JWTDecoder isJWTExpired:idToken]) {
            NSString *refreshToken = [store stringForKey:@"refresh_token"];
            
            alert = [[SCLAlertView alloc] initWithNewWindow];
            alert.backgroundType = Blur;
            alert.customViewColor = [UIColor colorWithRed:0.0f/255.0f green:183.0f/255.0f blue:245.0f/255.0f alpha:0.65f];
            [alert showWaiting:self title:@"Авторизация..." subTitle:@"" closeButtonTitle:nil duration:0.0f];
            
            A0APIClient *client = [[[Application sharedInstance] lock] apiClient];
            [client fetchNewIdTokenWithRefreshToken:refreshToken parameters:nil success:^(A0Token *token) {
                [store setString:token.idToken forKey:@"id_token"];
                [alert hideView];
                [self performSegueWithIdentifier:@"go_dasboard" sender:nil];
            } failure:^(NSError *error) {
                [store clearAll];
                [alert hideView];
            }];
        } else {
            [self performSegueWithIdentifier:@"go_dasboard" sender:nil];
        }
    }
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
   
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"privacy"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [precache_webview loadRequest:request];
    

}
- (IBAction)loginSocialVK:(id)sender {
    
    alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = Blur;
    alert.customViewColor = [UIColor colorWithRed:0.0f/255.0f green:183.0f/255.0f blue:245.0f/255.0f alpha:0.65f];
    
    [alert showWaiting:self title:@"Авторизация..." subTitle:@"" closeButtonTitle:nil duration:0.0f];
    
    
    A0Lock *lock = [[Application sharedInstance] lock];
    A0AuthParameters *parameters = [A0AuthParameters newDefaultParams];
    
    
    
    
    
    
    [lock.identityProviderAuthenticator authenticateWithConnectionName:@"vkontakte" parameters:parameters success:^(A0UserProfile *profile, A0Token *token){
        
        A0SimpleKeychain *keychain = [Application sharedInstance].store;
        [keychain setString:token.idToken forKey:@"id_token"];
        [keychain setString:token.refreshToken forKey:@"refresh_token"];
        [keychain setData:[NSKeyedArchiver archivedDataWithRootObject:profile] forKey:@"profile"];
        [alert hideView];
        [self performSegueWithIdentifier:@"go_dasboard" sender:nil];
    } failure:^(NSError *error){
       
        [alert hideView];
        alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.backgroundType = Blur;
        [alert showError:@"Ошибка" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
    }];
}
- (IBAction)loginSocial:(id)sender {
    
    
    alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = Blur;
    alert.customViewColor = [UIColor colorWithRed:0.0f/255.0f green:183.0f/255.0f blue:245.0f/255.0f alpha:0.65f];
    
    [alert showWaiting:self title:@"Авторизация..." subTitle:@"" closeButtonTitle:nil duration:0.0f];
    
    
    A0Lock *lock = [[Application sharedInstance] lock];
    A0AuthParameters *parameters = [A0AuthParameters newDefaultParams];
    
    
    
    [lock.identityProviderAuthenticator authenticateWithConnectionName:@"facebook" parameters:parameters success:^(A0UserProfile *profile, A0Token *token){
        A0SimpleKeychain *keychain = [Application sharedInstance].store;
        
        [keychain setString:token.idToken forKey:@"id_token"];
        [keychain setString:token.refreshToken forKey:@"refresh_token"];
        [keychain setData:[NSKeyedArchiver archivedDataWithRootObject:profile] forKey:@"profile"];
        [alert hideView];
        [self performSegueWithIdentifier:@"go_dasboard" sender:nil];
    } failure:^(NSError *error){
       
        [alert hideView];
        alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.backgroundType = Blur;
        [alert showError:@"Ошибка" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
    }];
    
   
    
   
    
}
- (IBAction)tryLogin:(id)sender {
   
    
    //
    alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.backgroundType = Blur;
    alert.customViewColor = [UIColor colorWithRed:0.0f/255.0f green:183.0f/255.0f blue:245.0f/255.0f alpha:0.65f];
    
    [alert showWaiting:self title:@"Авторизация..." subTitle:@"" closeButtonTitle:nil duration:0.0f];
    NSString *email = _login_inp.text;
    NSString *password = _password_inp.text;
   
    
    A0Lock *lock = [[Application sharedInstance] lock]; // Get your Lock instance
    A0APIClient *client = [lock apiClient];
    
    
    A0APIClientAuthenticationSuccess success = ^(A0UserProfile *profile, A0Token *token) {
        //NSLog(@"%@ ------ %@", token.idToken, token.refreshToken);
        
        A0SimpleKeychain *keychain = [Application sharedInstance].store;
        [keychain setString:token.idToken forKey:@"id_token"];
        [keychain setString:token.refreshToken forKey:@"refresh_token"];
        [keychain setData:[NSKeyedArchiver archivedDataWithRootObject:profile] forKey:@"profile"];
        [alert hideView];
        [self performSegueWithIdentifier:@"go_dasboard" sender:nil];
    };
    A0APIClientError error = ^(NSError *error){
        //NSLog(@"Oops something went wrong: %@", error.localizedDescription);
        [alert hideView];
        alert = [[SCLAlertView alloc] initWithNewWindow];
        alert.backgroundType = Blur;
        [alert showError:@"Ошибка" subTitle:error.localizedDescription closeButtonTitle:@"OK" duration:0.0f];
        
    };
    
    A0AuthParameters *params = [A0AuthParameters newDefaultParams];
    
    params[A0ParameterConnection] = @"Username-Password-Authentication"; // Or your configured DB connection
    [client loginWithUsername:email
                     password:password
                   parameters:params
                      success:success
                      failure:error];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
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
       
        [textField resignFirstResponder];
        [self tryLogin:nil];
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
