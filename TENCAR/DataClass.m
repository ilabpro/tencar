//
//  DataClass.m
//  TENCAR
//
//  Created by ILAB PRO on 30.10.15.
//  Copyright © 2015 ilab.pro LLC. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize from_date;
@synthesize to_date;

static DataClass *instance = nil;

+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataClass new];
        }
    }
    return instance;
}
@end

