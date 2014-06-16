//
//  MovieViewController.m
//  Movies
//
//  Created by Ashwini Satyanarayana on 6/8/14.
//  Copyright (c) 2014 Ashwini Satyanarayana. All rights reserved.
//

#import "MovieViewController.h"
#import "movieCell.h"
#import "detailedViewController.h"
#import "Reachability.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>

@interface MovieViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *movies;
@property(nonatomic, strong)NSString *thumbURL;
@property UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;

}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    self.dropdown = [[UIWindow alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
    self.dropdown.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:self.dropdown.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.backgroundColor = [UIColor clearColor];
    [self.dropdown addSubview:self.label];
    self.dropdown.windowLevel = UIWindowLevelStatusBar;
    [self.dropdown makeKeyAndVisible];
    [self.dropdown resignKeyWindow];
    
    // Pull to refresh
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshMoviesList) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    // Do async call using AFNetworking
    [self refreshMoviesList];

    [self.tableView registerNib:[UINib nibWithNibName:@"movieCell" bundle:nil] forCellReuseIdentifier:@"movieCell"];
    self.tableView.rowHeight = 120;
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void) refreshMoviesList {
    
    //Creating a HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.dimBackground = YES;
    hud.delegate = self;
    hud.labelText = @"Loading...";
    [hud show:YES];
    
    // Async request from Rotten Tomatoes API
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.rtAPI]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        self.movies = responseObject[@"movies"];
        [self.tableView reloadData];
        [hud hide:YES];
        [self.refreshControl endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self animateHeaderViewWithText:[error localizedDescription]];
        [hud hide:YES];
        [self.refreshControl endRefreshing];
    }];
    
    [operation start];
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.movies.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    movieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie[@"title"];
    cell.movieSynopsisLabel.text = movie[@"synopsis"];
    
    self.thumbURL = [self getThumbURL:movie[@"posters"]];
    NSURL *imageURL = [NSURL URLWithString:self.thumbURL];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    cell.posterView.image = [UIImage imageWithData:data];

    return cell;
    
}

- (NSString* )getThumbURL:(NSDictionary *)movieDic{
    NSString *thumbURL = [[NSString alloc] initWithString:[movieDic objectForKey:@"profile"]];
    return thumbURL;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    detailedViewController *dvc = [[detailedViewController alloc] initWithNibName:@"detailedViewController" bundle:nil];
    dvc.movie = self.movies[indexPath.row];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//header animation
-(void)animateHeaderViewWithText:(NSString *) text {
    self.label.text = text;
    
    [UIView animateWithDuration:.5 delay:0 options:0 animations:^{
        self.dropdown.frame = CGRectMake(0, 0, 320, 20);
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:2 options:0 animations:^{
            self.dropdown.frame = CGRectMake(0, -20, 320, 20);
        } completion:^(BOOL finished) {
            
            //animation finished!!!
        }];
        ;
    }];
}

@end
