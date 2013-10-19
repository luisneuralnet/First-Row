//
//  MainViewController.h
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <iAd/iAd.h>
#import "GeoLocation.h"
#import "PopularViewCell.h"
#import "EventViewController.h"
#import "SearchViewController.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, ADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
{
    CLLocationManager *locationManager;
    NSArray *popularEventsArray;
    int SelectedIndex;
    bool GotFirstLocation;
    NSTimer *Timer;
}

@property (weak, nonatomic) IBOutlet UICollectionView *PopularEventsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *BusyIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *EventSearchBar;

@end
