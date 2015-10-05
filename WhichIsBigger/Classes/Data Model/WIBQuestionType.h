//
//  WIBQuestionType.h
//  WhichIsBigger
//
//  Created by PJ Loury on 10/2/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WIBComparisonType) {
    WIBComparisonLikeToLikeType,
    WIBComparisonUnalikeType,
    WIBComparisonCount
};

@interface WIBQuestionType : NSObject

@property (nonatomic) NSString *questionString;
@property (nonatomic) WIBComparisonType comparisonType;
@property (nonatomic) UIColor *themeColor;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *category;

@end
