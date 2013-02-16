//
// Created by dkorneev on 11/24/12.
//



#import <Foundation/Foundation.h>

@class VKLongPollInfoService;
@class VKLongPollService;


@interface VKWebViewController : UIViewController <UIWebViewDelegate>

- (id)initWithCompletionBlock:(void (^)())completionBlock;

- (void)loadRequest;

+ (void)clearCookies;

@end