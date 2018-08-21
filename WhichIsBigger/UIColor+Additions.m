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

@interface UIColor ()

@property NSMutableArray *colors;

@end

@implementation UIColor (Additions)

+ (UIColor *)lighterGrayColor {
    return[UIColor colorWithRed:175/255 green:68/255 blue:255/255 alpha:0.17];
}
//[UIColor colorWithRed:0.686 green:0.267 blue:1.0 alpha:1.0].CGColor;

+ (UIColor *)faintPurpleColor {
    return UIColorFromRGB(0xFFFAFF);
}

+ (UIColor *)pastelPurpleColor {
    return UIColorFromRGB(0xF7E7FE);
}

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

+ (UIColor *)quickAnswerColor {
    return UIColorFromRGB(0x1FDE31);
}

+ (UIColor *)slowAnswerColor {
    return [UIColor lightPurpleColor];
}

+ (UIColor *)randomColor
{
    NSArray *colors = [UIColor colorArray];
    int r = arc4random() % [colors count];
    return [colors objectAtIndex:r];
}

+ (NSArray *)randomColorPair
{
    int r1 = arc4random() % [UIColor colorArray].count;
    int r2 = arc4random() % [UIColor colorArray].count;
    while (abs(r2-r1)< 4) {
        r2 = arc4random() % [UIColor colorArray].count;
    }
    return @[[UIColor colorArray][r1], [UIColor colorArray][r2]];
}

+ (NSArray *)colorArray {
    return @[
             [UIColor sexyPinkColor],
             [UIColor sexyRedColor],
             [UIColor sexyOrangeColor],
             [UIColor sexyDeepOrangeColor],
             [UIColor sexyAmberColor],
             [UIColor sexyLightGreenColor],
             [UIColor sexyLimeColor],
             [UIColor sexyGreenColor],
             [UIColor sexyTealColor],
             [UIColor sexyCyanColor],
             [UIColor sexyLightBlueColor],
             [UIColor sexyBlueColor],
             [UIColor sexyIndigoColor],
             [UIColor sexyPurpleColor],
             [UIColor sexyDeepPurpleColor]
             ];
}

+ (NSArray *)backgroundColorArray {
    return @[
             [UIColor sexyLightGreenColor],
             [UIColor sexyIndigoColor],
             [UIColor sexyPinkColor],
             [UIColor sexyCyanColor],
             [UIColor sexyPurpleColor],
             [UIColor sexyTealColor],
             [UIColor sexyRedColor],
             [UIColor sexyBlueColor],
             [UIColor sexyGreenColor],
             [UIColor sexyDeepPurpleColor]
             ];
}

+ (NSArray *)cgColorArray {
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *color in [UIColor colorArray]) {
        [array addObject:(id)[color CGColor]];
    }
    return [NSArray arrayWithArray:array];
}

+ (NSMutableArray *)randomColors
{
    NSMutableArray *colors = [[UIColor colorArray] mutableCopy];
    [colors shuffle];
    return colors;
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

+ (UIColor *)colorWithString:(NSString *)hexString
{
    NSMutableString *tempHex=[[NSMutableString alloc] init];
    [tempHex appendString:hexString];
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:tempHex] scanHexInt:&colorInt];
    return UIColorFromRGB(colorInt);
}

+ (UIColor *)colorForLevel:(NSInteger)level
{
    NSInteger index = level % [UIColor backgroundColorArray].count;
    return [UIColor backgroundColorArray][index];
}

@end
