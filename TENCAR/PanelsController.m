//
//  PanelsController.m
//  TENCAR
//
//  Created by ILAB PRO on 15.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "PanelsController.h"
#import "AppDelegate.h"

@implementation PanelsController

-(void)awakeFromNib
{
    
    
    
    //AppDelegate *AppDelegate = [UIApplication sharedApplication].delegate;
    
    //UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   // PanelsController *newRootViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RootViewController"];
   
    //AppDelegate.window.rootViewController = self;
    //[AppDelegate.window makeKeyAndVisible];
    
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
   [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
  //[self setCenterPanel:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]]];
    
    self.leftFixedWidth = 220;
    
    
}
-(void)stylePanel:(UIView *)panel
{
   //чтобы углы не загруглялись у центральной панели во время открытого меню
}
@end
