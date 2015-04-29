//
//  WIBGameQuestion.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameQuestion.h"
#import "WIBGameItem.h"
#import "WIBGameOption.h"

@interface WIBGameQuestion ()

@end

@implementation WIBGameQuestion

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2
{
    self = [super init];
    if (self)
    {
        _option1 = [[WIBGameOption alloc] initWithItem:item1];
        _option2 = [[WIBGameOption alloc] initWithItem:item2];
        
        NSAssert(item1.categoryType == item2.categoryType, @"GameItems are not the same type");
    }
    
    return self;
}

- (NSString *)questionText
{
    switch (self.option1.item.categoryType)
    {
        case(WIBCategoryTypeHeight):
            return @"Which is Taller?";
        case(WIBCategoryTypeWeight):
            return @"Which is Heavier?";
        case(WIBCategoryTypeAge):
            return @"Which is Older?";
        default:
            break;
    }
    return nil;
}

- (WIBGameOption *)answer
{
    NSAssert(self.option1.total!=self.option2.total,@"Totals cannot be equal!");
    if (self.option1.total > self.option2.total)
    {
        return self.option1;
    }
    else
    {
        return self.option2;
    }
}

@end
