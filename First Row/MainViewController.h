//
//  MainViewController.h
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <iAd/iAd.h>
#import "GeoLocation.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, ADBannerViewDelegate>
{
    CLLocationManager *locationManager;
}


@end
