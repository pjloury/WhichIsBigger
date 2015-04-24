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

- (id)init
{
    self = [super init];
    if (self)
    {
        self.usedAlready = NO;
    }
    return self;
}

//- (WIBCategoryType)categoryType
//{
//    if ([self.categoryString isEqualToString:kHeight])
//        return WIBCategoryTypeHeight;
//    else if ([self.categoryString isEqualToString:kWeight])
//        return WIBCategoryTypeWeight;
//    else if ([self.categoryString isEqualToString:kAge])
//        return WIBCategoryTypeAge;
//    else return 0;
//
//}

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
    if (item1.quantity > item2.quantity)
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
    if (item1.quantity > item2.quantity)
    {
        return item2;
    }
    else
    {
        return item1;
    }
}

@end
