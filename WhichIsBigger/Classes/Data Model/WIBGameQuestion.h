//
//  WIBGameQuestion.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIBGameItem;
@class WIBGameOption;
@interface WIBGameQuestion : NSObject

@property (nonatomic, strong) WIBGameOption *option1;
@property (nonatomic, strong) WIBGameOption *option2;
@property (nonatomic, readonly) NSString *questionText;

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2;
- (WIBGameOption *)answer;

@end
