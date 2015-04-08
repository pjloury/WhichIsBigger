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
    WIBCategoryTypePrice,
    WIBCategoryTypeCount
} WIBCategoryType;

@interface WIBGameItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photoURL;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, assign) WIBCategoryType categoryType;

@end
