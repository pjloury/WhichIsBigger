//
//  WIBGamePlayManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBGamePlayManager.h"


@interface WIBGamePlayManager()

@property (nonatomic, strong) NSMutableArray *gameOptions;

@end

@implementation WIBGamePlayManager

+ (WIBGamePlayManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBGamePlayManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBGamePlayManager alloc] init];
        
    });
    
    return shared;
}

- (WIBGameOption *)gameOption
{
    return nil;
}

@end
