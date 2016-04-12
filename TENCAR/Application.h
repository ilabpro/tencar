//
//  Application.h
//  TENCAR
//
//  Created by ILAB PRO on 09.01.16.
//  Copyright © 2016 ilab.pro LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class A0SimpleKeychain, A0Lock;

@interface Application : NSObject

@property (readonly, nonatomic) A0SimpleKeychain *store;
@property (readonly, nonatomic) A0Lock *lock;

+ (Application *)sharedInstance;

@end

