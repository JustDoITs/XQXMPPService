//
//  AppDelegate.m
//  test
//
//  Created by XiangqiTu on 14-9-10.
//
//

#import "AppDelegate.h"
#import "CustomNavigationViewController.h"
#import "ChatViewController.h"
#import "ChatMessageCoreDataStorage.h"

#import "AutoLayoutViewController.h"
#import "PictureFlowViewController.h"
#import "OneFingerLayoutViewController.h"
#import "HomePageViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self becomeOneFingerLayoutViewController];
    return YES;
}

- (void)becomeChatViewController
{
    ChatViewController *vc = [[ChatViewController alloc] initWithNibName:nil bundle:nil];
    CustomNavigationViewController *nav = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (void)becomeAutoLayoutViewController
{
    AutoLayoutViewController *vc = [[AutoLayoutViewController alloc] initWithNibName:@"AutoLayoutViewController" bundle:[NSBundle mainBundle]];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
}

- (void)becomePictureFlowViewController
{
    PictureFlowViewController *vc = [[PictureFlowViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
}

- (void)becomeHomePageViewController
{
    HomePageViewController *vc = [[HomePageViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}

- (void)becomeOneFingerLayoutViewController
{
    OneFingerLayoutViewController *vc = [[OneFingerLayoutViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[ChatMessageCoreDataStorage sharedInstance] saveContext];
}
@end
