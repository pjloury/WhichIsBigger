//
//  WIBHumanComparisonQuestion.m
//  
//
//  Created by PJ Loury on 5/17/15.
//
//

#import "WIBHumanComparisonQuestion.h"
#import "WIBGameItem.h"

@implementation WIBHumanComparisonQuestion

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2
{
    self = [super initWithGameItem:item1 gameItem2:item2];
    [self setupOptions];
    
    return self;
}

- (void)setupOptions
{
    self.option1.multiplier = 1;
    self.option2.multiplier = 1;
}

@end
