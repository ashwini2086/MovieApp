//
//  detailedViewController.m
//  Movies
//
//  Created by Ashwini Satyanarayana on 6/15/14.
//  Copyright (c) 2014 Ashwini Satyanarayana. All rights reserved.
//

#import "detailedViewController.h"
#import "MovieViewController.h"
#import "movieCell.h"
#import "UIImageView+AFNetworking.h"

@interface detailedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabelView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailedScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *detailedProfileImageView;
@property (nonatomic, strong) NSString *profileURL;

@end

@implementation detailedViewController

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
    self.title = self.movie[@"title"];
    
    self.synopsisLabelView.text = self.movie[@"synopsis"];
    
    self.profileURL = [self getProfileURL:self.movie[@"posters"]];
    NSURL *imageURL = [NSURL URLWithString:self.profileURL];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    [UIImageView transitionWithView:self.detailedProfileImageView duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{self.detailedProfileImageView.image= [UIImage imageWithData:data];
    } completion:nil];
    
    [self.view endEditing:YES];
}

- (NSString* )getProfileURL:(NSDictionary *)movieDic {
    NSString *thumbURL = [[NSString alloc] initWithString:[movieDic objectForKey:@"detailed"]];
    return thumbURL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
