//
//  ViewController.m
//  SunDemo
//
//  Created by Sumit Jangid on 12/7/15.
//  Copyright © 2015 Sumit Jangid. All rights reserved.
//

#import "ViewController.h"
#import "SingletonTime.h"

#include <stdio.h>
#include <libnova/solar.h>
#include <libnova/julian_day.h>
#include <libnova/rise_set.h>
#include <libnova/transform.h>

int SunRiseHour;
int SunRiseMin;
int TransitHour;
int TransitMin;
int SunSetHour;
int SunSetMin;
int RiseDay;
int RiseMonth;
int RiseYear;
NSNumber *dayTimeInSeconds;
NSNumber *nightTimeInSeconds;

struct ln_lnlat_posn observer;
CLLocation *currentLocation;


void print_date (char *title, struct ln_zonedate *date)
{
    fprintf(stdout, "\n%s\n",title);
    fprintf(stdout, " Year    : %d\n", date->years);
    fprintf(stdout, " Month   : %d\n", date->months);
    fprintf(stdout, " Day     : %d\n", date->days);
    fprintf(stdout, " Hours   : %d\n", date->hours);
    fprintf(stdout, " Minutes : %d\n", date->minutes);
    fprintf(stdout, " Seconds : %f\n", date->seconds);
}

void SunDemo()
{
    struct ln_equ_posn equ;
    struct ln_rst_time rst;
    struct ln_zonedate rise, set, transit;
    struct ln_helio_posn pos;
    double JD;
    
    /* observers location (Fullerton), used to calc rst */
    observer.lat = currentLocation.coordinate.latitude; /* 55.92 N */
    observer.lng = currentLocation.coordinate.longitude; /* 3.18 W */
   
    /* get Julian day from local time */
    JD = ln_get_julian_from_sys();
    fprintf(stdout, "JD %f\n", JD);

    /* geometric coordinates */
    ln_get_solar_geom_coords(JD, &pos);
    fprintf(stdout, "Solar Coords longitude (deg) %f\n", pos.L);
    fprintf(stdout, "             latitude (deg) %f\n", pos.B);
    fprintf(stdout, "             radius vector (AU) %f\n", pos.R);
    
    /* ra, dec */
    ln_get_solar_equ_coords(JD, &equ);
    fprintf(stdout, "Solar Position RA %f\n", equ.ra);
    fprintf(stdout, "               DEC %f\n", equ.dec);
    
    /* rise, set and transit */
    if (ln_get_solar_rst(JD, &observer, &rst) != 0)
        fprintf(stdout, "Sun is circumpolar\n");
    else {
        ln_get_local_date(rst.rise, &rise);
        ln_get_local_date(rst.transit, &transit);
        ln_get_local_date(rst.set, &set);
        print_date("Rise", &rise);
        print_date("Transit", &transit);
        print_date("Set", &set);
    }
    
    SunRiseHour = rise.hours;
    SunRiseMin  = rise.minutes;
    TransitHour = transit.hours;
    TransitMin  = transit.minutes;
    SunSetHour  = set.hours;
    SunSetMin   = set.minutes;
    RiseDay     = rise.days;
    RiseMonth   = rise.months;
    RiseYear    = rise.years;

}

@interface ViewController ()

@end

@implementation ViewController
{
    CLLocationManager* manager;
    CLGeocoder* geocoder;
    CLPlacemark* placemark;
}

@synthesize pieChartView;
@synthesize selectTimeZone;
@synthesize labelSelectedTimeZone;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

  
    //Add Time Zone to Array
    timeZoneColection = [[NSArray alloc]initWithObjects:@"Civil",@"Nautical",@"Astronomical",nil, nil];
    
    
    //GPS Location Manager and Geocoder
    manager = [[CLLocationManager alloc]init];
    
   // geocoder = [[CLGeocoder alloc]init];
    
}

//PickerView Controller
//DataSource Method
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [timeZoneColection count];
}

//Delegate Method
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    return [timeZoneColection objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    [labelSelectedTimeZone setText:[timeZoneColection objectAtIndex:row]];
}

-(IBAction)getSelectedTimeZone:(id)sender{
    
    
}

// CLLocation manager deleagate method

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Error: %@",error);
    NSLog(@"Failed to get location!");
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"Location: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        self.latitude.text = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude ];
        
        self.longitude.text = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude ];
    }
}

- (IBAction)buttonPressed:(id)sender {

    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter=kCLDistanceFilterNone;
    
    [manager startUpdatingLocation];
    [manager requestWhenInUseAuthorization];
            
    //label for Sunrise and SunSet
    
    SingletonTime *time;
    time = [SingletonTime sharedSingletonInstance];
    
    SunDemo();
    NSString* SunRise = [NSString stringWithFormat:@"%d:%d",SunRiseHour, SunRiseMin];
    self.SunLabel.text = SunRise;


    NSString* SunSet = [NSString stringWithFormat:@"%d:%d", SunSetHour, SunSetMin];
    self.SetLabel.text = SunSet;
    
    NSString* Transit = [NSString stringWithFormat:@"%d:%d", TransitHour, TransitMin];
    self.transitlabel.text = Transit;
    
    NSString* Date = [NSString stringWithFormat:@"%d/%d/%d",RiseMonth,RiseDay,RiseYear];
    self.DateLabel.text = Date;
    
    dayTimeInSeconds = [[NSNumber alloc]init];
    nightTimeInSeconds = [[NSNumber alloc]init];
    
    NSString* firstDateString=[[NSString alloc]initWithFormat:@"%d/%d/%d %d:%d",RiseMonth,RiseDay,RiseYear,SunRiseHour,SunRiseMin];
    
    NSString* secondDateString=[[NSString alloc]initWithFormat:@"%d/%d/%d %d:%d",RiseMonth,RiseDay,RiseYear,SunSetHour,SunSetMin];
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    // Set the date format according to your needs
    //[df setDateFormat:@"MM/dd/YYYY hh:mm a"]; //for 12 hour format
    [df setDateFormat:@"MM/dd/YYYY HH:mm "];  // for 24 hour format
    NSDate *date1 = [df dateFromString:firstDateString];
    NSDate *date2 = [df dateFromString:secondDateString];
    NSLog(@"%f is the time difference",[date2 timeIntervalSinceDate:date1]);
    
    
    dayTimeInSeconds=[NSNumber numberWithDouble:[date2 timeIntervalSinceDate:date1]];
    
    nightTimeInSeconds=[NSNumber numberWithDouble: 86400-[dayTimeInSeconds doubleValue]];
    
    dayTimeInSeconds=[NSNumber numberWithFloat: (([dayTimeInSeconds floatValue] / 86400))];
    NSLog(@"night sec: %@",nightTimeInSeconds);
    
    nightTimeInSeconds=[NSNumber numberWithFloat: (([nightTimeInSeconds floatValue] / 86400))];
    
    NSLog(@"Calculated day: %@",dayTimeInSeconds);
    NSLog(@"Calculated night: %@",nightTimeInSeconds);
    
    time.dayTime=dayTimeInSeconds;
    time.nightTime=nightTimeInSeconds;
    
    //Pie Chart
    SunPieChart *pieChart = [[SunPieChart alloc] initWithFrame:CGRectMake(0, 0, self.pieChartView.frame.size.width, self.pieChartView.frame.size.height)];
    pieChart.backgroundColor = [UIColor whiteColor];
    [self.pieChartView addSubview:pieChart];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
