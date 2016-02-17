//
//  ViewController.h
//  SunDemo
//
//  Created by Sumit Jangid on 12/7/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SunPieChart.h"

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate>
{
    NSArray *timeZoneColection;
}

@property (weak, nonatomic) IBOutlet UILabel *SunLabel;

@property (retain, nonatomic) IBOutlet SunPieChart *pieChartView;

@property (weak, nonatomic) IBOutlet UIPickerView *selectTimeZone;

@property (weak, nonatomic) IBOutlet UILabel *labelSelectedTimeZone;

@property (weak, nonatomic) IBOutlet UILabel *SetLabel;

@property (weak, nonatomic) IBOutlet UILabel *transitlabel;

@property (weak, nonatomic) IBOutlet UILabel *latitude;

@property (weak, nonatomic) IBOutlet UILabel *longitude;

@property (weak, nonatomic) IBOutlet UILabel *address;

- (IBAction)buttonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DateLabel;


-(IBAction)getSelectedTimeZone:(id)sender;
@end

