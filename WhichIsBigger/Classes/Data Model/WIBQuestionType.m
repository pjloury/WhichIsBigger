//
//  WIBQuestionType.m
//  WhichIsBigger
//
//  Created by PJ Loury on 10/2/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBQuestionType.h"

@implementation WIBQuestionType

@dynamic comparisonType;
@dynamic category;
@dynamic title;
@dynamic backgroundColor;
@dynamic tintColor;
@dynamic image;
@dynamic questionString;
@dynamic name;

+ (void)load {
    [WIBQuestionType registerSubclass];
}

+ (NSString *)parseClassName {
    return @"QuestionType";
}

@end
