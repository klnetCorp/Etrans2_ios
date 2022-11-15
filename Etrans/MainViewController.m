//
//  MainViewController.m
//  Etrans
//
//  Created by juis on 2018. 2. 13..
//  Copyright © 2018년 juis. All rights reserved.
//

#import "MainViewController.h"
#import "DataSet.h"
#import <UserNotifications/UserNotifications.h>
#import "OpenUDID.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonCrypto.h>
UIViewController *mainViewController;

@implementation UIWebView (Javascript)
    static BOOL clicked = FALSE;

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame{
    
    clicked = FALSE;
    UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"확인"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   clicked = TRUE;
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"취소"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                    clicked = TRUE;
                               }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
           
    [mainViewController presentViewController:alert animated:NO completion:nil];
    
    while (clicked == FALSE) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    
    return YES;
}

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame {

    clicked = FALSE;
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"알림"
                        message:message
                        preferredStyle:UIAlertControllerStyleAlert];
        
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"확인"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                    clicked = TRUE;
                                }];
        
    [alert addAction:okAction];
       
    [mainViewController presentViewController:alert animated:NO completion:nil];
    // while 을 제거하면 alert 이후에 진행되는 웹쪽 코드가 순서가 뒤죽박죽된다.
    // 클릭할때까지 while loop 를 돌면서 기다린 후 클릭이 되면 다음 코드로 진행한다.
    while (clicked == FALSE) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
}
@end



//
//static BOOL diagStat = NO;
//static BOOL diagStat2 = NO;
//
//- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
//    [alert show];
//}
//
//- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame {
//    diagStat2 = NO;
//    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"취소", @"취소") otherButtonTitles:NSLocalizedString(@"확인", @"확인"), nil];
//    [confirmDiag show];
//
//    //버튼 누르기전까지 지연.
//    CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 7.) {
//        while (diagStat2 == NO) {
//            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
//        }
//    } else {
//        while (diagStat2 == NO && confirmDiag.superview != nil) {
//            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
//        }
//    }
//    return diagStat;
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        diagStat = NO;
//        diagStat2 = YES;
//    } else if (buttonIndex == 1) {
//        diagStat = YES;
//        diagStat2 = YES;
//    }
//}






@interface MainViewController ()

@end


@implementation NSURLRequest(DataController)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end


@implementation MainViewController
@synthesize webView01, iv_intro, constraint_keyboard_height;
- (void)viewDidLoad {
    [super viewDidLoad];
    webView01.delegate = self;
    mainViewController = self;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAnimate:) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAnimate:) name:UIKeyboardWillHideNotification object:nil];
    
//    if (@available(iOS 11.0, *)) {
//        iv_intro.translatesAutoresizingMaskIntoConstraints = NO;
//        UILayoutGuide * guide1 = self.view.safeAreaLayoutGuide;
//        [self.iv_intro.leadingAnchor constraintEqualToAnchor:guide1.leadingAnchor].active = YES;
//        [self.iv_intro.trailingAnchor constraintEqualToAnchor:guide1.trailingAnchor].active = YES;
//        [self.iv_intro.topAnchor constraintEqualToAnchor:guide1.topAnchor].active = YES;
//        [self.iv_intro.bottomAnchor constraintEqualToAnchor:guide1.bottomAnchor].active = YES;
//        [self.iv_intro layoutIfNeeded];
//
//        webView01.translatesAutoresizingMaskIntoConstraints = NO;
//        UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
//        [self.webView01.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
//        [self.webView01.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
//        [self.webView01.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
//        [self.webView01.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
//        [self.webView01 layoutIfNeeded];
//    } else {
//        // Fallback on earlier versions
//    }
    
    NSString *sSignHash = [self md5:MAIN_URL];
    NSString *getHash = [self sendDataToServer];
   
    BOOL rootingCheck = [self checkRooting];
    [DataSet sharedDataSet].isMode = IS_MODE;
    [DataSet sharedDataSet].connectUrl = MAIN_URL;
    
    if ([[DataSet sharedDataSet].isMode isEqualToString:@"D"]) {
        //개발 테스트용은 앱스토어 배포가 아니므로 무조건 통과시킨다.
        getHash = sSignHash;
    }
    
    if(!rootingCheck) {
        NSString *msg = [NSString stringWithFormat:@"루팅된 단말기 입니다. \n개인정보 유출의 위험성이 있으므로 \n프로그램을 종료합니다."];
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            exit(0);
                                   }];
        [alert addAction:okAction];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        });
    }
    

    if(![sSignHash isEqualToString:getHash]) {
    
        NSString *msg = [NSString stringWithFormat:@"프로그램 무결성에 위배됩니다. \nAppStore 내에서 \n 설치하시기 바랍니다."];
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"알림"
                                      message:msg
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
            exit(0);
                                   }];
        [alert addAction:okAction];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
        });
    }
    

    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [bundleInfo valueForKey:@"CFBundleIdentifier"];
    NSURL *lookupURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", bundleIdentifier]];
    NSData *lookupResults = [NSData dataWithContentsOfURL:lookupURL];
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:lookupResults options:0 error:nil];
    
    NSUInteger resultCount = [[jsonResults objectForKey:@"resultCount"] integerValue];
 
    
    NSLog(@"resultCount : %lu", (unsigned long)resultCount);
    if (resultCount){
        NSDictionary *appDetails = [[jsonResults objectForKey:@"results"] firstObject];
        NSString *latestVersion = [appDetails objectForKey:@"version"];
        NSString *currentVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"latestVersion====%@",latestVersion);
        NSLog(@"currentVersion====%@",currentVersion);

        //앱스토어에 올라간 버전과 빌드버전이 다를경우 팝업을 출력한다.
        if(![latestVersion isEqualToString:currentVersion]){
            NSString *versionmsg = [NSString stringWithFormat:@"새로운버전(%@)이 나왔습니다. 업데이트 하시겠습니까?",latestVersion];
            
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"알림"
                                          message:versionmsg
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/app/id1355604690?mt=8"]];
                                       }];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"취소"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                       }];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newmobile/login.do",MAIN_URL]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0f];
    [webView01 loadRequest:request];
    
    NSLog(@"udid:%@", [OpenUDID value]);
    
    
    
}

- (void)keyboardWillAnimate:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    if([notification name] == UIKeyboardWillShowNotification) {
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setKeyboard(%f, 'Y');", keyboardBounds.size.height]];
        NSLog(@"%f", keyboardBounds.size.height);
        constraint_keyboard_height.constant = keyboardBounds.size.height;
    } else if([notification name] == UIKeyboardWillHideNotification) {
        //[self.webView01 setFrame:CGRectMake(self.webView01.frame.origin.x, self.webView01.frame.origin.y + keyboardBounds.size.height, self.webView01.frame.size.width, self.webView01.frame.size.height)];
     [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setKeyboard(%f, 'N');", 0.0f]];
    }
    [UIView commitAnimations];
}

- (void)_removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (MainViewController *)sharedMainView
{
    static MainViewController *singletonClass = nil;
    if(singletonClass == nil)
    {
        @synchronized(self)
        {
            if(singletonClass == nil)
            {
                singletonClass = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            }
        }
    }
    return singletonClass;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"requestString : %@", requestString);
    

    NSString *isMode = IS_MODE;
    NSString *connectUrl = MAIN_URL;
    
    if ([requestString hasSuffix:@".pdf"] || [requestString hasSuffix:@".txt"] || [requestString hasSuffix:@".PDF"] || [requestString hasSuffix:@".TXT"] || [requestString hasSuffix:@".TEXT"] || [requestString hasSuffix:@".text"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestString]];
        return NO;
    }
    
    //이전 버튼
    if ([requestString hasPrefix:@"hybridappurlback://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappurlback://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        NSLog(@"urlback : %@", jsString);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, jsString]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0f];
        [webView01 loadRequest:request];
        
        return NO;
    }
    
    
    //자동로그인 처리
    if ([requestString hasPrefix:@"hybridappautologinresult://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappautologinresult://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        NSString *jsString1 = [jsDataArray objectAtIndex:0];
        NSString *jsString2 = [jsDataArray objectAtIndex:1];
        
        if ([jsString1 isEqualToString:@"success"]) {
            [DataSet sharedDataSet].userid = jsString2;
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newmobile/main.do",connectUrl]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
            [webView01 loadRequest:request];
        } else { //실패했을 경우
            [iv_intro setHidden:YES];
            [webView01 setHidden:NO];
        }
        return NO;
    }
    
    //로그인 결과저장
    if ([requestString hasPrefix:@"hybridappautoregister://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappautoregister://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        
        NSString *jsString1 = [jsDataArray objectAtIndex:0];
        NSString *jsString2 = [jsDataArray objectAtIndex:1];
        NSString *jsString3 = [jsDataArray objectAtIndex:2];
        
        NSLog(@"hybridappautoregister id : %@", jsString1);
        NSLog(@"deviceKey : %@", jsString2);
        NSLog(@"isAutoLogin : %@", jsString3);
        
        [DataSet sharedDataSet].userid = jsString1;
        [DataSet sharedDataSet].isLogin = [jsString3 isEqualToString:@"Y"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"autologin" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        [authData setObject:jsString1 forKey:@"vid"];
        [authData setObject:jsString2 forKey:@"deviceKey"];
        
        if([jsString3 isEqualToString:@"Y"]) {
            [authData setObject:[NSNumber numberWithBool:YES] forKey:@"isautologin"];
        } else {
            [authData setObject:[NSNumber numberWithBool:NO] forKey:@"isautologin"];
        }
        
        [authData writeToFile:path atomically:YES];
        
        //NSLog(@"/newmobile/main.do : %@", connectUrl);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newmobile/main.do",connectUrl]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:1.0f];
        
        [webView01 loadRequest:request];
        return NO;
    }
    
    //자동로그인 여부 웹뷰 환경설정에 세팅하기
    if ([requestString hasPrefix:@"hybridappinitconfig://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSNumber * nisAutoLogin = [authData objectForKey:@"isautologin"];
        Boolean isAutoLogin = [nisAutoLogin boolValue];
        
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setAppVersion('%@');", currentVersion]];
        if(isAutoLogin) {
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:setConfigIsAutoLogin('Y');"];
        }
        
        NSString *myDeviceListUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=get_my_devices&appid=%@&userid=%@",PUSH_URL, APPID, [DataSet sharedDataSet].userid];
        NSData* bRetS = [self httpRequest:myDeviceListUrl];
        if(bRetS != nil) {
            NSError* error;
            NSLog(@"myDeviceListUrl :%@", myDeviceListUrl);
            NSDictionary* jsonDeviceList = [NSJSONSerialization JSONObjectWithData:bRetS
                                                                           options:kNilOptions
                                                                             error:&error];
            NSLog(@"jsonDeviceList :%@", jsonDeviceList);
            
            
            NSString* nsJsonDeviceList=  [[NSString alloc] initWithData:bRetS
                                                               encoding:NSUTF8StringEncoding];

            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setDeviceResult(%@, '%@');", nsJsonDeviceList, [OpenUDID value]]];
            
            
            NSString *myServiceListUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=get_setting_info&appid=%@&userid=%@",PUSH_URL, APPID, [DataSet sharedDataSet].userid];
            bRetS = [self httpRequest:myServiceListUrl];
            NSDictionary* jsonServiceList = [NSJSONSerialization JSONObjectWithData:bRetS
                                                                            options:kNilOptions
                                                                              error:&error];
            
            NSLog(@"jsonServiceList :%@", jsonServiceList);
            NSString* nsJsonerviceList=  [[NSString alloc] initWithData:bRetS
                                                               encoding:NSUTF8StringEncoding];
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:getServiceResult(%@);", nsJsonerviceList]];
            
        } else {
            UIAlertController * alert =  [UIAlertController
                                          alertControllerWithTitle:@"오류"
                                          message:@"알림 설정을 가져오는데 오류가 발생하였습니다.\n관리자에게 문의바랍니다."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"확인"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           
                                       }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return NO;
    }
    
    //자동로그인 여부 설정에 저장
    if ([requestString hasPrefix:@"hybridappconfigsetautologin://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappconfigsetautologin://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"autologin" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

        if([jsString isEqualToString:@"Y"]) {
            [authData setObject:[NSNumber numberWithBool:YES] forKey:@"isautologin"];
        } else {
            [authData setObject:[NSNumber numberWithBool:NO] forKey:@"isautologin"];
        }
        
        [authData writeToFile:path atomically:YES];
        return NO;
    }
    
    
    //이전버튼
    if ([requestString hasPrefix:@"hybridappaurlback://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappaurlback://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, jsString]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
        [webView01 loadRequest:request];
        
        return NO;
    }
    
    
    //타인 디바이스 삭제
    if ([requestString hasPrefix:@"hybridapppushdevicedelete://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridapppushdevicedelete://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        NSError *error;
        NSString *myPushUnregistUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=delete_app&appid=%@&did=%@",PUSH_URL, APPID, jsString];
        NSData* bRetS = [self httpRequest:myPushUnregistUrl];
        NSLog(@"myPushRegistUrl :%@", myPushUnregistUrl);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:bRetS
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"json :%@", json);
        
        NSString* nsJson=  [[NSString alloc] initWithData:bRetS
                                                 encoding:NSUTF8StringEncoding];
        
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:resultDeleteDevice(%@);", nsJson]];
        
        return NO;
    }

    
    //푸시onoff
    if ([requestString hasPrefix:@"hybridapppushonoff://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridapppushonoff://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        if([jsString isEqualToString:@"ON"]) {
            struct utsname systemInfo;
            uname(&systemInfo);
            
            NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
            
            NSLog(@"model : %@", model);
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
            NSString *token = (NSString *)[jppData objectForKey:@"token"];
            NSString *myPushRegistUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=regist_app&appid=%@&did=%@&userid=%@&os=fcm_ios&token=%@&model_name=%@",PUSH_URL, APPID, [OpenUDID value], [DataSet sharedDataSet].userid,token, model];
            NSData* bRetS = [self httpRequest:myPushRegistUrl];
            NSLog(@"myPushRegistUrl :%@", myPushRegistUrl);
            
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:bRetS
                                                                 options:kNilOptions
                                                                   error:&error];
            NSLog(@"json :%@", json);
            NSString* nsJson=  [[NSString alloc] initWithData:bRetS encoding:NSUTF8StringEncoding];
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setPushOnOff(%@, 'ON');", nsJson]];
            return NO;

        } else {
            NSError *error;
            NSString *myPushUnregistUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=delete_app&appid=%@&did=%@",PUSH_URL, APPID, [OpenUDID value]];
            NSData* bRetS = [self httpRequest:myPushUnregistUrl];
            NSLog(@"myPushRegistUrl :%@", myPushUnregistUrl);
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:bRetS
                                                                options:kNilOptions
                                                                  error:&error];
            NSLog(@"json :%@", json);
            
            NSString* nsJson=  [[NSString alloc] initWithData:bRetS
                                                     encoding:NSUTF8StringEncoding];
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setPushOnOff(%@, 'OFF');", nsJson]];
        }
        
        return NO;
    }
    
    
    if ([requestString hasPrefix:@"hybridappsetservicelist://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappsetservicelist://"];
        NSError *error;
        
        NSString *result = [[jsDataArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:&error];
        
        for (int i=0; i < arr.count; i++) {
            NSString *urlStr = [[arr objectAtIndex:i] objectForKey:@"urlStr"];
            NSArray *jsDataArray = [urlStr componentsSeparatedByString:@"&"];

            NSString *pushServiceCode = @"";
            NSString *startTime = @"";
            NSString *endTime = @"";
            NSString *useYn = @"";
            NSString *klnetId = @"";
            NSString *notiRecvDay = @"";
            for (NSString *pair in jsDataArray) {
                NSArray *elements = [pair componentsSeparatedByString:@"="];
                NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"key : %@, val : %@", key, val);
                if([key isEqualToString:@"pushServiceCode"]) pushServiceCode = val;
                if([key isEqualToString:@"startTime"]) startTime = val;
                if([key isEqualToString:@"endTime"]) endTime = val;
                if([key isEqualToString:@"useYn"]) useYn = val;
                if([key isEqualToString:@"klnetId"]) klnetId = val;
                if([key isEqualToString:@"notiRecvDay"]) notiRecvDay = val;
            }
            NSString *mysettingServiceUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=register_setting_service&appid=%@&pushServiceCode=%@&regUser=%@&notiFromHHmm=%@&notiToHHmm=%@&useYn=%@&klnetId=%@&notiRecvDay=%@",PUSH_URL, APPID, pushServiceCode, [DataSet sharedDataSet].userid, startTime, endTime, useYn, klnetId, notiRecvDay];
            NSData* bRetS = [self httpRequest:mysettingServiceUrl];
            NSLog(@"mysettingServiceUrl :%@", mysettingServiceUrl);
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:bRetS
                                                                 options:kNilOptions
                                                                   error:&error];
            NSLog(@"json :%@", json);

            
        }
        
        return NO;
    }
    
    //푸시 시간설정
    if ([requestString hasPrefix:@"hybridappsettime://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappsettime://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        
        NSString *jsString1 = [jsDataArray objectAtIndex:0];
        NSString *jsString2 = [jsDataArray objectAtIndex:1];
        NSString *jsString3 = [jsDataArray objectAtIndex:2];
        
        NSLog(@"startTime : %@", jsString1);
        NSLog(@"endTime : %@", jsString2);
        NSLog(@"notiRecvDay : %@", jsString3);
        
        if([jsString1 isEqualToString:@""]) {
           jsString1=@"0000";
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:setStartTime();"];
        }
        
        if([jsString2 isEqualToString:@""]) {
            jsString1=@"2359";
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:setEndTime();"];
        }
        
        NSError *error;
        NSString *myPushSettingTimeUrl=[NSString stringWithFormat:@"%@/ccsFcm.do?cmd=update_setting_time&appid=%@&regUser=%@&notiFromHHmm=%@&notiToHHmm=%@&notiRecvDay=%@",PUSH_URL, APPID, [DataSet sharedDataSet].userid,jsString1, jsString2, jsString3];
        NSData* bRetS = [self httpRequest:myPushSettingTimeUrl];
        NSLog(@"myPushSettingTimeUrl :%@", myPushSettingTimeUrl);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:bRetS
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"json :%@", json);
        
        NSString* nsJson=  [[NSString alloc] initWithData:bRetS
                                                 encoding:NSUTF8StringEncoding];
        return NO;
    }
    
    
    
    //알림 목록
    if ([requestString hasPrefix:@"hybridappnotilist://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappnotilist://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        
        NSString *jsString1 = [jsDataArray objectAtIndex:0];
        NSString *jsString2 = [jsDataArray objectAtIndex:1];
        
        NSLog(@"type : %@", jsString1);
        NSLog(@"updateYn : %@", jsString2);
        
        if([jsString2 isEqualToString:@"Y"]) {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setPushReceiveAll('%@', '%@', '%@');", [DataSet sharedDataSet].userid, APPID, [OpenUDID value]]];
        }
    
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:getPushRecentListOfDevice('%@', '%@', '%@', '%@');", [DataSet sharedDataSet].userid, APPID, [OpenUDID value], jsString1]];
        
        return NO;
    }
    
    
    if ([requestString hasPrefix:@"hybridsetchangemode://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridsetchangemode://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        if ([[DataSet sharedDataSet].isMode isEqualToString:@"D"]) {
            connectUrl = MAIN_REAL_URL;
            [DataSet sharedDataSet].isMode = @"P";
        } else {
            connectUrl = MAIN_TEST_URL;
            [DataSet sharedDataSet].isMode = @"D";
        }
        [DataSet sharedDataSet].connectUrl = connectUrl;
        [DataSet sharedDataSet].isLogin = false;
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, jsString]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
        [webView01 loadRequest:request];
        
        return NO;
    }
    
    //로그아웃
    if ([requestString hasPrefix:@"hybridapplogout://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridapplogout://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"autologin" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        
        //NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        //[authData setObject:[NSNumber numberWithBool:NO] forKey:@"isautologin"];
        //[authData writeToFile:path atomically:YES];
        
        [DataSet sharedDataSet].isLogin = false;
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, jsString]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
        [webView01 loadRequest:request];
        
        return NO;
    }

    //앱스토어로이동
    if ([requestString hasPrefix:@"hybridappgoappupdate://"]) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"https://itunes.apple.com/app/id1355604690?mt=8"]];
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"itms-apps://itunes.com/apps/Etrans"]];
      
        return NO;
    }
    
    //선사세팅 불러오기
    if ([requestString hasPrefix:@"hybridappsetbookmarkcarriercode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"carriercode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"carriercode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goCarrierView(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goCarrierView(%@)", @""]];
        }
        
        return NO;
    }
    
    //선사세팅
    if ([requestString hasPrefix:@"hybridappcarriercodesetting://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappcarriercodesetting://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        NSString *type = [jsDataArray objectAtIndex:0];
        NSString *code = [jsDataArray objectAtIndex:1];
        NSString *name = [jsDataArray objectAtIndex:2];
        name = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"type : %@", type);
        NSLog(@"code : %@", code);
        NSLog(@"name : %@", name);
        
        if(name == nil) name = @"";

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"carriercode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableDictionary* json = [authData objectForKey:@"carriercode"];
        NSError* error;
        NSMutableArray* jsonarr= nil;
  
        if ([type isEqualToString:@"insert"]) {
            if (json == nil) {
                json = [[NSMutableDictionary alloc] init];
                jsonarr = [[NSMutableArray alloc] init];
            } else {
                jsonarr = [json objectForKey:@"list"];
            }
 
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    code,@"code",
                                    name,@"name", nil];
            
            [jsonarr addObject:tmpDic];
            [json setObject:jsonarr forKey:@"list"];
            
            NSLog(@"json : %@", json);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath: path])
            {
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"carriercode" ofType:@"plist"];
                
                [fileManager copyItemAtPath:bundle toPath: path error:&error];
            }
            
            NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            [authData setObject:json forKey:@"carriercode"];
            [authData writeToFile:path atomically:YES];

        } else if ([type isEqualToString:@"delete"]) {
            if (json != nil) {
                
                jsonarr = [json objectForKey:@"list"];
                
                for(int i=0; i<[jsonarr count]; i++) {
                    if([[[jsonarr objectAtIndex:i] objectForKey:@"code"] isEqualToString:code]) {
                        [jsonarr removeObjectAtIndex: i];
                        [json setObject:jsonarr forKey:@"list"];
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        if (![fileManager fileExistsAtPath: path])
                        {
                            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"carriercode" ofType:@"plist"];
                            
                            [fileManager copyItemAtPath:bundle toPath: path error:&error];
                        }
                        
                        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
                        
                        [authData setObject:json forKey:@"carriercode"];
                        [authData writeToFile:path atomically:YES];
                        break;
                    }
                }
            }
        }
        
        return NO;
    }
    
    
    //터미널세팅 불러오기
    if ([requestString hasPrefix:@"hybridappsetbookmarkterminalcode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"terminalcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"terminalcode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goTerminalView(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goTerminalView(%@)", @""]];
        }
        
        return NO;
    }
    
    //터미널세팅
    if ([requestString hasPrefix:@"hybridappterminalcodesetting://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridappterminalcodesetting://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        NSString *type = [jsDataArray objectAtIndex:0];
        NSString *code = [jsDataArray objectAtIndex:1];
        NSString *name = [jsDataArray objectAtIndex:2];
        name = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"type : %@", type);
        NSLog(@"code : %@", code);
        NSLog(@"name : %@", name);
        
        if(name == nil) name = @"";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"terminalcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableDictionary* json = [authData objectForKey:@"terminalcode"];
        NSError* error;
        NSMutableArray* jsonarr= nil;
        
        if ([type isEqualToString:@"insert"]) {
            if (json == nil) {
                json = [[NSMutableDictionary alloc] init];
                jsonarr = [[NSMutableArray alloc] init];
            } else {
                jsonarr = [json objectForKey:@"list"];
            }
            
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    code,@"code",
                                    name,@"name", nil];
            
            [jsonarr addObject:tmpDic];
            [json setObject:jsonarr forKey:@"list"];
            
            NSLog(@"json : %@", json);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath: path])
            {
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"terminalcode" ofType:@"plist"];
                
                [fileManager copyItemAtPath:bundle toPath: path error:&error];
            }
            
            NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            [authData setObject:json forKey:@"terminalcode"];
            [authData writeToFile:path atomically:YES];
            
        } else if ([type isEqualToString:@"delete"]) {
            if (json != nil) {
                
                jsonarr = [json objectForKey:@"list"];
                
                for(int i=0; i<[jsonarr count]; i++) {
                    if([[[jsonarr objectAtIndex:i] objectForKey:@"code"] isEqualToString:code]) {
                        [jsonarr removeObjectAtIndex: i];
                        [json setObject:jsonarr forKey:@"list"];
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        if (![fileManager fileExistsAtPath: path])
                        {
                            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"terminalcode" ofType:@"plist"];
                            
                            [fileManager copyItemAtPath:bundle toPath: path error:&error];
                        }
                        
                        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
                        
                        [authData setObject:json forKey:@"terminalcode"];
                        [authData writeToFile:path atomically:YES];
                        break;
                    }
                }
            }
        }
        
        return NO;
    }
    
    //pod 불러오기
    if ([requestString hasPrefix:@"hybridappsetbookmarkpodcode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"podcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"podcode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goPodView(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:goPodView(%@)", @""]];
        }
        
        return NO;
    }
    
    //pod 세팅
    if ([requestString hasPrefix:@"hybridapppodcodesetting://"]) {
        NSArray *jsDataArray2 = [requestString componentsSeparatedByString:@"hybridapppodcodesetting://"];
        NSArray *jsDataArray = [[jsDataArray2 objectAtIndex:1] componentsSeparatedByString:@"&&"];
        NSString *type = [jsDataArray objectAtIndex:0];
        NSString *code = [jsDataArray objectAtIndex:1];
        NSString *name = [jsDataArray objectAtIndex:2];
        name = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"type : %@", type);
        NSLog(@"code : %@", code);
        NSLog(@"name : %@", name);
        
        if(name == nil) name = @"";
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"podcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSMutableDictionary* json = [authData objectForKey:@"podcode"];
        NSError* error;
        NSMutableArray* jsonarr= nil;
        
        if ([type isEqualToString:@"insert"]) {
            if (json == nil) {
                json = [[NSMutableDictionary alloc] init];
                jsonarr = [[NSMutableArray alloc] init];
            } else {
                jsonarr = [json objectForKey:@"list"];
            }
            
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    code,@"code",
                                    name,@"name", nil];
            
            [jsonarr addObject:tmpDic];
            [json setObject:jsonarr forKey:@"list"];
            
            NSLog(@"json : %@", json);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath: path])
            {
                NSString *bundle = [[NSBundle mainBundle] pathForResource:@"podcode" ofType:@"plist"];
                
                [fileManager copyItemAtPath:bundle toPath: path error:&error];
            }
            
            NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            
            [authData setObject:json forKey:@"podcode"];
            [authData writeToFile:path atomically:YES];
            
        } else if ([type isEqualToString:@"delete"]) {
            if (json != nil) {
                
                jsonarr = [json objectForKey:@"list"];
                
                for(int i=0; i<[jsonarr count]; i++) {
                    if([[[jsonarr objectAtIndex:i] objectForKey:@"code"] isEqualToString:code]) {
                        [jsonarr removeObjectAtIndex: i];
                        [json setObject:jsonarr forKey:@"list"];
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        if (![fileManager fileExistsAtPath: path])
                        {
                            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"podcode" ofType:@"plist"];
                            
                            [fileManager copyItemAtPath:bundle toPath: path error:&error];
                        }
                        
                        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
                        
                        [authData setObject:json forKey:@"podcode"];
                        [authData writeToFile:path atomically:YES];
                        break;
                    }
                }
            }
        }
        
        return NO;
    }
    
    //콤보박스 선사 즐겨찾기
    if ([requestString hasPrefix:@"hybridappsetcarriercode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"carriercode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"carriercode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboCarrierCode(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboCarrierCode(%@)", @""]];
        }
        
        return NO;
    }
    
    
    //콤보박스 양하 즐겨찾기
    if ([requestString hasPrefix:@"hybridappsetpodcode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"podcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"podcode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboPodCode(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboPodCode(%@)", @""]];
        }
        
        return NO;
    }
    
    //콤보박스 터미널 즐겨찾기
    if ([requestString hasPrefix:@"hybridappsetterminalcode://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"terminalcode.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSError* error;
        NSDictionary* json = [authData objectForKey:@"terminalcode"];
        
        if(json != nil) {
            NSArray *arr = [json objectForKey:@"list"];
            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:arr options:0 error:&error];
            NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
            
            if(myString == nil) myString = @"";
            NSLog(@"myString : %@", myString);
            
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboTerminalCode(%@)", myString]];
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setComboTerminalCode(%@)", @""]];
        }
        
        return NO;
    }
    
    //URL이동
    if ([requestString hasPrefix:@"hybridappgourl://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappgourl://"];
        NSString *jsString = [jsDataArray objectAtIndex:1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, jsString]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
        [webView01 loadRequest:request];
        return NO;
    }
    

    //URL이동
    if ([requestString hasPrefix:@"hybridappgoweburl://"]) {
        NSArray *jsDataArray = [requestString componentsSeparatedByString:@"hybridappgoweburl://"];
        NSString *url = [jsDataArray objectAtIndex:1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",connectUrl, url]]];
        return NO;
    }
    
    //세션끊겼을때 자동로그인
    if ([requestString hasPrefix:@"hybridappautorelogin://"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSNumber * nisAutoLogin = [authData objectForKey:@"isautologin"];
        Boolean isAutoLogin = [nisAutoLogin boolValue];
        NSString *vid = [authData objectForKey:@"vid"];
        //NSString *vpassword = [authData objectForKey:@"vpassword"];
        NSString *vAutoLogin = @"Y";
        if (!isAutoLogin) {
            vAutoLogin = @"N";
        }
        if(vid == nil) vid = @"";

        NSString* diviceId = [OpenUDID value];
        NSLog(@"DeviceId :%@", diviceId);
        NSLog(@"vid :%@", vid);
        NSLog(@"vAutoLogin :%@", vAutoLogin);
        
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setIsAutoLogin('%@','%@','%@');",vAutoLogin, diviceId, vid]];
        
        if([DataSet sharedDataSet].isLogin && isAutoLogin && vid.length != 0 ) {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:appAutoLogin('%@','%@');",vid, diviceId]];
        }

        return NO;
    }

    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *currentURL = webView.request.URL.absoluteString;
    NSLog(@"webViewDidFinishLoad - currentURL : %@",currentURL);
    
    NSRange range_login;
    range_login = [currentURL rangeOfString:@"/newmobile/login.do"];
    
    if (range_login.location != NSNotFound) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"autologin.plist"];
        NSMutableDictionary *authData = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        NSNumber * nisAutoLogin = [authData objectForKey:@"isautologin"];
        Boolean isAutoLogin = [nisAutoLogin boolValue];
        NSString *vid = [authData objectForKey:@"vid"];
        //NSString *vpassword = [authData objectForKey:@"vpassword"];
        NSString *vAutoLogin = @"Y";
        if (!isAutoLogin) {
            vAutoLogin = @"N";
        }
        if(vid == nil) vid = @"";

        NSString* diviceId = [OpenUDID value];
        NSLog(@"DeviceId :%@", diviceId);
        NSLog(@"vid :%@", vid);
        NSLog(@"vAutoLogin :%@", vAutoLogin);
        
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:setIsAutoLogin('%@','%@','%@');",vAutoLogin,diviceId, vid]];
        if(isAutoLogin && vid.length != 0) {
            [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:appAutoLogin('%@','%@');",vid, diviceId]];
        } else {
            [iv_intro setHidden:YES];
            [webView01 setHidden:NO];
        }
    
        
    }
    
    NSRange range_main;
    range_main = [currentURL rangeOfString:@"/newmobile/main.do"];
    
    if (range_main.location != NSNotFound) {
        [DataSet sharedDataSet].isLogin = true;
        [iv_intro setHidden:YES];
        [webView01 setHidden:NO];
        isMain = true;
        [webView01 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:getUnreadNotiCnt('%@','%@');",APPID, [OpenUDID value]]];
        if (isPushMain) {
            isPushMain = false;
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:open_push_menu();"];
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:getNotiList('all', 'Y');"];
        }
    } else {
        isMain = false;
    }
    

    if (range_login.location == NSNotFound) {

    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error.code : %ld", (long)error.code);
    NSLog( @"didFailLoadWithError - [DataSet sharedDataSet].connectUrl : %@", [DataSet sharedDataSet].connectUrl);
    if(error.code == 999 || error.code == -999) {
        
    } else if(error.code == -1001 || error.code == 1001) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newmobile/main.do", [DataSet sharedDataSet].connectUrl]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
        [webView01 loadRequest:request];
    } else {
        [iv_intro setHidden:YES];
        [webView01 setHidden:NO];
        UIAlertController * alert =  [UIAlertController
                                      alertControllerWithTitle:@"오류"
                                      message:error.localizedDescription
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"확인"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       NSLog(@"OK action");
                                   }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    NSLog(@"Error : %@",error);
}

- (void) callPush {
    NSLog(@"isMain : %hhu", isMain);
    
    if([DataSet sharedDataSet].isLogin) {
        if(!isMain) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/newmobile/main.do",[DataSet sharedDataSet].connectUrl ]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0.0f];
            [webView01 loadRequest:request];
            isPushMain = true;
        } else {
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:open_push_menu();"];
            [webView01 stringByEvaluatingJavaScriptFromString:@"javascript:getNotiList('all', 'Y');"];
        }
    } else {
        isPushMain = true;
    }
}

- (NSString *)sendDataToServer{
    __block NSString *returnValue;
    
    NSLog( @"sendDataToServer - MAIN_URL : %@", MAIN_URL);
    NSUInteger length = [MAIN_URL length];
    NSString *getURL = [NSString stringWithFormat:@"%@/newmobile/selectMobileHashKey.do?app_id=ETRANS&app_os=ios&app_version=%lu",MAIN_URL,(unsigned long)length];
    
    
    NSURL* url = [NSURL URLWithString:getURL];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil  error:&error];
    
    if(data != nil) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        returnValue = [dic objectForKey:@"hash_code"];
    }
    
    return returnValue;
}


- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i=0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x",digest[i]];
    
    
    return output;
}
- (BOOL)checkRooting {
    BOOL returnValue = YES;
    NSArray *checkList=[NSArray arrayWithObjects:
                         @"/Applications/Cydia.app",
                         @"/Applications/RockApp.app",
                         @"/Applications/Icy.app",
                         @"/usr/sbin/sshd",
                         @"/usr/bin/sshd",
                         @"/usr/libexec/sftp-server",
                         @"/Applications/WinterBoard.app",
                         @"/Applications/SBSettings.app",
                         @"/Applications/MxTube.app",
                         @"/Applications/IntelliScreen.app",
                         @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                         @"/Applications/FakeCarrier.app",
                         @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                         @"/private/var/lib/apt",
                         @"/Applications/blackra1n.app",
                         @"/private/var/stash",
                         @"/private/var/mobile/Library/SBSettings/Themes",
                         @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                         @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                         @"/private/var/tmp/cydia.log",
                         @"/private/var/lib/cydia",
                         nil];
    if(!TARGET_IPHONE_SIMULATOR) {
        for (NSString *filePath in checkList) {
            if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                returnValue = NO;
                break;
            }
        }
    }
    return returnValue;
}

-(NSData*)httpRequest:(NSString*)surl {
    @synchronized(self)
    {
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", surl]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse *theResponse;
        NSError *theError;
        NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        if (!theResponseData) {
            return nil;
        }
        
        return theResponseData;
    }
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
