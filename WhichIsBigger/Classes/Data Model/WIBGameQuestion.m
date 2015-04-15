//
//  WIBGameQuestion.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameQuestion.h"
#import "WIBGameItem.h"

@interface WIBGameQuestion ()

@end

@implementation WIBGameQuestion

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2
{
    self = [super init];
    if (self)
    {
        _option1 = item1;
        _option2 = item2;
        NSAssert(item1.categoryType == item2.categoryType, @"GameItems are not the same type");
    }
    
    return self;
}

- (double)multiplier
{
    //TODO: Return an intelligent Multiplier
    return self.option1.quantity.doubleValue/self.option2.quantity.doubleValue;
}

- (NSString *)questionText
{
    switch (self.option1.categoryType)
    {
        case(WIBCategoryTypeHeight):
            return @"Which is Taller?";
        case(WIBCategoryTypeWeight):
            return @"Which is Heavier?";
        case(WIBCategoryTypeAge):
            return @"Which is Older?";
        case(WIBCategoryTypePrice):
            return @"Which is Worth More?";
        default:
            break;
    }
    return nil;
}

- (NSNumber *)total1
{
    return [NSNumber numberWithDouble: self.multiplier1 * self.option1.quantity.doubleValue];
}

- (NSNumber *)total2
{
    return [NSNumber numberWithDouble: self.multiplier2 * self.option2.quantity.doubleValue];
}

- (WIBGameItem *)answer
{
    NSAssert(self.total1!=self.total2,@"Totals cannot be equal!");
    if (self.total1 > self.total2)
        return self.option1;
    else
    {
        return self.option2;
    }
}

@end
