//
//  WIBGameItem.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameItem.h"
#import "WIBGamePlayManager.h"

@implementation WIBGameItem

- (BOOL)isPerson
{
	return [self.tagArray containsObject:@"person"];
}

- (BOOL)supportsQuestionType:(WIBQuestionType *)type
{
    NSMutableArray *requiredTags = [[type.name componentsSeparatedByString:@":"] mutableCopy];
    [requiredTags removeObjectAtIndex:0];
    
    BOOL questionTypeConstraintSatisfied = (requiredTags.count == 0);
    
    return YES;
    
}

- (void)setTagArray:(NSArray *)tagArray
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (NSString *tag in tagArray)
    {
        NSString *trimmedString = [tag stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        [tags addObject:trimmedString.lowercaseString];
    }
    _tagArray = tags;
}

- (NSNumber *)baseQuantity
{
    if([self.unit isEqualToString:@"meters"])
    {
        return [NSNumber numberWithDouble:[_baseQuantity doubleValue] * 39.3701];
    }
    else
    {
        return _baseQuantity;
    }
}

+ (WIBGameItem *)maxOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2
{
    if (item1.baseQuantity.doubleValue > item2.baseQuantity.doubleValue)
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
    if (item1.baseQuantity.doubleValue > item2.baseQuantity.doubleValue)
    {
        return item2;
    }
    else
    {
        return item1;
    }
}

- (NSString *)description
{
    return self.name;
}

@end
