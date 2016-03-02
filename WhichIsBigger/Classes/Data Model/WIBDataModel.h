//
//  WIBDataModel.h
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WIBGameItem.h"

@class WIBQuestionType;

@interface WIBDataModel : NSObject 
+ (WIBDataModel *)sharedInstance;
- (void)insertGameItem:(WIBGameItem *)gameItem;

- (WIBGameItem*)firstGameItemForQuestionType:(WIBQuestionType *)type;
//- (WIBGameItem*)firstNonHumanGameItemForQuestionType:(WIBQuestionType *)type;

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type dissimilarTo:(WIBGameItem *)item orderOfMagnitude:(double)magnitude;

- (WIBGameItem*)secondGameItemForQuestionType:(WIBQuestionType *)type withRespectToItem:(WIBGameItem *)item withQuestionCeiling:(double)questionCeiling;

@end
