//
//  UIImage+Placeholder.m
//  WhichIsBigger
//
//  Created by PJ Loury on 1/31/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import "UIImage+Placeholder.h"

@implementation UIImage (Placeholder)

+ (UIImage *)placeholder {
    UIImage *image = [UIImage imageNamed:@"smallQuestionMark"];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];   
}

@end
