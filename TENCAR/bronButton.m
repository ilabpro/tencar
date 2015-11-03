//
//  bronButton.m
//  TENCAR
//
//  Created by ILAB PRO on 03.11.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "bronButton.h"
#import <QuartzCore/QuartzCore.h>
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation bronButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
        // Do custom drawing for normal state
        self.layer.borderColor = UIColorFromRGB(0xFF8000).CGColor;
        
        self.layer.borderWidth = 1.0;
        
        self.layer.cornerRadius = 5;
    
    
    
}

@end
