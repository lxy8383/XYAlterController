//
//  YSCustomAlterController.h
//  YSOA
//
//  Created by liuxy on 2019/7/26.
//  Copyright © 2019 YS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YSLayout.h"
#import <Masonry.h>
#import "YSContactsModel.h"
#import "UIImage+YSPlaceholder.h"
#import "UIImageView+YSCache.h"

typedef enum : NSUInteger {
    nomalActionType,
    cancelActionType,
    sureActionType,
} YSAlterActionType;


// 按钮布局
typedef enum : NSUInteger {
    landscapeType,              //横向
    verticalType,               //竖向
} YSAlterActionLayoutType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AlterControllerSureBlock)(void);

@interface YSCustomAlterController : UIViewController

/**
 初始化alter

 @param title 标题
 @param message 文字
 @return 对象本身
 */
+ (instancetype)alterControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                         sureActionBlock:(AlterControllerSureBlock)block;

/**
 初始化alter

 @param userModel 附带用户信息
 @param infoMessage 提示语句
 @return 本类
 */
+ (instancetype)alterControllerWithUser:(nullable YSContactsModel *)userModel
                                message:(nullable NSString *)infoMessage
                        sureActionBlock:(AlterControllerSureBlock)block;

// 点击按钮
- (void)addActionTitles:(NSArray *)actionTitles;


@end



#pragma mark -
#pragma mark - UserInfoView

@interface YSAlterUserView : UIView

// 横线
@property (nonatomic, strong) UIView *lineView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

//头像
@property (nonatomic, strong) UIImageView *avatarImgView;

//姓名label
@property (nonatomic, strong) UILabel *userNameLabel;

//指示图
@property (nonatomic, strong) UIImageView *indicateImgView;

@end




#pragma mark -
#pragma mark - ActionButton

typedef void(^ActionBlock)(void);

@interface YSAlterAction : UIButton

- (instancetype)initWithAction:(YSAlterActionType)actionType
                andActionBlock:(ActionBlock)block;

@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
