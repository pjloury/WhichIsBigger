//
//  WIBProgressView.h
//  WhichIsBigger
//
//  Created by PJ Loury on 2/28/16.
//  Copyright © 2016 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WIBProgressViewDelegate;

@interface WIBProgressView : UIView

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated completion:(void(^)())completion;
@property (nonatomic, weak) id<WIBProgressViewDelegate> delegate;

@end

@protocol WIBProgressViewDelegate <NSObject>
- (void)progressViewDidSurpassFullProgress:(WIBProgressView *)progressView;
@end