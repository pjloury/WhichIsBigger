//
//  WIBGameQuestion.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"

@interface WIBGameQuestion : NSObject

@property (nonatomic, strong) WIBGameItem *option1;
@property (nonatomic, strong) WIBGameItem *option2;
@property (nonatomic, strong) NSNumber *total1;
@property (nonatomic, strong) NSNumber *total2;
@property (nonatomic) double multiplier;

- (id)initWithGameItem:item1 gameItem2:item2;

@end
