//
//  UserData.h
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface UserData : NSObject

//Variables
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *goldBadgeNum;
@property (nonatomic, strong) NSNumber *silverBadgeNum;
@property (nonatomic, strong) NSNumber *bronzeBadgeNum;
@property (nonatomic, strong) NSString *gravatarUrl;
@property (nonatomic, strong) UIImage *gravatarImage;

-(void)updateProfileImage:(NSDictionary *)nameAndImage;

@end
