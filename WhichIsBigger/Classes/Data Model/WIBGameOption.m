//
//  WIBGameOption.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/27/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGameOption.h"

@implementation WIBGameOption

- (id)initWithItem:(WIBGameItem *)item multiplier:(int)multiplier
{
    if (self = [super init]) {
        _item = item;
        _multiplier = multiplier;
    }
    return self;
}

- (NSString *)multiplierString
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    return [fmt stringFromNumber:@(self.multiplier)];
}

- (NSNumber *)total
{
    if ([self.item.unit isEqualToString:@"epoch"]) {
        NSTimeInterval currentEpoch = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval age = currentEpoch - self.item.baseQuantity.doubleValue;
        return [NSNumber numberWithDouble:age];
    }
    return [NSNumber numberWithDouble: self.multiplier * self.item.baseQuantity.doubleValue];
}

- (NSString *)totalString
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    
    if ([self.item.unit isEqualToString:@"inches"] || [self.item.unit isEqualToString:@"meters"])
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
    else if ([self.item.unit isEqualToString:@"date"])
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
    else if ([self.item.unit isEqualToString:@"epoch"]) {
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        NSDate *date= [[NSDate alloc] initWithTimeIntervalSince1970:self.item.baseQuantity.doubleValue];
        NSCalendarUnit unitFlags = NSCalendarUnitYear;
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date];
        return [NSString stringWithFormat:@"%ld",breakdownInfo.year];
    }
    else if ([self.item.unit isEqualToString:@"dollars"]) {
        if ([self.total longValue] > 999999 && [self.total longValue] <= 999999999) {
            float millions = [self.total floatValue] / 1000000;
            return [NSString stringWithFormat:@"$%.2f Million", millions];
        }
        else if ([self.total longValue] > 999999999 && [self.total longValue] <= 999999999999)
        {
            float billions = [self.total floatValue] / 1000000000;
            return [NSString stringWithFormat:@"$%.2f Billion", billions];
        }
        else if ([self.total longValue] > 999999999999)
        {
            float trillions = [self.total floatValue] / 1000000000000;
            return [NSString stringWithFormat:@"$%.2f Trillion", trillions];
        }
        else {
            return [NSString stringWithFormat:@"$%@", [fmt stringFromNumber:self.total]];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@", [fmt stringFromNumber:self.total], self.item.unit];
    }
}

@end
