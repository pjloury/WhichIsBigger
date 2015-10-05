//
//  UIColor+Additions.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "UIColor+Additions.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation UIColor (Additions)

+ (UIColor *)lighterGrayColor {
    return[UIColor colorWithRed:175/255 green:68/255 blue:255/255 alpha:0.17];
}
//[UIColor colorWithRed:0.686 green:0.267 blue:1.0 alpha:1.0].CGColor;

+ (UIColor *)lightPurpleColor {
    return UIColorFromRGB(0x9D1BFF);
}

+ (UIColor *)sexyRedColor {
    return UIColorFromRGB(0xF44336);
}

+ (UIColor *)sexyPinkColor {
    return UIColorFromRGB(0xE91E63);
}

+ (UIColor *)sexyPurpleColor {
    return UIColorFromRGB(0x9C27B0);
}

+ (UIColor *)sexyDeepPurpleColor {
    return UIColorFromRGB(0x673AB7);
}

+ (UIColor *)sexyIndigoColor {
    return UIColorFromRGB(0x3F51B5);
}

+ (UIColor *)sexyBlueColor {
    return UIColorFromRGB(0x2196F3);
}

+ (UIColor *)sexyLightBlueColor {
    return UIColorFromRGB(0x03A9F4);
}

+ (UIColor *)sexyCyanColor {
    return UIColorFromRGB(0x00BCD4);
}

+ (UIColor *)sexyTealColor {
    return UIColorFromRGB(0x009688);
}

+ (UIColor *)sexyGreenColor {
    return UIColorFromRGB(0x4CAF50);
}

+ (UIColor *)sexyLightGreenColor {
    return UIColorFromRGB(0x8BC34A);
}

+ (UIColor *)sexyLimeColor {
    return UIColorFromRGB(0xCDDC39);
}

+ (UIColor *)sexyYellowColor {
    return UIColorFromRGB(0xFFEB3B);
}

+ (UIColor *)sexyAmberColor {
    return UIColorFromRGB(0xFFC107);
}

+ (UIColor *)sexyOrangeColor {
    return UIColorFromRGB(0xFF9800);
}

+ (UIColor *)sexyDeepOrangeColor {
    return UIColorFromRGB(0xFF5722);
}

+ (UIColor *)sexyLightPurpleColor {
    return [UIColor colorWithRed:175 green:68 blue:255 alpha:.17];
}

+ (NSArray *)colorArray {
    return @[
             [UIColor sexyRedColor],
             [UIColor sexyPinkColor],
             [UIColor sexyPurpleColor],
             [UIColor sexyDeepPurpleColor],
             [UIColor sexyIndigoColor],
             [UIColor sexyBlueColor],
             [UIColor sexyLightBlueColor],
             [UIColor sexyCyanColor],
             [UIColor sexyTealColor],
             [UIColor sexyGreenColor],
             [UIColor sexyLightGreenColor],
             [UIColor sexyLimeColor],
             [UIColor sexyYellowColor],
             [UIColor sexyAmberColor],
             [UIColor sexyOrangeColor],
             [UIColor sexyDeepOrangeColor]
             ];
}

+ (NSArray *)cgColorArray {
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *color in [UIColor colorArray]) {
        [array addObject:(id)[color CGColor]];
    }
    return [NSArray arrayWithArray:array];
}

+ (CAGradientLayer *)gradientLayerWithColor:(UIColor *)color {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSUInteger firstColorIndex = [[UIColor colorArray] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [color isEqual:obj];
    }];
    if (firstColorIndex != NSNotFound) {
        NSUInteger secondColorIndex = firstColorIndex + 1;
        if (secondColorIndex >= [[UIColor colorArray] count]) {
            secondColorIndex = 0;
        }
        UIColor *firstColor = [[UIColor colorArray] objectAtIndex:firstColorIndex];
        UIColor *secondColor = [[UIColor colorArray] objectAtIndex:secondColorIndex];
        
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[firstColor CGColor], (id)[secondColor CGColor], nil];
    }
    return gradientLayer;
}


@end
