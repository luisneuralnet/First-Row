//
//  YouTubeViewController.m
//  First Row
//
//  Created by Luis Perez on 10/18/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "YouTubeViewController.h"

@interface YouTubeViewController ()

@end

@implementation YouTubeViewController

@synthesize videoURL;
@synthesize VideoWebView;

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
    [self startVideoYouTube];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startVideoYouTube
{
    NSString *videoID = [videoURL stringByReplacingOccurrencesOfString:@"http://www.youtube.com/watch?v=" withString:@""];
    
    NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = \"http://www.youtube.com/player_api\"; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'320.0f', height:'480.0f', videoId:'%@', events: { 'onReady': onPlayerReady, } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>", videoID];
    
    VideoWebView.mediaPlaybackRequiresUserAction = NO;
    [VideoWebView loadHTMLString: youTubeVideoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
}
@end
