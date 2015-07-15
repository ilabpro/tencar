//
//  ViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 13.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *test;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    //[UIImage animatedImageNamed:@"tencar_logo_loader0" duration:10.0f];
    //imgView.contentMode = UIViewContentModeCenter;
    
    //[self.view addSubview:imgView];
    self.test.image = [UIImage animatedImageNamed:@"tencar_logo_loader" duration:2.0f];
   
    
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
