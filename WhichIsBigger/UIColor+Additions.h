//
//  UIColor+Additions.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

// Purple Colors
+ (UIColor *)faintPurpleColor;
+ (UIColor *)pastelPurpleColor;
+ (UIColor *)lightPurpleColor;
+ (UIColor *)darkPurpleColor;

// Question Colors
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

// Answer Colors
+ (UIColor *)quickAnswerColor;
+ (UIColor *)slowAnswerColor;
+ (UIColor *)correctAnswerGreenColor;
+ (UIColor *)incorrectAnswerRedColor;

// Utility Functions
+ (UIColor *)colorWithString:(NSString *)hexString;
+ (UIColor *)colorForLevel:(NSInteger)level;
+ (UIColor *)randomColor;
+ (NSArray *)randomColorPair;
+ (NSMutableArray *)randomColors;
+ (CAGradientLayer *)gradientLayerWithColor:(UIColor *)color;

@end
