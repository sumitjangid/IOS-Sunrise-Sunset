//
//  SunPieChart.h
//  SunDemo
//
//  Created by Sumit Jangid on 12/12/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunPieChart : UIView{
    
}

@property (nonatomic, assign) CGFloat circleRadius;
@property (nonatomic, retain) NSArray *sliceArray;
@property (nonatomic, retain) NSArray *colorsArray;
@property (nonatomic, retain) NSNumber *dayTime;
@property (nonatomic, retain) NSNumber *nightTime;

- (void)drawPieChart:(CGContextRef)context;

@end
