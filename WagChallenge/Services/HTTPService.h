//
//  HTTPService.h
//  WagChallenge
//
//  Created by Jeffrey Lai on 6/6/18.
//  Copyright © 2018 Talisman Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onComplete)(NSDictionary * __nullable dataDictionary, NSString *__nullable errMessage);

@interface HTTPService : NSObject

+ (id) instance;
- (void) getData:(nullable onComplete)completionHandler;

@end
