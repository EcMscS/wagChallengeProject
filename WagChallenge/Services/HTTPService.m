//
//  HTTPService.m
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import "HTTPService.h"

//Constants
//Specific link to download data
#define URL_DATA "https://api.stackexchange.com/2.2/users?site=stackoverflow"

@implementation HTTPService

+ (id) instance {
    static HTTPService *sharedInstance = nil;
    
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

//Methods
//Retrieve JSON from URL_DATA
- (void) getData:(nullable onComplete)completionHandler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s", URL_DATA]];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        //Get data
        if (data != nil) {
            NSError *err; //Error for parsing JSON
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            if (err == nil) {
                //Data is good
                completionHandler(json, nil);
            } else {
                //Data is corrupt
                completionHandler(nil, @"Problem with JSON Data. Please try again");
            }
        } else {
            NSLog(@"Network Error: %@", error.debugDescription);
            completionHandler(nil, @"There is a problem connecting to the server");
        }
        
    }] resume];
}


@end
