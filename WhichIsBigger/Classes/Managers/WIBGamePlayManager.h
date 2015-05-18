//
//  WIBGamePlayManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WIBGameQuestion;

@interface WIBGamePlayManager : NSObject

- (void)beginGame;
- (void)completeGame;

+ (WIBGamePlayManager *)sharedInstance;
- (WIBGameQuestion *)nextGameQuestion;
- (BOOL)questionIndexIsInBounds;
- (NSInteger)numberCorrectAnswers;

@property (readonly) NSInteger questionIndex;
@property (nonatomic, assign) double difficulty;

@end
