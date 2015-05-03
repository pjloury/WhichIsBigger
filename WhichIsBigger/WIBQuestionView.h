//
//  WIBQuestionView.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/28/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIBGameQuestion;

@interface WIBQuestionView : UIView

- (instancetype)initWithGameQuestion:(WIBGameQuestion *)question;

@end
