//
//  NSNumber+Separated.h
//  WhichIsBigger
//
//  Created by PJ Loury on 5/19/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Separated)

@property (nonatomic, readonly) NSString *separatedValue;
- (NSString *)separatedValue;

@end
