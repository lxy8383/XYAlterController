//
//  UIViewController+YSAlterController.m
//  YSOA
//
//  Created by liuxy on 2019/7/19.
//  Copyright © 2019 YS. All rights reserved.
//

#import "UIViewController+YSAlterController.h"

@implementation UIViewController (YSAlterController)

- (void)alterControllerWithTitle:(NSString * __nullable)title
                          mesage:(NSString * __nullable)message
                   andSureAction:(void (^)(UIAlertAction * sureAction))sureBlock
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) { }];
    
    UIAlertAction *actionSubmit = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if(sureBlock){
                                                                 sureBlock(action);
                                                             }
                                                         }];
    [alterController addAction:actionCancel];
    [alterController addAction:actionSubmit];
    [self presentViewController:alterController animated:YES completion:nil];
}
@end
