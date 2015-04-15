//
//  WIBGameItem.m
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameItem.h"

@implementation WIBGameItem

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
