//
//  SearchEventCell.h
//  First Row
//
//  Created by Luis Perez on 10/19/13.
//  Copyright (c) 2013 Neuralnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *EventPic;
@property (weak, nonatomic) IBOutlet UILabel *EventLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@end
