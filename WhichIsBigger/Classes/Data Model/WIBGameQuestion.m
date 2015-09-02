//
//  WIBGameQuestion.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGamePlayManager.h"
#import "WIBGameQuestion.h"
#import "WIBDataModel.h"
#import "WIBGameItem.h"

@interface WIBGameQuestion ()

@end

@implementation WIBGameQuestion

- (instancetype)initOneToOneQuestion:(WIBCategoryType)categoryType
{
    self = [super init];
    if (self)
    {
        WIBGameItem *item1 = [[WIBDataModel sharedInstance] firstGameItemForCategoryType:categoryType];
        WIBGameItem *item2 = [[WIBDataModel sharedInstance] secondGameItemForCategoryType:categoryType withRespectToItem:item1 withQuestionCeiling:[WIBGamePlayManager sharedInstance].questionCeiling];
        _option1 = [[WIBGameOption alloc] initWithItem:item1 multiplier:1];
        _option2 = [[WIBGameOption alloc] initWithItem:item2 multiplier:1];
    }
    return self;
}

- (instancetype)initWithDissimilarGameItem:(WIBGameItem *)item1 dissimilargameItem2:(WIBGameItem *)item2
{
    self = [super init];
    if (self)
    {
        // Pass Zeros temporarily
        _option1 = [[WIBGameOption alloc] initWithItem:item1 multiplier:0];
        _option2 = [[WIBGameOption alloc] initWithItem:item2 multiplier:0];
        // Determine challenging
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
        
    // random # between 0 and 1
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    
    double r;
    if (val <= 0.5)
    {
        r = val -.75;
    }
    else
    {
        r = val + .75;
    }
    
    // random # between -1 and 1
    //double r = val * 2 -1;
    
    // random # normalized to correct answer, adjusted with difficulty (low number means easier)
    double skew = r * self.answerQuantity;
    NSLog(@"Before multipliers: options are %.2f%% different",skew/self.answerQuantity*100);
    
    // multiplier that will be associated with smaller item
    int multiplier = (int)ceil(self.answerQuantity + skew);
    
    // round to the nearest 100
    if (multiplier > 100)
    {
        multiplier = 100.0 * floor((multiplier/100.0)+0.5);
    }
    // round to the nearest 10
    else
    {
        multiplier = 10.0 * floor((multiplier/10.0)+0.5);
    }
    
    if(smallerItem == self.option1.item)
    {
        self.option1.multiplier = multiplier;
        self.option2.multiplier = 1;
        if(self.option1.total.doubleValue == self.option2.total.doubleValue)
        {
            NSAssert(NO,@"Why are the totals equal?");
            self.option2.multiplier++;
        }
    }
    else
    {
        self.option1.multiplier = 1;
        self.option2.multiplier = multiplier;
        if(self.option1.total.doubleValue == self.option2.total.doubleValue)
        {
            NSAssert(NO,@"Why are the totals equal?");
            self.option1.multiplier++;
        }
    }
    NSLog(@"Scaling Question: %@ vs. %@ with %.2f%% skew",self.option1.item.name, self.option2.item.name, (float)((multiplier-self.answerQuantity)/self.answerQuantity)*100);
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
        case(WIBCategoryTypeDissimilarHeight):
            categoryQuestionString = @"is DIFFERENT Taller?";
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
        return self.option1;
    }
    else
    {
        return self.option2;
    }
}

@end
