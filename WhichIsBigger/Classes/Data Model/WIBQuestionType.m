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

@dynamic clarifyingString;
@dynamic comparisonType;
@dynamic category;
@dynamic title;
@dynamic backgroundColorString;
@dynamic labelThemeColorString;
@dynamic tintColorString;
@dynamic themeColorString;
@dynamic pointsToUnlock;
@dynamic safePointsToUnlock;
@dynamic image;
@dynamic imageURL;
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

- (UIColor *)labelThemeColor {
    return [UIColor colorWithString:self.labelThemeColorString];
}

- (NSNumber *)puntosToUnlock {
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *latestVersion = [[PFConfig currentConfig] objectForKey:@"latestVersion"];
    if ([latestVersion isEqualToString:version]) {
        return self.safePointsToUnlock;
    } else {
        return self.pointsToUnlock;
    }
}


@end
