//
//  WIBTutorialPageViewController.m
//  WhichIsBigger
//
//  Created by PJ Loury on 9/21/15.
//  Copyright (c) 2015 Angry Tortoise Productions. All rights reserved.
//

#import "WIBTutorialPageViewController.h"
#import "WIBTutorialViewController.h"

typedef enum : NSUInteger {
    WIBTutorialTipTapTheBigger,
    WIBTutorialTipTimerBar,
    WIBTutorialTipStreaksAndHighScores,
    WIBTutorialTipChallengeFriends,
    WIBTutorialTipCount
} WIBTutorialTip;

@interface WIBTutorialPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>



@end

@implementation WIBTutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;

    WIBTutorialViewController *vc = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[vc];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WIBTutorialViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WIBTutorialViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == WIBTutorialTipCount) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (WIBTutorialViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((WIBTutorialTipCount== 0) || (index >= WIBTutorialTipCount)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    WIBTutorialViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WIBTutorialViewController"];
    viewController.pageIndex = index;
    
    switch (viewController.pageIndex)
    {
        case (WIBTutorialTipTapTheBigger):
            viewController.centerLabel.text = @"hello";
            break;
        case (WIBTutorialTipTimerBar):
            viewController.centerLabel.text = @"world";
            break;
        case (WIBTutorialTipStreaksAndHighScores):
            viewController.centerLabel.text = @"dolly";
            break;
        case (WIBTutorialTipChallengeFriends):
            viewController.centerLabel.text = @"parton";
            break;
    }

    return viewController;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return WIBTutorialTipCount;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
