//
//  YouTubeViewController.h
//  First Row
//
//  Created by Luis Perez on 10/18/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *videoURL;

@property (weak, nonatomic) IBOutlet UIWebView *VideoWebView;
@end
