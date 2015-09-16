//
//  WIBOptionButton.h
//  WhichIsBigger
//
//  Created by PJ Loury on 8/20/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBPopButton.h"
#import "WIBOptionView.h"

@interface WIBOptionButton : WIBPopButton

@property (nonatomic, weak) id<WIBOptionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@end
