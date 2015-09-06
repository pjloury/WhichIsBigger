//
//  WIBDissimilarHeightQuestion.m
//  
//
//  Created by PJ Loury on 8/22/15.
//
//

#import "WIBDissimilarHeightQuestion.h"
#import "WIBDataModel.h"

@implementation WIBDissimilarHeightQuestion

- (id)init
{
    WIBGameItem *item1 = [[WIBDataModel sharedInstance] firstGameItemForCategoryType:WIBCategoryTypeHeight];
    // Choice.. intentionally make it very different
    WIBGameItem *item2 = [[WIBDataModel sharedInstance] secondGameItemForCategoryType:WIBCategoryTypeHeight dissimilarTo:item1 orderOfMagnitude:50.0];
    return [super initWithDissimilarGameItem:item1 dissimilargameItem2:item2];
}

@end
