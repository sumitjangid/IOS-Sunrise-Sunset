//
//  SunPieChart.m
//  SunDemo
//
//  Created by Sumit Jangid on 12/12/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import "SunPieChart.h"
#import "SingletonTime.h"

@implementation SunPieChart

@synthesize circleRadius = _circleRadius;
@synthesize sliceArray = _sliceArray;
@synthesize colorsArray = _colorsArray;
@synthesize dayTime;
@synthesize nightTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Set up the colors for the slices
        NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor blueColor].CGColor,
                           (id)[UIColor blackColor].CGColor,
                           (id)[UIColor redColor].CGColor,
                           (id)[UIColor greenColor].CGColor, nil];
        self.colorsArray = colors;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPieChart:context];
}

- (void)drawPieChart:(CGContextRef)context  {
    
    SingletonTime *time;
    time=[SingletonTime sharedSingletonInstance];
    dayTime=time.dayTime;
    nightTime=time.nightTime;

    // Set up the slices
    NSArray *slices = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[dayTime floatValue]],
                       [NSNumber numberWithFloat:[nightTime floatValue]],
    
                       nil];
    self.sliceArray = slices;
    
    CGPoint circleCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // Set the radius of your pie chart
    self.circleRadius = 40;
    
    for (NSUInteger i = 0; i < [_sliceArray count]; i++) {
        
        // Determine start angle
        CGFloat startValue = 0;
        for (int k = 0; k < i; k++) {
            startValue += [[_sliceArray objectAtIndex:k] floatValue];
        }
        CGFloat startAngle = startValue * 2 * M_PI - M_PI/2;
        
        // Determine end angle
        CGFloat endValue = 0;
        for (int j = i; j >= 0; j--) {
            endValue += [[_sliceArray objectAtIndex:j] floatValue];
        }
        CGFloat endAngle = endValue * 2 * M_PI - M_PI/2;
        
        CGContextSetFillColorWithColor(context, (CGColorRef)[_colorsArray objectAtIndex:i]);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, circleCenter.x, circleCenter.y);
        CGContextAddArc(context, circleCenter.x, circleCenter.y, self.circleRadius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
}

@end
