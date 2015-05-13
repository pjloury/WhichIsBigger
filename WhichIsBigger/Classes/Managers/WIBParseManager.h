//
//  WIBParseManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"

@interface WIBParseManager : NSObject

+ (WIBParseManager *)sharedInstance;
- (void)generateDataModelWithCompletion:(void (^)())completion;

@end
