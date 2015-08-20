//
//  WIBGameOption.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameOption.h"


@implementation WIBGameOption

- (id)initWithItem:(WIBGameItem *)item
{
    if (self = [super init]) {
        _item = item;
    }
    
    return self;
}

- (NSNumber *)total
{
    return [NSNumber numberWithDouble: self.multiplier * self.item.baseQuantity.doubleValue];
}

- (NSString *)totalString
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    
    switch(self.item.categoryType)
    {
        case WIBCategoryTypeHeight:
        {
            NSInteger feet = [self.total integerValue]/12;
            if(feet < 10)
            {
                NSInteger inches = [self.total integerValue]%12;
                return [NSString stringWithFormat:@"%lu\' %lu\"", (long)feet, (long)inches];
            }
            else
            {
                return [NSString stringWithFormat:@"%@ ft", [fmt stringFromNumber:@(feet)]];
            }
        }
        case WIBCategoryTypeAge:
        {
            NSTimeInterval theTimeInterval = self.item.baseQuantity.doubleValue;
            
            // Get the system calendar
            NSCalendar *sysCalendar = [NSCalendar currentCalendar];
            
            // Create the NSDates
            NSDate *date1 = [[NSDate alloc] init];
            NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
            
            // Get conversion to months, days, hours, minutes
            NSCalendarUnit unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
            NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
            
            return [NSString stringWithFormat:@"%ld years %ld months", (long)[breakdownInfo year],(long)[breakdownInfo month]];
        }
        case WIBCategoryTypeWeight:
        {
            return [NSString stringWithFormat:@"%@ lbs", [fmt stringFromNumber:self.total]];
        }
        default:
            return @"";
    }
}

@end
