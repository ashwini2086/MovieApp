//
//  MovieViewController.h
//  Movies
//
//  Created by Ashwini Satyanarayana on 6/8/14.
//  Copyright (c) 2014 Ashwini Satyanarayana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHud.h"

@interface MovieViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

//header animation properties
@property (strong,nonatomic) UIWindow *dropdown;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIWindow *win;
@property (strong,nonatomic) NSString *rtAPI;

@end
