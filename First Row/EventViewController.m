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
@synthesize BuyTicketsImg;
@synthesize FacebookBTN;
@synthesize TwitterBTN;

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
    
    NSLog(@"performer: %@", performer);
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
             [df setDateStyle:NSDateFormatterShortStyle];
             eventDate = [df stringFromDate:myDate];
             
             NSString *highestPrice = [[eventData objectForKey:@"stats"] objectForKey:@"highest_price"];
             NSString *averagePrice = [[eventData objectForKey:@"stats"] objectForKey:@"average_price"];
             NSString *lowestPrice = [[eventData objectForKey:@"stats"] objectForKey:@"lowest_price"];
             
             NSLog(@"highest price: %@", highestPrice);
             
             NSString *HighestText = @"highest n/a";
             NSString *AverageText = @"average n/a";
             NSString *LowestText  = @"lowest n/a";
             
             if (![highestPrice isEqual:[NSNull null]])
             HighestText = [NSString stringWithFormat:@"highest $%@", [[eventData objectForKey:@"stats"] objectForKey:@"highest_price"]];
             
             if (![averagePrice isEqual:[NSNull null]])
             AverageText = [NSString stringWithFormat:@"average $%@", [[eventData objectForKey:@"stats"] objectForKey:@"average_price"]];
             
             if (![lowestPrice isEqual:[NSNull null]])
             LowestText  = [NSString stringWithFormat:@"lowest $%@", [[eventData objectForKey:@"stats"] objectForKey:@"lowest_price"]];
             
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
             @try
             {
                 NSInteger randomIndex = arc4random() % [bingImageJsonResult count] - 1;
                 NSString *mediaURL = [[bingImageJsonResult objectAtIndex:randomIndex] objectForKey:@"MediaUrl"];
                 [BackgroundImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mediaURL]]]];
             }
             @catch (NSException *exception)
             {
                 // TODO
                 // set first row no image
             }
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
             //NSLog(@"videos: %@", bingVideosJsonResult);
             [VideoCollectionView reloadData];
             [BusyIndicator stopAnimating];
             [self unhideEventInfo];
         }
         
     }];
}

- (void)unhideEventInfo
{
    [EventLabel setHidden:NO];
    [VenueLabel setHidden:NO];
    [EventDate setHidden:NO];
    [AverageLabel setHidden:NO];
    [LowestLabel setHidden:NO];
    [HighestLabel setHidden:NO];
    [AddressLabel setHidden:NO];
    [FacebookBTN setHidden:NO];
    [TwitterBTN setHidden:NO];
    [BuyTicketsImg setHidden:NO];
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
    
    if ([segue.identifier isEqualToString:@"VideoSegue"])
    {
        NSArray *indexPaths = [VideoCollectionView indexPathsForSelectedItems];
        NSIndexPath *index = [indexPaths objectAtIndex:0];
        
        NSString *video = [[bingVideosJsonResult objectAtIndex:index.row] objectForKey:@"MediaUrl"];
        
        YouTubeViewController *youTubeViewController = [segue destinationViewController];
        [youTubeViewController setVideoURL:video];
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

- (IBAction)ShareFacebookClick:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebook = [SLComposeViewController new];
        
        facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [self presentViewController:facebook animated:YES completion:nil];
        
        [facebook setInitialText:[NSString stringWithFormat:@"going to see %@ on %@ %@ via #FirstRow", performer, eventDate,ticketURL]];
        
        [facebook setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultCancelled:
                 {
                     NSLog(@"facebook error");
                 }
                     break;
                     
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"facebook done");
                 }
                     break;
                     
                 default:
                     break;
             }
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Row" message:@"Unable to use facebook, please check your facebook settings and try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)ShareTwitterClick:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *twitter = [SLComposeViewController new];
        
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [self presentViewController:twitter animated:YES completion:nil];
        
        [twitter setInitialText:[NSString stringWithFormat:@"going to see %@ on %@ %@ via #FirstRow", performer, eventDate,ticketURL]];
        
        [twitter setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             switch (result)
             {
                 case SLComposeViewControllerResultCancelled:
                 {
                     NSLog(@"twitter error");
                 }
                     break;
                     
                 case SLComposeViewControllerResultDone:
                 {
                     NSLog(@"twitter done");
                 }
                     break;
                     
                 default:
                     break;
             }
             [self dismissViewControllerAnimated:YES completion:nil];
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Row" message:@"Unable to use twitter, please check your twitter settings and try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}
@end
