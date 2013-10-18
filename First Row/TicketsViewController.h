//
//  TicketsViewController.h
//  First Row
//
//  Created by Luis Perez on 9/29/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) NSString *SeatGeekURL;
@property (nonatomic, retain) NSString *venueName;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *BusyIndicator;
@property (weak, nonatomic) IBOutlet UILabel *LoadingLabel;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationItem;

@end
