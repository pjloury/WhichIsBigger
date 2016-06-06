//
//  UIImage+Additions.h
//  WhichIsBigger
//
//  Created by PJ Loury on 1/31/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage *)placeholder;
+ (UIImage *)placeholderWithHeight:(CGFloat)height;
+ (UIImage *)placeholderWithHeight:(CGFloat)height maxHeight:(CGFloat)maxHeight;
+ (UIImage *)trophy;
+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToHeight:(float)height maxHeight:(float)maxHeight;

+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToWidth:(float)width;
+ (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToWidth:(float)width maxWidth:(float)maxWidth;



@end
