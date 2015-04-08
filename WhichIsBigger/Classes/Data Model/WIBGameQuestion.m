//
//  WIBGameQuestion.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameQuestion.h"

@interface WIBGameQuestion ()

@end

@implementation WIBGameQuestion

- (id)initWithGameItem:item1 gameItem2:item2;
{
    self = [super init];
    if (self)
    {
        _option1 = item1;
        _option2 = item2;
    
    }
    
    return self;
}

- (double)multiplier
{
    //TODO: Return an intelligent Multiplier
    return self.option1.quantity.doubleValue/self.option2.quantity.doubleValue;
}

@end
