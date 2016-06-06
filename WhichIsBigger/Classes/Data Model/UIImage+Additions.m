//
//  UIImage+Additions.m
//  WhichIsBigger
//
//  Created by PJ Loury on 1/31/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)placeholder {
    UIImage *image = [UIImage imageNamed:@"largeQuestionMark"];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];   
}

+ (UIImage *)placeholderWithHeight:(CGFloat)height {
    return [UIImage placeholderWithHeight:height maxHeight:FLT_MAX];
}

+ (UIImage *)placeholderWithHeight:(CGFloat)height maxHeight:(CGFloat)maxHeight {
    UIImage *i = [UIImage imageNamed:@"largeQuestionMark"];
    UIImage *image = [UIImage imageWithImage:i scaledToHeight:height maxHeight:maxHeight];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)trophy {
    UIImage *image = [UIImage imageNamed:@"trophy"];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float)height
{
    return [UIImage imageWithImage:sourceImage scaledToHeight:height maxHeight:FLT_MAX];
}


+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float)height maxHeight: (float)maxHeight
{
    float heightToUse = height > maxHeight ? maxHeight : height;
    
    float oldHeight = sourceImage.size.height;
    float scaleFactor = heightToUse / oldHeight; // 50 /30
    
    float newHeight = oldHeight * scaleFactor;
    float newWidth = sourceImage.size.width * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float)width {
        return [UIImage imageWithImage:sourceImage scaledToWidth:width maxWidth:FLT_MAX];
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float)width maxWidth:(float)maxWidth
{
    float widthToUse = width > maxWidth ? maxWidth : width;
    
    float oldWidth = sourceImage.size.width;
    float scaleFactor = widthToUse / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
