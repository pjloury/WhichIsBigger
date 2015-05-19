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
    switch(self.item.categoryType)
    {
        case WIBCategoryTypeHeight:
        {
            NSInteger feet = [self.total integerValue]/12;
            if(feet < 10)
            {
                NSInteger inches = [self.total integerValue]%12;
                return [NSString stringWithFormat:@"%lu\' %lu\"", feet, inches];
            }
            else
            {
                return [NSString stringWithFormat:@"%@ ft", @(feet).description];
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
            NSCalendarUnit unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
            NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];

            
            return [NSString stringWithFormat:@"%ld years %ld months", [breakdownInfo year],[breakdownInfo month]];
        }
        case WIBCategoryTypeWeight:
        {
            NSInteger pounds = [self.total integerValue];
            return [NSString stringWithFormat:@"%@ lbs", @(pounds).description];
        }
        default:
            return @"iono";
    }
}

@end
