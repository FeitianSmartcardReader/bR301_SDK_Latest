/*
 * Support for bR301(Bluetooth) smart card reader
 *
 * Copyright (C) 2014, Ben <ben@ftsafe.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#import "call_libAppDelegate.h"
#include "ft301u.h"

@implementation call_libAppDelegate

@synthesize window;
@synthesize mainViewController;

- (void)dealloc {
    [window release];
    [mainViewController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if(self.mainViewController == nil){
        disopWindow *aController = [[disopWindow alloc] initWithNibName:@"disopWindow" bundle:nil];
        self.mainViewController = aController;
        [aController release];}
    
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;

    
//  Remove below line, because it will crash when using latest xcode
//  [window addSubview:[mainViewController view]];
    [window setRootViewController:mainViewController];
    
    
    [window makeKeyAndVisible];
   // [UIApplication sharedApplication].idleTimerDisabled = YES;

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
}

extern  SCARDCONTEXT gContxtHandle;
- (void)applicationDidEnterBackground:(UIApplication *)application {
  
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
//进入后台，释放上下文
    FtDidEnterBackground(1);
    SCardReleaseContext(gContxtHandle);
   
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */

   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//进入前台，创建上下文
      SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

@end
