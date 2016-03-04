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
#define FACEBOOK_LOGIN

// Game Play Constants
#define NUMBER_OF_QUESTIONS 5
#define SECONDS_PER_QUESTION 5
#define POINTS_PER_QUESTION 100
#define POINTS_PER_LEVEL 500

// Data Model Constants
#define GAME_ITEM_FETCH_LIMIT 1000
#define ARC4RANDOM_MAX      0x100000000

extern NSString * kGameQuestionTimeUpNotification;
extern NSString *kGroupImageDownloadCompleteNotification;

extern NSString *kHeight;
extern NSString *kWeight;
extern NSString *kAge;
extern NSString *kPopulation;

@interface WIBConstants : NSObject

@end