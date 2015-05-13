//
//  WIBGameItem.h
//  WhichIsBigger
//
//  Created by Christopher Echanique on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WIBCategoryTypeHeight,
    WIBCategoryTypeWeight,
    WIBCategoryTypeAge,
    WIBCategoryTypeCount
} WIBCategoryType;

@interface WIBGameItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photoURL;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *baseQuantity;
@property (nonatomic, readonly) WIBCategoryType categoryType;
@property (nonatomic, assign) NSString *categoryString;
@property (nonatomic, assign) BOOL alreadyUsed;

+ (WIBGameItem *)maxOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2;
+ (WIBGameItem *)minOfItem:(WIBGameItem *)item1 item2:(WIBGameItem *)item2;
+ (NSString *)categoryValueForCategoryType:(WIBCategoryType)type;
- (WIBCategoryType)categoryType;
@end
