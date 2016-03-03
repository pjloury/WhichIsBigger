//
//  WIBQuestionType.m
//  WhichIsBigger
//
//  Created by PJ Loury on 10/2/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBQuestionType.h"
#import "UIColor+Additions.h"

@implementation WIBQuestionType

@dynamic comparisonType;
@dynamic category;
@dynamic title;
@dynamic backgroundColorString;
@dynamic tintColorString;
@dynamic themeColorString;
@dynamic pointsToUnlock;
@dynamic image;
@dynamic questionString;
@dynamic name;

+ (void)load {
    [WIBQuestionType registerSubclass];
}

+ (NSString *)parseClassName {
    return @"QuestionType";
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithString:self.backgroundColorString];
}

- (UIColor *)tintColor {
    return [UIColor colorWithString:self.tintColorString];
}

- (UIColor *)themeColor {
    return [UIColor colorWithString:self.themeColorString];
}

@end
