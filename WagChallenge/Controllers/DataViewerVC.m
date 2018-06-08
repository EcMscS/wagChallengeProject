//
//  ViewController.m
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import "DataViewerVC.h"
#import "HTTPService.h"
#import "UserData.h"
#import "DataTableViewCell.h"

//Constants
const int tableHeight = 150;

@interface DataViewerVC ()

@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) NSArray *userList;
@property (assign, nonatomic) BOOL isImagesCached;

@end

@implementation DataViewerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initial setup
    [self setup];

    //Load or retrieve data
    [self cacheProfileImages];

}


//Main Methods
-(void) setup {
    //Set up tableview
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    
    //Create Empty List of Users
    self.userList = [[NSArray alloc]init];
    
    //RefreshControll pull down
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.dataTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
}


-(void) cacheProfileImages {
    //Check to see if images have been retrievedn or already stored.
    if (_isImagesCached) {
        //Load images from file data
        [self retrieveImagesFromFile];
    } else {
        //Retreive data from URL
        [self activitySpinnerWhenWaitingToLoadData];

    }
}


//Supporting Methods
//File path in which the data is stored
-(NSString *)filePathForCachedImages:(NSString *)fileFolderName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:fileFolderName];
    return filePath;
}

//End pull down refresh from tableView and reloads data
-(void)refreshTable:(id)sender {
    [self cacheProfileImages];
    [(UIRefreshControl *)sender endRefreshing];
    [self.dataTableView reloadData];
}

//Saves profile image that is associated with the username locally
-(void) saveImages {
    NSMutableArray *savedList = [[NSMutableArray alloc]init];
    
    for (UserData *each in self.userList) {
        NSMutableDictionary *nameAndImageData = [NSMutableDictionary dictionary];
        [nameAndImageData setObject:each.username forKey:@"username"];
        
        NSData *imageData = UIImagePNGRepresentation(each.gravatarImage);
        [nameAndImageData setObject:imageData forKey:@"profilePicture"];
        
        [savedList addObject:nameAndImageData];
    }
    
    //Paths
    NSString *filePath = [self filePathForCachedImages:(@"/cachedImages")];
    
    //Write to file
    [savedList writeToFile:filePath atomically:YES];
    
}

//Retrieves images from local storage and updates the profile image when connection is lost while the app is opened.
-(void) retrieveImagesFromFile {
    
    //Paths
    NSString *filePath = [self filePathForCachedImages:(@"/cachedImages")];
    
    //Retrieve username and profile image
    NSMutableArray *savedList = [[NSMutableArray alloc]init];
    savedList = [savedList initWithContentsOfFile:filePath];
    
    //Update the profile image if necessary
    for (UserData *each in self.userList) {
        
        for (NSDictionary *update in savedList) {
            
            if ([each.username isEqualToString:[update objectForKey:@"username"]]) {
                UIImage *updateImage = [UIImage imageWithData:[update objectForKey:@"profilePicture"]];
                each.gravatarImage = updateImage;
                break;
            }

        }
    }
}

//Indicate to user with spinner animation that data is being downloaded if it takes longer to perform
-(void) activitySpinnerWhenWaitingToLoadData {
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloadInfo", NULL);
    dispatch_async(downloadQueue, ^{
        //Perform action - Load data from URL
        [self loadData];
        
        //Testing Acitivty Spinner for 5 seconds before loading data
        //[NSThread sleepForTimeInterval:5];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
        });
    });
}

//Retrieve data using HTTPService class and save images for offline usage
-(void) loadData {
    
    [[HTTPService instance] getData:^(NSDictionary * _Nullable dataDictionary, NSString * _Nullable errMessage) {
        if (dataDictionary) {
            
            NSDictionary *users = [[NSDictionary alloc]init];
            users = [dataDictionary objectForKey:@"items"]; //Obtains all the users
            
            NSMutableArray *userExtracted = [[NSMutableArray alloc]init];
            
            for (NSDictionary *eachUser in users) {
                UserData *each = [[UserData alloc]init];
                each.username = [eachUser objectForKey:@"display_name"];
                each.goldBadgeNum = [[eachUser objectForKey:@"badge_counts"]objectForKey:@"gold"];
                each.silverBadgeNum = [[eachUser objectForKey:@"badge_counts"]objectForKey:@"silver"];
                each.bronzeBadgeNum = [[eachUser objectForKey:@"badge_counts"]objectForKey:@"bronze"];
                
                //Retrieve image before adding user
                each.gravatarUrl = [eachUser objectForKey:@"profile_image"];
                UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:each.gravatarUrl]]];
                each.gravatarImage = profileImage;
                
                self.isImagesCached = true;
                
                [userExtracted addObject:each];
            }
            
            self.userList = userExtracted;
            [self updateTableData];
        
            //Save images to file
            [self saveImages];
            
        } else if (errMessage) {
            //Display alert to user
            NSLog(@"Error: %@", errMessage);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Cannot connect to the internet" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //TODO
            }];
            
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

//Update tableview at the main queue (UI updates always need to be down in the main queue)
-(void) updateTableData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataTableView reloadData];
    });
}

//Table View Methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserData *user = [self.userList objectAtIndex:indexPath.row];
    DataTableViewCell *userCell = (DataTableViewCell*)cell;
    [userCell updateUI:user];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO
    //Action after selecting row
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Create DataTableViewCell
    DataTableViewCell *cell = (DataTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"dataTableViewCell"];
    
    if (!cell) {
        cell = [[DataTableViewCell alloc]init];
    }
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableHeight;
}



@end
