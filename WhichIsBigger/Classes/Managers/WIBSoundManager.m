//
//  WIBSoundManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 7/23/18.
//  Copyright © 2018 Angry Tortoise Productions. All rights reserved.
//

#import "WIBSoundManager.h"

@interface WIBSoundManager ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation WIBSoundManager

+ (WIBSoundManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBSoundManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBSoundManager alloc] init];
    });
    return shared;
}

- (void)playAchievementSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WIBAchievement"  ofType:@"mp3"];
    [self playSound:path shouldLoop:NO shouldBuzz:YES];
}

- (void)playPointsIncreaseSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CaChing"  ofType:@"m4a"];
    [self playSound:path shouldLoop:YES shouldBuzz:NO];
}

- (void)playLevelUpSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CoinUnlock"  ofType:@"wav"];
    [self playSound:path shouldLoop:NO shouldBuzz:YES];
}

- (void)playSound: (NSString *) path shouldLoop: (BOOL) shouldLoop shouldBuzz: (BOOL) shouldBuzz {
    NSURL *soundFileURL = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    if (shouldLoop)
        self.audioPlayer.numberOfLoops = -1; //Infinite
    if (shouldBuzz)
        AudioServicesPlayAlertSoundWithCompletion(1352, nil);
    [self.audioPlayer play];
}

- (void)stopSound
{
    [self.audioPlayer stop];
}

@end
