//
//  PanelsController.m
//  TENCAR
//
//  Created by ILAB PRO on 15.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "PanelsController.h"


@implementation PanelsController

-(void)awakeFromNib
{
    
    
    
   
    self.liveBlur = NO;
    self.blurTintColor = [UIColor colorWithRed:0.0f/255.0f green:183.0f/255.0f blue:245.0f/255.0f alpha:0.65f];
    
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    
    
    
}

@end
