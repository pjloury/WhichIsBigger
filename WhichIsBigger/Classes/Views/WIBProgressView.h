//
//  WIBProgressView.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIBProgressView : UIView

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void(^)())completion;

@end
