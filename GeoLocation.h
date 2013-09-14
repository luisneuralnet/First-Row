//
//  GeoLocation.h
//  First Row
//
//  Created by Luis Perez on 9/13/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoLocation : NSObject

+(CLLocation *) Location;
+(void) setLocation:(CLLocation *)value;

@end
