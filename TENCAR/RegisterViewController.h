//
//  RegisterViewController.h
//  TENCAR
//
//  Created by ILAB PRO on 15.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_reg;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passcode;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passissued;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *addr;

@end
