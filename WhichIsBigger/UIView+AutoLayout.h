//
//  UIView+UIView_AutoLayout.h
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (void)ic_pinToSuperViewHorizontallyWithWidth:(NSNumber *)width;

- (NSArray *)ic_pinToSuperViewVerticallyToBottomWithHeight:(NSNumber *)height;

- (NSArray *)ic_pinViewToTopAndBottomOfSuperView;

- (NSArray *)ic_pinViewToLeftAndRightEdgesOfSuperView;

- (NSArray *)ic_pinViewToAllSidesOfSuperView;
- (NSArray *)ic_pinViewToAllSidesOfSuperViewWithPadding:(CGFloat)padding;
- (NSArray *)ic_pinViewToLeftAndRightEdgesOfSuperViewWithPadding:(CGFloat)padding;
- (NSArray *)ic_pinViewToTopAndBottomEdgesOfSuperViewWithPadding:(CGFloat)padding;

- (NSArray *)ic_centerViewHorizontallyInMargins:(UIEdgeInsets)margins;

- (NSArray *)ic_addVflContrstraints:(NSString *)vfl;

- (NSArray *)ic_centerHorizontallyInSuperView;

- (NSArray *)ic_centerVerticallyInSuperView;
-(NSArray*)ic_centerViewInMargins:(UIEdgeInsets)margins;

- (NSArray *)ic_pinToBottomRightCornerOfSuperViewWithBottomSpacing:(CGFloat)bottomSpace trailingSpacing:(CGFloat)trailingSpacing;
- (NSArray *)ic_addDimensionConstraintsWithWidth:(CGFloat)width height:(CGFloat)height;

- (NSLayoutConstraint *)ic_findConstraintMatchingViewWithFirstAttribute:(NSLayoutAttribute)attrib1 secondAttribute:(NSLayoutAttribute)attrib2;

- (NSArray*)ic_setWidth:(CGFloat)width;
- (NSArray*)ic_setHeight:(CGFloat)height;
- (NSLayoutConstraint*)ic_constraintForWidthAttributeEqualtToView:(UIView*)view multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint*)ic_constraintForHeightAttributeEqualtToView:(UIView*)view multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint*)ic_equalRelationConstraintForAttribute:(NSLayoutAttribute)attribute toView:(UIView*)view multiplier:(CGFloat)multiplier;
- (NSLayoutConstraint*)ic_equalRelationConstraintForAttribute:(NSLayoutAttribute)attribute toView:(UIView*)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

@end
