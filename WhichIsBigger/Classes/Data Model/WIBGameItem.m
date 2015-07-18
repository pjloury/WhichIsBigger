//
//  WIBGameItem.m
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameItem.h"

NSString *kHeight = @"height";
NSString *kWeight = @"weight";
NSString *kAge = @"age";


@implementation WIBGameItem

- (BOOL)isPerson
{
	return [self.tagArray containsObject:@"Person"];
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

- (WIBCategoryType)categoryType
{
    if ([self.categoryString isEqualToString:kHeight])
        return WIBCategoryTypeHeight;
    else if ([self.categoryString isEqualToString:kWeight])
        return WIBCategoryTypeWeight;
    else if ([self.categoryString isEqualToString:kAge])
        return WIBCategoryTypeAge;
    else
        NSAssert(0,@"No categoryString!");
    return 0;
}

+ (NSString *)categoryValueForCategoryType:(WIBCategoryType)type
{
    switch(type)
    {
        case(WIBCategoryTypeHeight): return kHeight;
        case(WIBCategoryTypeWeight): return kWeight;
        case(WIBCategoryTypeAge): return kAge;
        default: return nil;
    }
}

+ (WIBGameItem *)maxOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2
{
    if (item1.baseQuantity > item2.baseQuantity)
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
    if (item1.baseQuantity > item2.baseQuantity)
    {
        return item2;
    }
    else
    {
        return item1;
    }
}

@end
