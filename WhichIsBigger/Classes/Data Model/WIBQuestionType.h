//
//  WIBQuestionType.h
//  WhichIsBigger
//
//  Created by PJ Loury on 10/2/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, WIBComparisonType) {
    WIBComparisonLikeToLikeType,
    WIBComparisonUnalikeType,
    WIBComparisonSmallerWinsType,
    WIBComparisonCount
};

@interface WIBQuestionType : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic) WIBComparisonType comparisonType;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *backgroundColorString;
@property (nonatomic) NSString *labelThemeColorString;
@property (nonatomic) NSString *themeColorString;
@property (nonatomic) NSString *tintColorString;
@property (nonatomic) NSNumber *pointsToUnlock;
@property (nonatomic) PFFile *image;
@property (nonatomic) NSString *questionString;
@property (nonatomic) NSString *clarifyingString;
@property (nonatomic) NSString *name;

- (UIColor *)backgroundColor;
- (UIColor *)tintColor;
- (UIColor *)themeColor;
- (UIColor *)labelThemeColor;

@end
