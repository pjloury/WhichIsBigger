//
//  WIBDissimilarQuestion.m
//  
//
//  Created by PJ Loury on 8/22/15.
//
//

#import "WIBDissimilarQuestion.h"
#import "WIBDataModel.h"

@implementation WIBDissimilarQuestion

- (id)initWithQuestionType:(WIBQuestionType *)questionType;
{
    WIBGameItem *item1 = [[WIBDataModel sharedInstance] firstGameItemForCategory:questionType.category];
    // Choice.. intentionally make it very different
    WIBGameItem *item2 = [[WIBDataModel sharedInstance] secondGameItemForCategory:questionType.category dissimilarTo:item1 orderOfMagnitude:50.0];
    self.questionType = questionType;
    return [super initWithDissimilarGameItem:item1 dissimilargameItem2:item2];
}

@end
