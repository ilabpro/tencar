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
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 125; i++) {
        if(i>99)
        {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"TenCar_animation40%i", i]]];
        }
        else if(i>9)
        {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"TenCar_animation400%i", i]]];
        }
        else
        {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"TenCar_animation4000%i", i]]];
        }
        
    }
    
    /*
    self.test.image = [UIImage animatedImageWithImages:images duration:2.0f];
   */
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"goHome" sender:self];
    });
    
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
