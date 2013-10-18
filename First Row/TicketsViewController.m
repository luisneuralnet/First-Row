//
//  TicketsViewController.m
//  First Row
//
//  Created by Luis Perez on 9/29/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "TicketsViewController.h"

@interface TicketsViewController ()

@end

@implementation TicketsViewController

@synthesize SeatGeekURL;
@synthesize venueName;
@synthesize WebView;
@synthesize BusyIndicator;
@synthesize LoadingLabel;
@synthesize NavigationItem;

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
    NSURL *url = [NSURL URLWithString:SeatGeekURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [WebView setHidden:YES];
    [WebView loadRequest:request];
//    [NavigationItem setTitle:venueName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BusyIndicator stopAnimating];
    [LoadingLabel setHidden:YES];
    [WebView setHidden:NO];
}
@end
