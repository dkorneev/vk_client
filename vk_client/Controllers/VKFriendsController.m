//
// Created by admin on 11/25/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VKFriendsController.h"
#import "VKFriendsService.h"
#import "VKFriendInfo.h"
#import "VKFriendsListCell.h"


@interface VKFriendsController ()
@property(nonatomic, strong) VKFriendsService *service;
@property(nonatomic, strong) NSArray *friends;

@property(nonatomic, strong) NSArray *orderedKeys;
@property(nonatomic, strong) NSDictionary *friendsMap;

@property(nonatomic, strong) UITableView *tableView;
@end

@implementation VKFriendsController

- (id)init {
    self = [super init];
    if (self) {
        self.friends = @[];
        self.orderedKeys = @[];
        self.friendsMap = [[NSDictionary alloc] init];
        [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5];
    }
    return self;
}

- (void)refreshData {
    __weak VKFriendsController *weakSelf = self;
    self.service = [[VKFriendsService alloc] initWithCompletionBlock:^(NSArray *array) {
        // TODO: проверить!
        // если код этого блока выполняется в потоке,
        // параллельном main-потоку, то необходима синхронизация
        weakSelf.friends = array;
        weakSelf.friendsMap = [weakSelf createDictionaryFromFriendsArray:array];

        // получаем массив упорядоченных ключей (англ. символы вначале)
        NSMutableArray *keys = [NSMutableArray arrayWithArray:
                [[weakSelf.friendsMap allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
                    return [(NSString *) obj1 caseInsensitiveCompare:(NSString *) obj2];
                }]];

        // переносим русские символы в начало
        NSCharacterSet *lcRussianLetters = [NSCharacterSet characterSetWithCharactersInString:
                @"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" ];
        NSIndexSet *ruKeysIndexes = [keys indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [(NSString *)obj rangeOfCharacterFromSet:lcRussianLetters].location != NSNotFound;
        }];
        NSArray *ruKeys = [keys objectsAtIndexes:ruKeysIndexes];
        [keys removeObjectsAtIndexes:ruKeysIndexes];
        weakSelf.orderedKeys = [ruKeys arrayByAddingObjectsFromArray:keys];

        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:weakSelf.tableView];
        [weakSelf.tableView reloadData];
    }];

    _reloading = YES;
    [self.service getFriends];
}

// Функция возвращает словарь, где ключ - первая буква фаимилии (lastName),
// а значение - объект класса VKFriendsInfo. Исползуется для распределения друзей по секциям.
- (NSDictionary *)createDictionaryFromFriendsArray:(NSArray *)originalArray {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];

    if (!originalArray)
        return ret;

    NSString *curFriendLastName = nil,
            *firstLetter1 = nil;
    for (NSUInteger i = 0; i < originalArray.count; ++i) {
        curFriendLastName = [[originalArray objectAtIndex:i] valueForKey:@"lastName"];
        firstLetter1 = [curFriendLastName substringWithRange:NSMakeRange(0, 1)];

        //  проверка, было ли уже добавление в словарь по текущей букве
        if ([ret valueForKey:[firstLetter1 uppercaseString]] || [ret valueForKey:[firstLetter1 lowercaseString]])
            continue;

        // ищем людей, у которых фамилия начинается с текущего символа
        NSIndexSet *result = [originalArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSString *lastName = [obj valueForKey:@"lastName"];
            NSString *firstLetter2 = [lastName substringWithRange:NSMakeRange(0, 1)];
            return ([firstLetter1 caseInsensitiveCompare:firstLetter2] == NSOrderedSame);
        }];

        // если нашли - добавляем новое значение в словарь, предварительно отсортировав
        if (result.count) {
            NSArray *array = [originalArray objectsAtIndexes:result];
            array = [array sortedArrayUsingComparator:^(id obj1, id obj2) {
                return [((VKFriendInfo *)obj1).lastName caseInsensitiveCompare:((VKFriendInfo *)obj2).lastName];
            }];
            [ret setValue:array forKey:[firstLetter1 uppercaseString]];
        }
    }
    return ret;
}

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = self.tableView = tableView;
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.orderedKeys objectAtIndex:(NSUInteger)indexPath.section];
    NSArray *valuesArray = (NSArray *) [self.friendsMap valueForKey:key];

    if (indexPath.row > valuesArray.count - 1) {
        return [[UITableViewCell alloc] init];

    } else {
        VKFriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[VKFriendsListCell cellIdentifier]];
        if (!cell)
            cell = [[VKFriendsListCell alloc] init];
        VKFriendInfo *friendInfo = [valuesArray objectAtIndex:(NSUInteger)indexPath.row];
        [cell fillByFriendsInfo:friendInfo];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

// количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderedKeys.count;
}

// количество ячеек в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.orderedKeys objectAtIndex:(NSUInteger)section];
    return ((NSArray *)[self.friendsMap valueForKey:key]).count;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [self.orderedKeys objectAtIndex:(NSUInteger)section];
}

// массив заголовков секции
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.orderedKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    [self refreshData];
}

@end