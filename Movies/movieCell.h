//
//  movieCell.h
//  Movies
//
//  Created by Ashwini Satyanarayana on 6/8/14.
//  Copyright (c) 2014 Ashwini Satyanarayana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

@end
