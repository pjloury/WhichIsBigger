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
            return @"Which is taller?";
        case(WIBCategoryTypeWeight):
            return @"Which is heavier?";
        case(WIBCategoryTypeAge):
            return @"Which is older?";
        case(WIBCategoryTypePrice):
            return @"Which is worth more?";
        default:
            break;
    }
    return nil;
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
