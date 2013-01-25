//
// Created by dkorneev on 11/24/12.
//


#import "VKWebViewController.h"
#import "VKFriendsController.h"
#import "VKDialogsController.h"
#import "VKSettingsController.h"
#import "VKUtils.h"

@interface VKWebViewController ()
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation VKWebViewController

- (void)loadView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.webView.delegate = self;
    self.view = self.webView;

    NSString *urlString = @"https://oauth.vk.com/authorize?"
            "client_id=3230902&"
            "scope=friends,messages&"
            "redirect_uri=https://oauth.vk.com/blank.html&"
            "display=mobile&"
            "response_type=token";

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(UIWebViewNavigationType)navigationType {

    NSCharacterSet *chSet = [NSCharacterSet characterSetWithCharactersInString:@"#"];
    if ([[request.URL absoluteString] rangeOfCharacterFromSet:chSet].location != NSNotFound) {
        NSArray *urlComponents = [[request.URL absoluteString] componentsSeparatedByString:@"#"];
        NSDictionary *params =  [self URLparamsToDictionary:(NSString *)[urlComponents objectAtIndex:1]];
        if ([params valueForKey:@"access_token"] != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"access_token"] forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:[params valueForKey:@"user_id"] forKey:@"user_id"];
            NSLog(@"ACCESS_TOKEN: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]);
            NSLog(@"USER_ID: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]);

            // запускаем  longPoll-service
            VKLongPollService *longPollService = [ [VKLongPollService alloc] init];
            [longPollService start:^{ [self showTabBar]; }];
        }
    }
    return ([request.URL.host isEqualToString:@"oauth.vk.com"] || [request.URL.host isEqualToString:@"login.vk.com"]);
}

- (void)showTabBar {
    // Контакты
    UINavigationController *friendsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:friendsNav.navigationBar];
    [friendsNav pushViewController:[[VKFriendsController alloc] init] animated:NO];
    friendsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Друзья" image:[UIImage imageNamed:@"tabbar-contacts-icon.png"] tag:0];

    // Диалоги
    UINavigationController *dialogsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:dialogsNav.navigationBar];
    [dialogsNav pushViewController:[[VKDialogsController alloc] init] animated:NO];
    dialogsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Диалоги" image:[UIImage imageNamed:@"tabbar-messages-icon.png"] tag:1];

    // Профиль
    UINavigationController *settingsNav = [[UINavigationController alloc] init];
    [VKUtils configNavigationBar:settingsNav.navigationBar];
    [settingsNav pushViewController:[[VKSettingsController alloc] init] animated:YES];
    settingsNav.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Профиль" image:[UIImage imageNamed:@"tabbar-settings-icon.png"] tag:2];

    // показываем слудеющий экран
    UITabBarController *mainTabBar = [[UITabBarController alloc] init];
    [mainTabBar setViewControllers:@[
            friendsNav, dialogsNav, settingsNav]];
    [self.navigationController pushViewController:mainTabBar animated:YES];
}

// парсит часть URL, содержащую параметры и возвращает их в виде словаря
- (NSDictionary *)URLparamsToDictionary:(NSString *)URLparams {
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [URLparams componentsSeparatedByString:@"&"];

    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];

        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

@end