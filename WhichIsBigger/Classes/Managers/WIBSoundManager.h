//
//  WIBSoundManager.h
//  WhichIsBigger
//
//  Created by PJ Loury on 7/23/18.
//  Copyright © 2018 Angry Tortoise Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIBSoundManager : NSObject

+ (WIBSoundManager *)sharedInstance;
- (void)playAchievementSound;
- (void)playPointsIncreaseSound;
- (void)playLevelUpSound;
- (void)stopSound;

@end
