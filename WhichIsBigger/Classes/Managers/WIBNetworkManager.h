//
//  WIBNetworkManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"
#import "WIBReachability.h"

@interface WIBNetworkManager : NSObject

+ (WIBNetworkManager *)sharedInstance;
- (void)getConfigurationWithCompletion:(void (^)())completion;
- (void)getCategoriesWithCompletion:(void (^)())completion;
- (void)generateDataModelWithCompletion:(void (^)())completion;
- (void)preloadImages:(NSMutableArray *)gameQuestions;

@property WIBReachability *reachability;

@end
