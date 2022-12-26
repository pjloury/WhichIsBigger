//
//  WIBNetworkManager.m
//  WhichIsBigger
//
//  Created by PJ Loury on 4/7/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBNetworkManager.h"

// Data Model
#import "WIBGameQuestion.h"
#import "WIBQuestionType.h"
#import "WIBDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDWebImagePrefetcher.h"
#import "WIBGamePlayManager.h"

@implementation WIBNetworkManager

+ (WIBNetworkManager *)sharedInstance
{
    static dispatch_once_t pred;
    static WIBNetworkManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[WIBNetworkManager alloc] init];
        shared.reachability = [WIBReachability reachabilityForInternetConnection];
    });
    
    return shared;
}

- (void)showNetworkError {
    NSString *title = @"No network detected";
    NSString *message = @"Which is Bigger needs a network connection in order to load";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
        NSString *cancelButtonTitle = @"Okay";
    [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *viewController = keyWindow.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)getCategoriesWithCompletion:(void (^)())completion
{
    [[WIBGamePlayManager sharedInstance] generateQuestionTypes];
    completion();
     
}

- (void)prefetchImagesForObjects:(NSArray *)array
{
    NSMutableArray *urls = [NSMutableArray array];
    for (WIBQuestionType *type in array) {
        [urls addObject:[NSURL URLWithString:type.imageURL]];
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

- (void)generateDataModelWithCompletion:(void (^)())completion
{
    [[WIBDataModel sharedInstance] generateTestData];
    completion();
}

- (void)preloadImages:(NSMutableArray *)gameQuestions
{
    _groupDownloadComplete = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_group_t downloadGroup = dispatch_group_create();
        
        for (WIBGameQuestion *question in gameQuestions)
        {
            NSString *urlString1 = question.option1.item.photoURL;
            NSString *urlString2 = question.option2.item.photoURL;
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            
            if(urlString1 != nil && ![urlString1 isKindOfClass:[NSNull class]]) {
                dispatch_group_enter(downloadGroup);
                [manager loadImageWithURL:[NSURL URLWithString:urlString1]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                         // progression tracking code
                                     }
                                    completed: ^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            // do something with image
                                            NSLog(@"Photo 1");
                                        }
                                        else {
                                            NSLog(@"Photo 1 done goofed: %@", error.description);
                                        }
                                        dispatch_group_leave(downloadGroup);
                                    }];
            }
                        
            if(urlString2 != nil && ![urlString2 isKindOfClass:[NSNull class]]) {
                dispatch_group_enter(downloadGroup);
                [manager loadImageWithURL:[NSURL URLWithString:urlString2]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            // do something with image
                                            NSLog(@"Photo 2");
                                        }
                                        else {
                                            NSLog(@"Photo 2 done goofed: %@", error.description);
                                        }
                                        dispatch_group_leave(downloadGroup);
                                    }];
            }
        }
        
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Finished downloading images! Let everyone know...");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGroupImageDownloadCompleteNotification object:nil];
            self.groupDownloadComplete = YES;
        });
    });
}

@end
