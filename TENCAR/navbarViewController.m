//
//  navbarViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 19.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "navbarViewController.h"

@interface navbarViewController ()

@end

@implementation navbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
