//
//  EventViewController.m
//  First Row
//
//  Created by Luis Perez on 9/27/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize eventID;
@synthesize performer;
@synthesize BackgroundImageView;
@synthesize EventNavigationItem;
@synthesize EventDate;
@synthesize BusyIndicator;
@synthesize VideoCollectionView;
@synthesize HighestLabel;
@synthesize AverageLabel;
@synthesize LowestLabel;
@synthesize EventLabel;
@synthesize VenueLabel;
@synthesize AddressLabel;

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
    [self getEventImages];
    [self getEventVideos];
    [self getEventInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getEventInfo
{
    [EventLabel setText:@""];
    
    NSString *call = [NSString stringWithFormat:@"http://api.seatgeek.com/2/events/%@", eventID];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             NSDictionary *eventData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             NSLog(@"event data: %@", eventData);
             
             NSString *titleWithSpace = [NSString stringWithFormat:@"                   %@", [eventData objectForKey:@"short_title"]];
             [EventLabel setText:titleWithSpace];
             
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
             NSDateFormatter *tf = [[NSDateFormatter alloc] init];
             [tf setTimeStyle:NSDateFormatterShortStyle];
             NSDate *myDate = [df dateFromString: [eventData objectForKey:@"datetime_local"]];
             [df setDateStyle:NSDateFormatterFullStyle];
             
             NSString *dateData = [NSString stringWithFormat:@"%@ %@", [df stringFromDate:myDate], [tf stringFromDate:myDate]];
             [EventDate setText:dateData];

             NSString *HighestText = [NSString stringWithFormat:@"highest $%@", [[eventData objectForKey:@"stats"] objectForKey:@"highest_price"]];
             
             NSString *AverageText = [NSString stringWithFormat:@"average $%@", [[eventData objectForKey:@"stats"] objectForKey:@"average_price"]];
             
             NSString *LowestText  = [NSString stringWithFormat:@"lowest  $%@", [[eventData objectForKey:@"stats"] objectForKey:@"lowest_price"]];
             
             [HighestLabel setText:HighestText];
             [AverageLabel setText:AverageText];
             [LowestLabel setText:LowestText];
             
             ticketURL = [NSString stringWithFormat:@"%@?aid=10085", [eventData objectForKey:@"url"]];
             venueName = [[eventData objectForKey:@"venue"] objectForKey:@"name"];

             address = [[eventData objectForKey:@"venue"] objectForKey:@"address"];
             NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
             
             lat = [[[[eventData objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
             lon = [[[[eventData objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lon"] doubleValue];

             AddressLabel.attributedText = [[NSAttributedString alloc] initWithString:address attributes:underlineAttribute];
             
             [VenueLabel setText:venueName];
         }
         
     }];
}

- (void)getEventImages
{
    NSString *query = [performer stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *call = [NSString stringWithFormat:@"http://www.neuralnetapp.com/FirstRow/Bing.asmx/GetImages?Query=%@", query];
    
    NSLog(@"call %@", call);
    
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             bingImageJsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             NSString *mediaURL = [[bingImageJsonResult objectAtIndex:0] objectForKey:@"MediaUrl"];
             [BackgroundImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mediaURL]]]];
         }
         
     }];
    
}

- (void)getEventVideos
{
    NSString *query = [performer stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *call = [NSString stringWithFormat:@"http://www.neuralnetapp.com/FirstRow/Bing.asmx/GetYoutubeVideos?Query=%@", query];
    
    NSLog(@"call %@", call);
    
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             bingVideosJsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             NSLog(@"videos: %@", bingVideosJsonResult);
             [VideoCollectionView reloadData];
             [BusyIndicator stopAnimating];
         }
         
     }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [bingVideosJsonResult count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopularViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    
    NSString *photo = [[[bingVideosJsonResult objectAtIndex:indexPath.row] objectForKey:@"Thumbnail"] objectForKey:@"MediaUrl"];
    NSString *title = [[bingVideosJsonResult objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
    [cell.EventImage setImageWithURL:[NSURL URLWithString:photo]];
    [cell.EventName setText:title];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index: %d", indexPath.row);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TicketsSegue"])
    {
        TicketsViewController *ticketsViewController = [segue destinationViewController];
        [ticketsViewController setSeatGeekURL:ticketURL];
        [ticketsViewController setVenueName:venueName];
    }
    
    if ([segue.identifier isEqualToString:@"MapSegue"])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        [mapViewController setVenue:venueName];
        CLLocationCoordinate2D venueCoordinate;
        venueCoordinate.latitude = lat;
        venueCoordinate.longitude = lon;
        [mapViewController setVenueLocation:venueCoordinate];
    }
}

// iAd network

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    [banner setHidden:NO];
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [banner setHidden:YES];
}

@end
