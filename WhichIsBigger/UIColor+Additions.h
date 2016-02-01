//
//  UIColor+Additions.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)lighterGrayColor;
+ (UIColor *)lightPurpleColor;
+ (UIColor *)sexyRedColor;
+ (UIColor *)sexyPinkColor;
+ (UIColor *)sexyPurpleColor;
+ (UIColor *)sexyLightPurpleColor;
+ (UIColor *)sexyDeepPurpleColor;
+ (UIColor *)sexyIndigoColor;
+ (UIColor *)sexyBlueColor;
+ (UIColor *)sexyLightBlueColor;
+ (UIColor *)sexyCyanColor;
+ (UIColor *)sexyTealColor;
+ (UIColor *)sexyGreenColor;
+ (UIColor *)sexyLightGreenColor;
+ (UIColor *)sexyLimeColor;
+ (UIColor *)sexyYellowColor;
+ (UIColor *)sexyAmberColor;
+ (UIColor *)sexyOrangeColor;
+ (UIColor *)sexyDeepOrangeColor;

+ (NSMutableArray *)randomColors;

+ (CAGradientLayer *)gradientLayerWithColor:(UIColor *)color;

@end
