//
//  EventViewController.h
//  First Row
//
//  Created by Luis Perez on 9/27/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PopularViewCell.h"
#import "TicketsViewController.h"
#import "MapViewController.h"

@interface EventViewController : UIViewController <ADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *bingImageJsonResult;
    NSArray *bingVideosJsonResult;
    NSString *ticketURL;
    NSString *venueName;
    NSString *address;
    double lat;
    double lon;
}

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *performer;
@property (weak, nonatomic) IBOutlet UIImageView *BackgroundImageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *EventNavigationItem;
@property (weak, nonatomic) IBOutlet UILabel *EventDate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *BusyIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *VideoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *HighestLabel;
@property (weak, nonatomic) IBOutlet UILabel *AverageLabel;
@property (weak, nonatomic) IBOutlet UILabel *LowestLabel;
@property (weak, nonatomic) IBOutlet UILabel *EventLabel;
@property (weak, nonatomic) IBOutlet UILabel *VenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;

@end
