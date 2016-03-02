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
    UIImage *image = [UIImage imageNamed:@"smallQuestionMark"];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];   
}

+ (UIImage *)trophy {
    UIImage *image = [UIImage imageNamed:@"trophy"];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
