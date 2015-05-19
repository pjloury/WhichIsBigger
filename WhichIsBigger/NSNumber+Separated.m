//
//  NSNumber+Separated.m
//  WhichIsBigger
//
//  Created by PJ Loury on 5/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "NSNumber+Separated.h"

@implementation NSNumber (Separated)

- (NSString *)separatedValue
{
    static NSNumberFormatter *separator = nil;
    
    if (separator == nil)
    {
        separator = [[NSNumberFormatter alloc] init];
        separator.usesGroupingSeparator = YES;
        separator.groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        separator.groupingSize = 3;
    }
    
    return [separator stringFromNumber:self];
}

@end
