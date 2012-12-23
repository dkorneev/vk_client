//
// Created by admin on 10/29/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKLoginController.h"
#import "VKUtils.h"
#import "VKEditableCell.h"
#import "VKLoginButton.h"
#import "VKRegistrationButton.h"
#import "VKFriendsService.h"


@interface VKLoginController ()
@property(nonatomic, strong) VKFriendsService *service;

@end

@implementation VKLoginController
@synthesize service = _service;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.navigationItem.titleView = [VKUtils createNavigationItemTitle:@"Добро пожаловать"];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;

    UIView *backTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    backTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    table.backgroundView = backTableView;
    table.scrollEnabled = NO;

    self.view = table;
}

#pragma mark UITableViewDataSource, UITableViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [[VKEditableCell alloc] initWithDefaultText:indexPath.row ? @"Пароль" : @"Номер телефона"];

    } else if (indexPath.section == 1) {
        cell = [[VKLoginButton alloc] initWithTitle:@"Войти" target:self action:@selector(authorize)];

    } else {
        cell = [[VKRegistrationButton alloc] initWithTitle:@"Зарегестрироваться" target:self action:@selector(authorize)];
    }
    return cell;
}

- (void)authorize {
//    _service = [[VKFriendsService alloc] init];
//    [_service sendRequests];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        default:
            return 1;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        default:
            return;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2)
        return 200;
    else
        return 45;
}

@end