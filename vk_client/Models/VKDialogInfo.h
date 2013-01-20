//
// Created by dkorneev on 12/3/12.
//



#import <Foundation/Foundation.h>


@interface VKDialogInfo : NSObject

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *readState;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, strong) NSNumber *deleted;

// для групповых бесед
@property (nonatomic, strong) NSNumber *chatId; // id беседы
@property (nonatomic, strong) NSString *chatActive; // id участников беседы (но не более 6ти)
@property (nonatomic, strong) NSString *usersCount; //  количество участнико
@property (nonatomic, strong) NSNumber *adminId; // id создателя беседы

// массив вложений
@property (nonatomic, strong) NSArray *attachments;


+ (VKDialogInfo *)createFromDictionary:(NSDictionary *)arg;

- (BOOL)isGroupDialog;
- (BOOL)hasMediaAttachment;

@end