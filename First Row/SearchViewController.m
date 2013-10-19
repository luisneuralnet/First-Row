//
//  SearchViewController.m
//  First Row
//
//  Created by Luis Perez on 9/27/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize query;
@synthesize SearchTableView;

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
    
    [self getLocalEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLocalEvents
{
    CLLocation *location = [GeoLocation Location];
    
    NSString *webQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *call = [NSString stringWithFormat:@"http://api.seatgeek.com/2/events?per_page=50&page=1&q=%@&lat=%f&lon=%f&range=50mi", webQuery, location.coordinate.latitude, location.coordinate.longitude];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             localEvents = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             NSLog(@"local events: %@", localEvents);
             
             [self getNationWideEvents];
         }
         
     }];
}

- (void)getNationWideEvents
{
    NSString *webQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *call = [NSString stringWithFormat:@"http://api.seatgeek.com/2/events?per_page=200&page=1&q=%@", webQuery];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:call]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if (error == NULL)
         {
             nationWideEvents = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
             [SearchTableView reloadData];
         }
         
     }];
}

#pragma mark --------- Table View -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // One section
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [[localEvents objectForKey:@"events"] count];
            break;
        case 1:
            return [[nationWideEvents objectForKey:@"events"] count];
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"forIndexPath:indexPath];
    
    switch ([indexPath section])
    {
        case 0:
        {
            [cell.EventLabel setText:[[[localEvents objectForKey:@"events"] objectAtIndex:indexPath.row]  objectForKey:@"short_title"]];
            
            NSString *photo = [NSString new];
            @try
            {
                photo = [[[[[localEvents objectForKey:@"events"] objectAtIndex:indexPath.row] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"image"];
            }
            @catch (NSException *exception)
            {
                // do nothing for now
            }

            if (photo != (NSString *)[NSNull null])
                [cell.EventPic setImageWithURL:[NSURL URLWithString:photo]];
            else
                [cell.EventPic setImage:[UIImage imageNamed:@"NoImage.jpg"]];
            
            NSString *date = [[[localEvents objectForKey:@"events"] objectAtIndex:indexPath.row] objectForKey:@"datetime_local"];
            
            date = [self DateString:date];
            
            [cell.DateLabel setText:date];
        }
        break;
            
        case 1:
        {
            [cell.EventLabel setText:[[[nationWideEvents objectForKey:@"events"] objectAtIndex:indexPath.row] objectForKey:@"short_title"]];
            
            NSString *photo = [NSString new];
            @try
            {
                photo = [[[[[nationWideEvents objectForKey:@"events"] objectAtIndex:indexPath.row] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"image"];
            }
            @catch (NSException *exception)
            {
                // do nothing for now
            }
            
            if (photo != (NSString *)[NSNull null])
                [cell.EventPic setImageWithURL:[NSURL URLWithString:photo]];
            else
                [cell.EventPic setImage:[UIImage imageNamed:@"NoImage.jpg"]];
            
            NSString *date = [[[nationWideEvents                                                                       objectForKey:@"events"] objectAtIndex:indexPath.row] objectForKey:@"datetime_local"];
            
            date = [self DateString:date];
            
            [cell.DateLabel setText:date];
        }
        break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = [NSString new];
    switch (section)
    {
        case 0:
        {
            NSString *headerText = [NSString new];
            
            if ([[localEvents objectForKey:@"events"] count] > 1)
                headerText = @"s";
            
            header = [NSString stringWithFormat:@"(%d) local event%@", [[localEvents objectForKey:@"events"] count], headerText];
        }
        break;
            
        case 1:
        {
            NSString *headerText = [NSString new];
            
            if ([[nationWideEvents objectForKey:@"events"] count] > 1)
                headerText = @"s";
            
            header = [NSString stringWithFormat:@"(%d) nationwide event%@", [[nationWideEvents objectForKey:@"events"] count], headerText];
        }
        break;
            
    }
    
    return header;
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

-(NSString *)DateString:(NSString *)stringValue
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormatter setCalendar:gregorianCalendar];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    NSDate *eventDate = [dateFormatter dateFromString:stringValue];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *date = [dateFormatter stringFromDate:eventDate];
    
    return date;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventSegue"])
    {
        EventViewController *eventViewController = [segue destinationViewController];
        int Section = SearchTableView.indexPathForSelectedRow.section;
        int Row = SearchTableView.indexPathForSelectedRow.row;
        
        NSLog(@"selcted index: %d, selected section: %d", Row, Section);
        
        NSString *performer = [NSString new];

        switch (Section)
        {
            case 0:
                performer = [[[[[localEvents objectForKey:@"events"] objectAtIndex:Row] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"name"];
                [eventViewController setEventID:[[[localEvents objectForKey:@"events"] objectAtIndex:Row] objectForKey:@"id"]];
                break;
                
            case 1:
                performer = [[[[[nationWideEvents objectForKey:@"events"] objectAtIndex:Row] objectForKey:@"performers"] objectAtIndex:0] objectForKey:@"name"];
                [eventViewController setEventID:[[[nationWideEvents objectForKey:@"events"] objectAtIndex:Row] objectForKey:@"id"]];
                break;
        }

        [eventViewController setPerformer:performer];
    }
}
@end
