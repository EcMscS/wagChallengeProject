//
//  DataTableViewCell.h
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserData;

@interface DataTableViewCell : UITableViewCell

-(void)updateUI:(nonnull UserData*)data;

@end
