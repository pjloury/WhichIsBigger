//
//  WIBGameQuestion.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGamePlayManager.h"
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
        _option1 = [[WIBGameOption alloc] initWithItem:item1];
        _option2 = [[WIBGameOption alloc] initWithItem:item2];
        
        [self setupOptions];
    }
    
    return self;
}

- (void)setupOptions
{
    WIBGameItem *largerItem = [WIBGameItem maxOfItem:self.option1.item item2:self.option2.item];
    WIBGameItem *smallerItem = [WIBGameItem minOfItem:self.option1.item item2:self.option2.item];
    
    // it actually takes 230.3 Kanyes...
    self.answerQuantity = largerItem.baseQuantity.doubleValue / smallerItem.baseQuantity.doubleValue;
    
    // We need to know
    if(self.answerQuantity < 2 && self.option1.item.categoryType == WIBCategoryTypeHeight)
    {
        self.option1.multiplier = 1;
        self.option2.multiplier = 1;
        return;
    }
    
    
    // random # between 0 and 1
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    // random # between -1 and 1
    double r = val * 2 -1;
    // random # normalized to correct answer, adjusted with difficulty (low number means easier)
    double skew = r * self.answerQuantity * ([WIBGamePlayManager sharedInstance].difficulty)/100;
    
    // multiplier that will be associated with smaller item
    int multiplier = (int)ceil(self.answerQuantity + skew);
    
    if(smallerItem == self.option1.item)
    {
        self.option1.multiplier = multiplier;
        self.option2.multiplier = 1;
        if(self.option1.total.doubleValue == self.option2.total.doubleValue)
        {
            self.option2.multiplier++;
        }
    }
    else
    {
        self.option1.multiplier = 1;
        self.option2.multiplier = multiplier;
        if(self.option1.total.doubleValue == self.option2.total.doubleValue)
        {
            self.option1.multiplier++;
        }
    }
}

- (NSString *)questionText
{
    NSString *questionVerb = nil;
    
    if(self.option1.item.isPerson && self.option2.item.isPerson)
        questionVerb = @"Who";
    else
        questionVerb = @"Which";

    NSString *categoryQuestionString = nil;
    switch (self.option1.item.categoryType)
    {
        case(WIBCategoryTypeHeight):
            categoryQuestionString = @"is Taller?";
            break;
        case(WIBCategoryTypeWeight):
            categoryQuestionString = @"is Heavier?";
            break;
        case(WIBCategoryTypeAge):
            categoryQuestionString = @"is Older?";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %@",questionVerb, categoryQuestionString];
}

- (WIBGameOption *)answer
{
    NSLog(@"Option 1 Total: %@ Option 2 Total: %@", self.option1.total, self.option2.total);
    NSAssert(self.option1.total!=self.option2.total,@"Totals cannot be equal!");
    if (self.option1.total.doubleValue > self.option2.total.doubleValue)
    {
        NSLog(@"This is option 1: %@",self.option1.item.name);
        return self.option1;
    }
    else
    {
        NSLog(@"This is option 2: %@",self.option2.item.name);
        return self.option2;
    }
}

@end
