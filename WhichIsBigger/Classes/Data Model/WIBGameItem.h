//
//  WIBGameItem.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIBQuestionType;

@interface WIBGameItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photoURL;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *baseQuantity;
@property (nonatomic, copy) NSString *categoryString;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, copy) NSString *objectId;

+ (WIBGameItem *)maxOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2;
+ (WIBGameItem *)minOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2;

- (BOOL)isPerson;
- (BOOL)supportsQuestionType:(WIBQuestionType *)type;
@end
