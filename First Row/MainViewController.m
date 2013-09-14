//
//  MainViewController.m
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserLocation
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GeoLocation setLocation:newLocation];
    NSLog(@"new location lat: %f lon: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];
    
    [self getPopularsEvents];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"status = %d", status);
    
    // Location Services are Disabled
    if (status == 2)
        [self performSegueWithIdentifier:@"NoInternetConnectionSegue" sender:nil];
}

- (void)getPopularsEvents
{
    CLLocationCoordinate2D pointData = [[GeoLocation Location] coordinate];
    NSDate* todayDate = [NSDate date];

    NSString *call = [NSString stringWithFormat:@"http://api.seatgeek.com/2/events?per_page=100&page=1&lat=%f&lon=%f&range=50mi&datetime_utc.gt=%@", pointData.latitude, pointData.longitude, todayDate];
    
    NSLog(@"call: %@", call);
    
    
}

@end
