//
//  WIBHumanComparisonQuestion.h
//  
//
//  Created by PJ Loury on 5/17/15.
//
//

#import <UIKit/UIKit.h>
#import "WIBGameQuestion.h"
@class WIBGameItem;

@interface WIBHumanComparisonQuestion : WIBGameQuestion

- (id)initWithGameItem:(WIBGameItem *)item1 gameItem2:(WIBGameItem *)item2;

@end
