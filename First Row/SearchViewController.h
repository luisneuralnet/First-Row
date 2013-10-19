//
//  SearchViewController.h
//  First Row
//
//  Created by Luis Perez on 9/27/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GeoLocation.h"
#import "SearchEventCell.h"
#import "EventViewController.h"

@interface SearchViewController : UIViewController <ADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *localEvents;
    NSDictionary *nationWideEvents;
}
@property (strong, nonatomic) NSString *query;
@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;

@end
