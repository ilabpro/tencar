//
//  dashboardViewController.h
//  TENCAR
//
//  Created by ILAB PRO on 19.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface dashboardViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic)   CLLocationManager *locationManager;
@property (strong, nonatomic)  CLLocation *currentLocation;


@end
