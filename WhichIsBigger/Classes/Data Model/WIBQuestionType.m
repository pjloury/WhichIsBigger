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

- (id) initWith: (WIBComparisonType) comparisonType category: (NSString *) category title: (NSString *) title primaryColor: (NSString *) primaryColor secondaryColor: (NSString *) secondaryColor pointsToUnlock: (NSNumber *) pointsToUnlock imageURL: (NSString *) imageURL questionString: (NSString *) questionString {
    self = [super init];
    if (self) {
        _comparisonType = comparisonType;
        _category = category;
        _title = title;
        _backgroundColorString = primaryColor;
        _labelThemeColorString = secondaryColor;
        _tintColorString = secondaryColor;
        _themeColorString = secondaryColor;
        _pointsToUnlock = pointsToUnlock;
        _imageURL = imageURL;
        _questionString = questionString;
        _clarifyingString = title;
        _name = title;
        
    }
    return self;
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


@end
