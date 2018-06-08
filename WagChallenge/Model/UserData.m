//
//  UserData.m
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import "UserData.h"

@implementation UserData

//Updated profile image from stored file passed in as a dictionary.
//key : value
//username : username stored
//profilePicture : profile associated with username
-(void)updateProfileImage:(NSDictionary *)nameAndImage {
    
    if ([self.username isEqualToString: [nameAndImage objectForKey:@"username"]]) {
        //Update Profile Image
        UIImage *image = [UIImage imageWithData:[nameAndImage objectForKey:@"profilePicture"]];
        self.gravatarImage = image;
    }
}

@end
