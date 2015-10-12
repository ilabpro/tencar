//
//  ViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 13.07.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, retain) IBOutlet UIImageView *test;

@end

@implementation ViewController

@synthesize test;

int n=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    //[UIImage animatedImageNamed:@"tencar_logo_loader0" duration:10.0f];
    //imgView.contentMode = UIViewContentModeCenter;
    
    //[self.view addSubview:imgView];
   /*
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
    
    */
    
   /*
   
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.04
                                                      target:self
                                                    selector:@selector(tiktak)
                                                    userInfo:nil repeats:YES];
    
    */
    
   
    //[self performSegueWithIdentifier:@"goHome" sender:self];
   
    /*
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"goHome" sender:self];
        
    });
    */
   
   
   
}
-(void)tiktak {
    n++;
    
    if(n>9)
    {
        test.image = [UIImage imageNamed:
                      [NSString stringWithFormat:@"TenCar_animation400%i.png", n]];
    }
    else
    {
        test.image = [UIImage imageNamed:
                      [NSString stringWithFormat:@"TenCar_animation4000%i.png", n]];
    }
    if(n == 64) n = 0;
}

/*

- (NSArray*)creatAnimation:(NSString*)fileName {
  
    UIImage *image = [UIImage imageNamed:fileName];
    NSMutableArray *animationImages = [NSMutableArray array];
    
    int i_current = 0;
    int i_have_frames = 125;
    for (int i2 = 0; i2<11; i2++) {
        
        for (int i = 0; i<12; i++) {
            i_current++;
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,
                                                               CGRectMake(i*300.0f, i2*300.0f, 300.0f, 300.0f));
            UIImage *animationImage = [UIImage imageWithCGImage:imageRef];
            [animationImages addObject:animationImage];
            CGImageRelease(imageRef);
            if(i_have_frames==i_current) break;
        }
        
    }
   
    
    return animationImages;

}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

@end
