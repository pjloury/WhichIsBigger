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
    WIBQuestionTypeDifferentWeight,
    WIBQuestionTypeAge,
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

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2;
- (WIBGameOption *)answer;

@end
