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
- (void)getCategoriesWithCompletion:(void (^)())completion;
- (void)generateDataModelWithCompletion:(void (^)())completion;
- (void)preloadImages:(NSMutableArray *)gameQuestions;

@property BOOL groupDownloadComplete;
@property WIBReachability *reachability;

@end
