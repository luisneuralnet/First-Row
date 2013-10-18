//
//  MapViewController.h
//  First Row
//
//  Created by Luis Perez on 10/17/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>
#import "GeoLocation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (strong, nonatomic) NSString *venue;
@property (strong, nonatomic) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D venueLocation;

@end
