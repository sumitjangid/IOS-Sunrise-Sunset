//
//  SingletonTime.m
//  SunDemo
//
//  Created by Sumit Jangid on 12/12/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonTime.h"

static SingletonTime* _sharedSingletonInstance;

@implementation SingletonTime

@synthesize dayTime;
@synthesize nightTime;

-(SingletonTime*) init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

+(SingletonTime*) sharedSingletonInstance
{
    if (_sharedSingletonInstance != nil) {
        
        return _sharedSingletonInstance;
    }
    else{
        _sharedSingletonInstance = [[SingletonTime alloc]init];
        return _sharedSingletonInstance;
    }
}


@end
