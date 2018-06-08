//
//  DataTableViewCell.m
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import "DataTableViewCell.h"
#import "UserData.h"

@interface DataTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *gravatar;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *goldBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeBadgeLabel;
@property (weak, nonatomic) IBOutlet UIView *view;

@end

@implementation DataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //Show Shadow Effect
    [self shadowEffectOnCell];
    
    //Set gravatar to circular image
    [self circularImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Update contents from user data
-(void)updateUI:(nonnull UserData*)data {
    self.username.text = data.username;
    self.goldBadgeLabel.text = [data.goldBadgeNum stringValue];
    self.silverBadgeLabel.text = [data.silverBadgeNum stringValue];
    self.bronzeBadgeLabel.text = [data.bronzeBadgeNum stringValue];
    self.gravatar.image = data.gravatarImage;
}

//Set Gravatar to be circular
- (void)circularImage {

    self.gravatar.layer.borderWidth = 2.0;
    self.gravatar.layer.masksToBounds = false;
    self.gravatar.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.gravatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.gravatar.layer.cornerRadius = self.gravatar.frame.size.width / 2;
    self.gravatar.clipsToBounds = true;
}

//Set shadow effect for view layer within table view cell
- (void)shadowEffectOnCell {
    self.view.layer.cornerRadius = 8.0;
    self.view.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.view.layer.shadowOpacity = 0.6;
    self.view.layer.shadowRadius = 2.0;
    self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0);
}

@end
