//
//  WIBGameQuestion.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIBGameItem;
@interface WIBGameQuestion : NSObject

@property (nonatomic, strong) WIBGameItem *option1;
@property (nonatomic, strong) WIBGameItem *option2;
@property (nonatomic) double multiplier1;
@property (nonatomic) double multiplier2;
@property (nonatomic, readonly) NSNumber *total1;
@property (nonatomic, readonly) NSNumber *total2;
@property (nonatomic, readonly) NSString *questionText;

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2;
- (WIBGameItem *)answer;

@end
