//
//  AppDelegate.m
//  Etrans
//
//  Created by juis on 2018. 2. 13..
//  Copyright © 2018년 juis. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DataSet.h"

@import Firebase;
@import FirebaseMessaging;
@import UserNotifications;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@end
#endif
// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
        
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
            // asm
            // [START configure_firebase]
            [FIRApp configure];
            // [END configure_firebase]

            // [START set_messaging_delegate]
            [FIRMessaging messaging].delegate = self;
            // [END set_messaging_delegate]
            
            //[FIRMessaging messaging].remoteMessageDelegate = self;
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    // [START configure_firebase]
//    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];

    //if(self.needsUpdate) {
    //    NSLog(@"NSLog Update");
    //}
    
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [MainViewController sharedMainView];
    
    [_window makeKeyAndVisible];
    return YES;
}


// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo != nil) {
        NSLog(@"%@", userInfo);
        NSDictionary *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *str = [userInfo objectForKey:@"msg"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                              options:kNilOptions
                              error:&error];
        
        NSString *seq = (NSString *)[json valueForKey:@"seq"];
        NSString *type = (NSString *)[json valueForKey:@"type"];
        NSString *doc_gubun = (NSString *)[json valueForKey:@"doc_gubun"];
        NSString *param = (NSString *)[json valueForKey:@"param"];
        
        NSLog(@"seq:%@, type:%@, doc_gubun:%@, param:%@", seq, type, doc_gubun, param);
        
        NSString *add = [userInfo objectForKey:@"add"];
        NSLog(@"add:%@", add);
        //        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([DataSet sharedDataSet].isBackground) {
            [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
        } else {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:[msg objectForKey:@"body"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [_window.self.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    // Print message ID.
    if (userInfo != nil) {
        NSLog(@"%@", userInfo);
        NSDictionary *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *str = [userInfo objectForKey:@"msg"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                              options:kNilOptions
                              error:&error];
        
        NSString *seq = (NSString *)[json valueForKey:@"seq"];
        NSString *type = (NSString *)[json valueForKey:@"type"];
        NSString *doc_gubun = (NSString *)[json valueForKey:@"doc_gubun"];
        NSString *param = (NSString *)[json valueForKey:@"param"];
        
        NSLog(@"seq:%@, type:%@, doc_gubun:%@, param:%@", seq, type, doc_gubun, param);
        
        NSString *add = [userInfo objectForKey:@"add"];
        NSLog(@"add:%@", add);
        
//        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([DataSet sharedDataSet].isBackground) {
            [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
        } else {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:[msg objectForKey:@"body"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [_window.self.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]



// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Print message ID.
    if (userInfo != nil) {
        NSLog(@"%@", userInfo);
        NSDictionary *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *str = [userInfo objectForKey:@"msg"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                              options:kNilOptions
                              error:&error];
        
        NSString *seq = (NSString *)[json valueForKey:@"seq"];
        NSString *type = (NSString *)[json valueForKey:@"type"];
        NSString *doc_gubun = (NSString *)[json valueForKey:@"doc_gubun"];
        NSString *param = (NSString *)[json valueForKey:@"param"];
        
        NSLog(@"seq:%@, type:%@, doc_gubun:%@, param:%@", seq, type, doc_gubun, param);
        
        NSString *add = [userInfo objectForKey:@"add"];
        NSLog(@"add:%@", add);
        
//        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([DataSet sharedDataSet].isBackground) {
            [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
        } else {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:[msg objectForKey:@"body"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [_window.self.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    }

    // Print full message.
    NSLog(@"%@", userInfo);
}

- (BOOL)needsUpdate {
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    
    NSLog(@"appID : %@", appID);
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/app/id1355604690?mt=8"]];
            return YES;
        }
    }
    return NO;
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    // Print message ID.
    if (userInfo != nil) {
        NSLog(@"%@", userInfo);
        NSDictionary *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        NSString *str = [userInfo objectForKey:@"msg"];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                              options:kNilOptions
                              error:&error];
        
        NSString *seq = (NSString *)[json valueForKey:@"seq"];
        NSString *type = (NSString *)[json valueForKey:@"type"];
        NSString *doc_gubun = (NSString *)[json valueForKey:@"doc_gubun"];
        NSString *param = (NSString *)[json valueForKey:@"param"];
        
        NSLog(@"seq:%@, type:%@, doc_gubun:%@, param:%@", seq, type, doc_gubun, param);
        
        NSString *add = [userInfo objectForKey:@"add"];
        NSLog(@"add:%@", add);
        
//        NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([DataSet sharedDataSet].isBackground) {
            [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
        } else {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:[msg objectForKey:@"body"]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [[MainViewController sharedMainView] performSelectorOnMainThread:@selector(callPush) withObject:nil waitUntilDone:YES];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [_window.self.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

    
    // Print full message.
    NSLog(@"%@", userInfo);
}

#endif
// [END ios_10_message_handling]


// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    //NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    
    [DataSet sharedDataSet].deviceTokenID = fcmToken;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"jpp.plist"];
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"jpp" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *jppData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [jppData setObject:fcmToken forKey:@"token"];
    
    [jppData writeToFile:path atomically:YES];

    
}
// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]



// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"remoteMessage : %@", [remoteMessage appData]);
}
#endif
// [END ios_10_data_message_handling]


- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    __block NSString *refreshedToken = @"";
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                    NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching remote instance ID: %@", error);
        } else {
            refreshedToken = result.token;
            NSLog(@"Remote instance ID token: %@", result.token);
        }
    }];
    
//    NSString *refreshedToken = [[FIRInstanceID instanceID]       //[[FIRInstanceID instanceID] token];
//    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
//    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

//- (void)connectToFcm {
//    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Unable to connect to FCM. %@", error);
//        } else {
//            NSLog(@"Connected to FCM.");
//        }
//    }];
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs token here.
    // [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [DataSet sharedDataSet].isBackground = YES;
    //[[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [DataSet sharedDataSet].isBackground = NO;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // [self connectToFcm];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Etrans"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
