//
//  WIBGamePlayManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameQuestion.h"

@interface WIBGamePlayManager : NSObject

+ (WIBGamePlayManager *)sharedInstance;
- (WIBGameQuestion *)gameQuestion;

@end
