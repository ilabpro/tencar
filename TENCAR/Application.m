//
//  Application.m
//  TENCAR
//
//  Created by ILAB PRO on 09.01.16.
//  Copyright © 2016 ilab.pro LLC. All rights reserved.
//

#import "Application.h"

#import <Lock/Lock.h>
#import <SimpleKeychain/A0SimpleKeychain.h>
#import <Lock-Facebook/A0FacebookAuthenticator.h>

@implementation Application

#pragma mark Singleton Method

+ (Application*)sharedInstance {
    static Application *sharedApplication = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApplication = [[self alloc] init];
    });
    return sharedApplication;
}

- (id)init {
    self = [super init];
    if (self) {
        _store = [A0SimpleKeychain keychainWithService:@"Auth0"];
        _lock = [A0Lock newLock];
        [_lock registerAuthenticators:@[
                                        [A0FacebookAuthenticator newAuthenticatorWithDefaultPermissions],
                    
                                        ]];
    }
    return self;
}

@end

