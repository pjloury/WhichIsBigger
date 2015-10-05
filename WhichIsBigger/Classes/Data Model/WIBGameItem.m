//
//  WIBGameItem.m
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"

@implementation WIBGameItem

- (BOOL)isPerson
{
	return [self.tagArray containsObject:@"person"];
}

- (BOOL)isSupported
{
    for (NSString *tag in self.tagArray)
    {
        if ([((NSArray *)[PFConfig currentConfig][@"tagBlackList"]) containsObject:tag.lowercaseString])
        {
            return NO;
        }
    }
    return YES;
}

- (void)setTagArray:(NSArray *)tagArray
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSString *tag in tagArray)
    {
        NSString *trimmedString = [tag stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        [tags addObject:trimmedString.lowercaseString];
    }
    _tagArray = tags;
}

- (NSNumber *)baseQuantity
{
    if([self.unit isEqualToString:@"meters"])
    {
        return [NSNumber numberWithDouble:[_baseQuantity doubleValue] * 39.3701];
    }
    else if([self.unit isEqualToString:@"date"])
    {
        NSTimeInterval currentEpoch = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval age = currentEpoch - _baseQuantity.doubleValue;
        return [NSNumber numberWithDouble:age];
    }
    else
    {
        return _baseQuantity;
    }
}

+ (WIBGameItem *)maxOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2
{
    if (item1.baseQuantity.doubleValue > item2.baseQuantity.doubleValue)
    {
        return item1;
    }
    else
    {
        return item2;
    }
}

+ (WIBGameItem *)minOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2
{
    if (item1.baseQuantity.doubleValue > item2.baseQuantity.doubleValue)
    {
        return item2;
    }
    else
    {
        return item1;
    }
}

@end
