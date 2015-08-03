//
//  WIBDataModel.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"

@interface WIBDataModel : NSObject 
+ (WIBDataModel *)sharedInstance;
- (void)insertGameItem:(WIBGameItem *)gameItem;
- (WIBGameItem*)gameItemForCategoryType:(WIBCategoryType)categoryType withUniqueBaseQuantity:(NSNumber *)baseQuantity;

- (WIBGameItem*)firstGameItemForCategoryType:(WIBCategoryType)categoryType;
- (WIBGameItem*)secondGameItemForCategoryType:(WIBCategoryType)categoryType withRespectToItem:(WIBGameItem *)item;

@end
