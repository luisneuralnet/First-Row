//
//  GeoLocation.m
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import "GeoLocation.h"

@implementation GeoLocation

static CLLocation *locationValue;

+(CLLocation *) Location { return locationValue; }
+(void) setLocation:(CLLocation *)value { locationValue = value; }

@end
