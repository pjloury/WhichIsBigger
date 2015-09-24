//
//  WIBGameQuestion.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameOption.h"

typedef enum : NSUInteger {
    WIBQuestionTypeSimilarHeight,
    WIBQuestionTypeDifferentHeight,
    WIBQuestionTypeSimilarWeight,
    WIBQuestionTypeAge,
    WIBQuestionTypePopulation,
    WIBQuestionTypeDifferentWeight,
    WIBQuestionTypeCount
} WIBQuestionType;

@class WIBGameItem;
@interface WIBGameQuestion : NSObject

@property (nonatomic, strong) WIBGameOption *option1;
@property (nonatomic, strong) WIBGameOption *option2;
@property (nonatomic, readonly) NSString *questionText;
@property (nonatomic, assign) NSTimeInterval answerTime;
@property double answerQuantity;
@property BOOL answeredCorrectly;

- (WIBGameOption *)answer;

// Initializers
- (instancetype)initOneToOneQuestion:(WIBCategoryType)categoryType;
- (instancetype)initWithDissimilarGameItem:(WIBGameItem *)item1 dissimilargameItem2:(WIBGameItem *)item2;


@end
