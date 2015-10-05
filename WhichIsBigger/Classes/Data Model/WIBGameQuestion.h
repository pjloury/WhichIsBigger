//
//  WIBGameQuestion.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameOption.h"
#import "WIBQuestionType.h"

@class WIBGameItem;
@interface WIBGameQuestion : NSObject

@property (nonatomic, strong) WIBGameOption *option1;
@property (nonatomic, strong) WIBGameOption *option2;
@property (nonatomic, readonly) NSString *questionText;
@property (nonatomic, assign) NSTimeInterval answerTime;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic) WIBQuestionType *questionType;

@property (nonatomic, assign) double answerQuantity;
@property (nonatomic, assign) double difficulty;
@property (nonatomic, assign) BOOL answeredCorrectly;

- (WIBGameOption *)answer;

// Initializers
- (instancetype)initOneToOneQuestion:(WIBQuestionType *)categoryString;
- (instancetype)initWithDissimilarGameItem:(WIBGameItem *)item1 dissimilargameItem2:(WIBGameItem *)item2;

// Save
- (void)saveInBackground;

@end
