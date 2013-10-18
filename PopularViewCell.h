//
//  PopularViewCell.h
//  First Row
//
//  Created by Luis Perez on 9/14/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *EventImage;
@property (weak, nonatomic) IBOutlet UILabel *EventName;
@property (weak, nonatomic) IBOutlet UILabel *EventDate;
@property (weak, nonatomic) IBOutlet UILabel *EventLocation;

@end
