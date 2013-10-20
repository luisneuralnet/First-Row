//
//  AboutViewController.h
//  First Row
//
//  Created by Luis Perez on 9/15/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>

@interface AboutViewController : UIViewController <ADBannerViewDelegate, MFMailComposeViewControllerDelegate>

- (IBAction)ContactUsClick:(id)sender;
- (IBAction)FootballProClick:(id)sender;
- (IBAction)GameScoutClick:(id)sender;

@end
