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
    if ([self.item.unit isEqualToString:@"epoch"] || [self.item.unit isEqualToString:@"years"]) {
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
    else if ([self.item.unit isEqualToString:@"years"])
    {
        NSTimeInterval dateEpoch = self.item.baseQuantity.doubleValue;
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:dateEpoch];
        
        NSDate *now = [[NSDate alloc] init];

        
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear|NSCalendarUnitMonth
                                           fromDate:date
                                           toDate:now
                                           options:0];
        
        if (ageComponents.month > 0){
            return [NSString stringWithFormat:@"%ld years %ld months", ageComponents.year, ageComponents.month];
        } else {
            return [NSString stringWithFormat:@"%ld years", ageComponents.year];
        }
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
