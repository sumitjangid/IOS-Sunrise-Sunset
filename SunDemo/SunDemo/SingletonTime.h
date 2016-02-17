//
//  SingletonTime.h
//  SunDemo
//
//  Created by Sumit Jangid on 12/12/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonTime : NSObject

@property (retain, nonatomic) NSNumber* dayTime;

@property (retain, nonatomic) NSNumber* nightTime;

+(SingletonTime*) sharedSingletonInstance;

@end
