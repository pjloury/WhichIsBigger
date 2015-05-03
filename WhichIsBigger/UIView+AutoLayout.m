//
//  UIView+UIView_AutoLayout.m
//  WhichIsBigger
//
//  Created by Chris Echanique on 4/14/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)
- (void)ic_pinToSuperViewHorizontallyWithWidth:(NSNumber *)width {
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSString *afl = [NSString stringWithFormat:@"H:|[self%@]|", width ? [NSString stringWithFormat:@"(%@)", width] : @""];
    if (self.superview)
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:afl options:0 metrics:nil views:bindings]];
}

- (NSArray *)ic_pinToSuperViewVerticallyToBottomWithHeight:(NSNumber *)height {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSString *afl = [NSString stringWithFormat:@"V:[self%@]|", height ? [NSString stringWithFormat:@"(%@)", height] : @""];
    if (self.superview) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:afl options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToTopAndBottomOfSuperView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        NSDictionary *bindings = @{@"self" : self, @"superview" : self.superview};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(==superview)]|" options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToLeftAndRightEdgesOfSuperView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        NSDictionary *bindings = @{@"self" : self, @"superview" : self.superview};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self(==superview)]|" options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToAllSidesOfSuperView {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:bindings]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToAllSidesOfSuperViewWithPadding:(CGFloat)padding {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[self]-(%f)-|",padding,padding] options:0 metrics:nil views:bindings]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[self]-(%f)-|",padding,padding] options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToLeftAndRightEdgesOfSuperViewWithPadding:(CGFloat)padding {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[self]-(%f)-|",padding,padding] options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinViewToTopAndBottomEdgesOfSuperViewWithPadding:(CGFloat)padding {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(self);
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[self]-(%f)-|",padding,padding] options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_centerViewHorizontallyInMargins:(UIEdgeInsets)margins{
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString *vfl = [NSString stringWithFormat:@"H:|-(%f)-[self]-(%f)-|", margins.left, margins.right ];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}
- (NSArray *)ic_centerViewVerticallyInMargins:(UIEdgeInsets)margins{
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSString *vfl = [NSString stringWithFormat:@"V:|-(%f)-[self]-(%f)-|", margins.top, margins.bottom];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

-(NSArray*)ic_centerViewInMargins:(UIEdgeInsets)margins{
    NSMutableArray * addedConstraints = [NSMutableArray array];
    
    [addedConstraints addObjectsFromArray:[self ic_centerViewHorizontallyInMargins:margins]];
    [addedConstraints addObjectsFromArray:[self ic_centerViewVerticallyInMargins:margins]];
    
    return addedConstraints.copy;
}

- (NSArray *)ic_centerVerticallyInSuperView {
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [constraints addObject:c];
        [self.superview addConstraint:c];
    }
    return constraints;
}

- (NSArray *)ic_centerHorizontallyInSuperView {
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        [constraints addObject:c];
        [self.superview addConstraint:c];
    }
    return constraints;
}


- (NSArray *)ic_addVflContrstraints:(NSString *)vfl {
    NSAssert(vfl != nil, @"cannot have nil vfl");
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constraints = [NSMutableArray array];
    if (self.superview) {
        NSDictionary *bindings = @{@"self" : self, @"superview" : self.superview};
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:bindings]];
        [self.superview addConstraints:constraints];
    }
    return constraints;
}

- (NSArray *)ic_pinToBottomRightCornerOfSuperViewWithBottomSpacing:(CGFloat)bottomSpace trailingSpacing:(CGFloat)trailingSpacing{
    
    NSMutableArray * constraints = [NSMutableArray array];
    
    NSArray * addedConstraints = [self ic_addVflContrstraints:[NSString stringWithFormat:@"V:[self]-%f-|", bottomSpace]];
    if(addedConstraints){
        [constraints addObjectsFromArray:constraints];
    }
    
    addedConstraints = [self ic_addVflContrstraints:[NSString stringWithFormat:@"H:[self]-%f-|", trailingSpacing]];
    
    if(addedConstraints){
        [constraints addObjectsFromArray:constraints];
    }
    
    return constraints.copy;
}

- (NSArray *)ic_addDimensionConstraintsWithWidth:(CGFloat)width height:(CGFloat)height{
    NSMutableArray * constraints = [NSMutableArray array];
    
    NSArray * addedConstraints = [self ic_setHeight:height];
    if(addedConstraints){
        [constraints addObjectsFromArray:addedConstraints];
    }
    
    addedConstraints = [self ic_setWidth:width];
    if(addedConstraints){
        [constraints addObjectsFromArray:addedConstraints];
    }
    
    return constraints.copy;
    
}

-(NSArray*)ic_setWidth:(CGFloat)width{
    return [self ic_addVflContrstraints:[NSString stringWithFormat:@"H:[self(%f)]", width]];
}

-(NSArray*)ic_setHeight:(CGFloat)height{
    return [self ic_addVflContrstraints:[NSString stringWithFormat:@"V:[self(%f)]", height]];
}

- (NSLayoutConstraint *)ic_findConstraintMatchingViewWithFirstAttribute:(NSLayoutAttribute)attrib1 secondAttribute:(NSLayoutAttribute)attrib2 {
    for (NSLayoutConstraint *c in self.superview.constraints) {
        if (c.firstItem == self || c.secondItem == self) {
            if (c.firstAttribute == attrib1 && c.secondAttribute == attrib2) return c;
        }
    }
    return nil;
}

-(NSLayoutConstraint *)ic_constraintForWidthAttributeEqualtToView:(UIView *)view multiplier:(CGFloat)multiplier{
    return [self ic_equalRelationConstraintForAttribute:NSLayoutAttributeWidth toView:view multiplier:multiplier];
}

-(NSLayoutConstraint *)ic_constraintForHeightAttributeEqualtToView:(UIView *)view multiplier:(CGFloat)multiplier{
    return [self ic_equalRelationConstraintForAttribute:NSLayoutAttributeHeight toView:view multiplier:multiplier];
}

-(NSLayoutConstraint*)ic_equalRelationConstraintForAttribute:(NSLayoutAttribute)attribute toView:(UIView*)view multiplier:(CGFloat)multiplier{
    return [self ic_equalRelationConstraintForAttribute:attribute toView:view multiplier:multiplier constant:0];
}

-(NSLayoutConstraint*)ic_equalRelationConstraintForAttribute:(NSLayoutAttribute)attribute toView:(UIView*)view multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = nil;
    if (self.superview) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute multiplier:multiplier constant:constant];
        [self.superview addConstraint:constraint];
    }
    
    return constraint;
}

@end
