//
//  MainViewController.h
//  Etrans
//
//  Created by juis on 2018. 2. 13..
//  Copyright © 2018년 juis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <UserNotifications/UserNotifications.h>

@interface UIWebView (Javascript)
    - (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame;
    - (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message     initiatedByFrame:(id *)frame;

@end

@interface MainViewController : UIViewController <UIWebViewDelegate, UNUserNotificationCenterDelegate> {
    Boolean isMain;
    Boolean isPushMain;
}


@property (strong, nonatomic) IBOutlet UIWebView *webView01;
@property (weak, nonatomic) IBOutlet UIImageView *iv_intro;

- (void) callPush;

+ (MainViewController *)sharedMainView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_keyboard_height;

@end
