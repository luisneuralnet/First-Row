//
//  MainViewController.m
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize PopularEventsCollectionView;
@synthesize BusyIndicator;
@synthesize EventSearchBar;

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
    [self setFirstRowLogo];
    GotFirstLocation = NO;
    [self getUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFirstRowLogo
{
    // insert app logo
    UIImage *tImage = [UIImage imageNamed:@"LogoFirstRow.png"];
    UIImageView *tImageView = [[UIImageView alloc] initWithImage:tImage];
    tImageView.frame = CGRectMake(70, 20, 180, 45);
    tImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationController.view addSubview:tImageView];
}

- (void)getUserLocation
{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [GeoLocation setLocation:newLocation];
    NSLog(@"new location lat: %f lon: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];
    
    if (GotFirstLocation == NO && newLocation.coordinate.latitude > 0)
    {
        GotFirstLocation = YES;
        [self getPopularsEvents];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"status = %d", status);
    
    if (status == kCLAuthorizationStatusAuthorized)
    {
        [self getPopularsEvents];
    }
    
    // location services are disabled
    if (status == kCLAuthorizationStatusDenied)
    {
        
    }
}

- (void)getPopularsEvents
{
    CLLocationCoordinate2D pointData = [[GeoLocation Location] coordinate];
    NSDate *todayDate = [NSDate date];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *dateString = [formatter stringFromDate:todayDate];
    
    NSString *call = [NSString stringWithFormat:@"http://api.seatgeek.com/2/events?per_page=100&page=1&lat=%f&lon=%f&range=50mi&datetime_utc.gt=%@", pointData.latitude, pointData.longitude, dateString];
    
    if (pointData.latitude > 0)
    {
        //NSLog(@"call: %@", call);
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
            if (error == NULL)
            {
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                
                popularEventsArray = [jsonResponse objectForKey:@"events"];
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score"
                                                                               ascending:NO];
                
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                
                popularEventsArray = [popularEventsArray sortedArrayUsingDescriptors:sortDescriptors];
                //NSLog(@"json response: %@", popularEventsArray);
                [PopularEventsCollectionView reloadData];
                [BusyIndicator stopAnimating];
            }
            else
            {
                NSLog(@"error: %@", error.localizedDescription);
            }
        }];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"events count: %d", [popularEventsArray count]);
    return [popularEventsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedIndex = indexPath.row;
    [Timer invalidate];
    PopularViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"popularCell" forIndexPath:indexPath];
    
    NSString *photo = [[[[popularEventsArray objectAtIndex:indexPath.row] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"image"];
    NSString *title = [[popularEventsArray objectAtIndex:indexPath.row] objectForKey:@"short_title"];
    NSString *date = [[popularEventsArray objectAtIndex:indexPath.row] objectForKey:@"datetime_local"];
    NSString *location = [[[popularEventsArray objectAtIndex:indexPath.row] objectForKey:@"venue"] objectForKey:@"city"];
    
    date = [self DateString:date];
    
    if (photo != (NSString *)[NSNull null])
        [cell.EventImage setImageWithURL:[NSURL URLWithString:photo]];
    else
        [cell.EventImage setImage:[UIImage imageNamed:@"NoImage.jpg"]];
    
    [cell.EventDate setText:date];
    [cell.EventLocation setText:location];
    [cell.EventName setText:title];
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected index: %d", indexPath.row);
}

-(void)aTime
{
    SelectedIndex++;
    if (SelectedIndex > ([popularEventsArray count] - 1))
        SelectedIndex = 0;
    
    NSIndexPath *iPath = [NSIndexPath indexPathForItem:SelectedIndex inSection:0];
    [PopularEventsCollectionView scrollToItemAtIndexPath:iPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(NSString *)DateString:(NSString *)stringValue
{
    stringValue = [stringValue stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *eventDate = [dateFormatter dateFromString:stringValue];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *date = [dateFormatter stringFromDate:eventDate];
    
    return date;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"SearchSegue" sender:Nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventSegue"])
    {
        EventViewController *eventViewController = [segue destinationViewController];
        
        NSString *performer = [[[[popularEventsArray objectAtIndex:SelectedIndex] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"name"];
        
        [eventViewController setEventID:[[popularEventsArray objectAtIndex:SelectedIndex] objectForKey:@"id"]];
        [eventViewController setPerformer:performer];
    }
    
    if ([segue.identifier isEqualToString:@"SearchSegue"])
    {
        SearchViewController *searchViewController = [segue destinationViewController];
        [searchViewController setQuery:EventSearchBar.text];
    }
}

@end
