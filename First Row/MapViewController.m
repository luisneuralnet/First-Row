//
//  MapViewController.m
//  First Row
//
//  Created by Luis Perez on 10/17/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize MapView;
@synthesize address;
@synthesize venue;
@synthesize venueLocation;

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
    [self setMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setMap
{
    MKPointAnnotation *pa = [MKPointAnnotation new];

    NSLog(@"lat: %f", venueLocation.latitude);
    NSLog(@"lon: %f", venueLocation.longitude);
    
    pa.coordinate = venueLocation;
    pa.title = venue;
    pa.subtitle = address;
    MapView.region = MKCoordinateRegionMakeWithDistance(venueLocation, 1500, 1500);
    [MapView removeAnnotations:MapView.annotations];
    
    [MapView addAnnotation:pa];
    [MapView selectAnnotation:pa animated:YES];
    
    // TO DO Directions Requests
    //MKDirectionsRequest* directionsInfo = [[MKDirectionsRequest alloc] init];
}

// iAd network

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [banner setHidden:NO];
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [banner setHidden:YES];
}

@end
