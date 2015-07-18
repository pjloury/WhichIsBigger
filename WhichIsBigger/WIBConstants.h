//
//  WIBConstants.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HELVETICA_NEUE          @"HelveticaNeue"
#define HELVETICA_NEUE_BOLD     @"HelveticaNeue-Bold"
#define HELVETICA_NEUE_LIGHT    @"HelveticaNeue-Light"
#define HELVETICA_NEUE_MEDIUM   @"HelveticaNeue-Medium"

// Game Play Constants
#define NUMBER_OF_QUESTIONS 5
#define SECONDS_PER_QUESTION 5
#define POINTS_PER_QUESTION 40

// Data Model Constants
#define GAME_ITEM_FETCH_LIMIT 200
#define ARC4RANDOM_MAX      0x100000000

extern NSString * kGameQuestionTimeUpNotification;

@interface WIBConstants : NSObject

@end