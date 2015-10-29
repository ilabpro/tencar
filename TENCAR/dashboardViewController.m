//
//  dashboardViewController.m
//  TENCAR
//
//  Created by ILAB PRO on 19.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "dashboardViewController.h"
#import "IHKeyboardAvoiding.h"
#import "JVFloatLabeledTextField.h"


@interface dashboardViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_elem;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstDateField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *secondDateField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *cityInput;



@end

@implementation dashboardViewController

@synthesize locationManager;
@synthesize currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGestureRecognizer *tapper1 = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(handleSingleTap:)];
    tapper1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper1];
    
    //[_firstDateField addTarget:self action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    //[_secondDateField addTarget:self action:@selector(textFieldShouldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    
    
    
    
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [IHKeyboardAvoiding setAvoidingView:self.scroll_elem];
    
    
   
    //dispatch_time_t delay = dispatch_time( DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC );
    //dispatch_after( delay, dispatch_get_main_queue(), ^{
        [self.frostedViewController presentMenuViewControllerNoAnimation];
        [self.frostedViewController hideMenuViewController];
    self.frostedViewController.panGestureEnabled = YES;
  

        
    //});
    
    
}
#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
   // NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       //NSLog(@"Postal code %@",placemark.postalCode);
                       _cityInput.text = placemark.locality;
                      
                       
                   }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==0)
    {
        [self performSegueWithIdentifier:@"set_city" sender:nil];
        return NO;
    }
    else if(textField.tag==1)
    {
        [self performSegueWithIdentifier:@"set_date" sender:nil];
        return NO;
    }
    else if (textField.tag==2)
    {
        [self performSegueWithIdentifier:@"set_date" sender:nil];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (IBAction)showMenu:(id)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
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
