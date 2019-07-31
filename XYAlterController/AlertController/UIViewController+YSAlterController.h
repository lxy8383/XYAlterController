//
//  UIViewController+YSAlterController.h
//  YSOA
//
//  Created by liuxy on 2019/7/19.
//  Copyright © 2019 YS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YSAlterController)

- (void)alterControllerWithTitle:(NSString * __nullable)title
                          mesage:(NSString * __nullable)message
                   andSureAction:(void (^)(UIAlertAction * sureAction))sureBlock;

@end

NS_ASSUME_NONNULL_END
