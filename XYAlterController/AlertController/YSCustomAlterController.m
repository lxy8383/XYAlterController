//
//  YSCustomAlterController.m
//  YSOA
//
//  Created by liuxy on 2019/7/26.
//  Copyright © 2019 YS. All rights reserved.
//

#import "YSCustomAlterController.h"


@interface YSCustomAlterController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;


@property (nonatomic, strong) YSAlterUserView *userView;

@property (nonatomic, strong) UILabel *remarksLabel;

@property (nonatomic, strong) UITextField *textField;

// 提示语句
@property (nonatomic, copy) NSString *remarkString;

// 点击确认按钮回调
@property (nonatomic, copy) AlterControllerSureBlock sureBlock;

@end

@implementation YSCustomAlterController

+ (instancetype)alterControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                         sureActionBlock:(AlterControllerSureBlock)block
{
    YSCustomAlterController *alterController = [[YSCustomAlterController alloc]init];
    alterController.sureBlock = block;
    alterController.titleLabel.text = title;
    alterController.contentLabel.text = message;
    alterController.userView.hidden = YES;
    alterController.textField.hidden = YES;
    return alterController;
}

+ (instancetype)alterControllerWithUser:(nullable YSContactsModel *)userModel
                                message:(nullable NSString *)infoMessage
                        sureActionBlock:(AlterControllerSureBlock)block
{
    
    YSCustomAlterController *alterController = [[YSCustomAlterController alloc]init];
    alterController.remarkString = infoMessage;
    [alterController confToUserView:userModel];
    alterController.sureBlock = block;
    return alterController;
}
- (instancetype)init
{
    self = [super init];
    if(self){
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.view.backgroundColor = YSColorWithHexAlpha(0x333333, 0.4);
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpUI];
}

#pragma mark - public
- (void)addActionTitles:(NSArray *)actionTitles
{
    NSArray *typeArr = @[@(cancelActionType),@(sureActionType)];
    if(actionTitles.count == 1){
        YSAlterAction *tempButton = [[YSAlterAction alloc]initWithAction:nomalActionType  andActionBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
            if(self.sureBlock){
                self.sureBlock();
            }
        }];
        [tempButton setTitle:[actionTitles firstObject] forState:UIControlStateNormal];
        [self.contentView addSubview:tempButton];
        [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-4);
            make.right.left.mas_equalTo(self.contentView);
        }];
        return;
    }
    for(int i = 0 ; i < actionTitles.count; i++){
        __weak typeof(self) weakSelf = self;
        YSAlterAction *cancelAction = [[YSAlterAction alloc]initWithAction:[typeArr[i] integerValue]  andActionBlock:^{
            if([typeArr[i] integerValue] == cancelActionType){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else if([typeArr[i] integerValue] == sureActionType){
                [self dismissViewControllerAnimated:YES completion:nil];
                if(self.sureBlock){
                    self.sureBlock();
                }
            }
        }];
        
        [cancelAction setTitle:actionTitles[i] forState:UIControlStateNormal];
        [self.contentView addSubview:cancelAction];
        [cancelAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-4);
            make.width.mas_equalTo(272.f / actionTitles.count );
            make.left.mas_equalTo( i * ( 272.f / actionTitles.count ) );
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = YSColorWithHex(0xF2F2F2);
        [self.contentView addSubview:lineView];
        
        if(i < actionTitles.count - 1){
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cancelAction.mas_top);
                make.right.mas_equalTo(cancelAction.mas_right).mas_offset(-1);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(0.5);
            }];
        }
    }
}
#pragma mark - 配置数据
- (void)confToUserView:(YSContactsModel *)model
{
    [self.userView.avatarImgView ys_setImageWithURL:[NSURL URLWithString:model.iconName] placeholderImage:[UIImage ys_avatarPlaceholder36]];
    self.userView.userNameLabel.text = model.nameStr;
    
    self.remarksLabel.text = self.remarkString;
    
}

- (void)viewLayoutMarginsDidChange
{
    [super viewLayoutMarginsDidChange];
    
    if(self.titleLabel.text.length > 0){
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(26);
        }];
    }
    
    if(self.contentLabel.text.length > 0){
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(self.titleLabel.text.length > 0 ? 57 : 21);
        }];
    }
    NSLog(@"高度： %f",self.contentLabel.ys_height);
}

#pragma mark - action
- (void)setUpUI
{
    CGFloat nomalHeight = 256.f;
    if(self.remarkString.length == 0){
        nomalHeight = 221;
    }
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270, nomalHeight));
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.contentView addSubview:self.titleLabel];

    [self.contentView addSubview:self.contentLabel];
    
 
    [self.contentView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(14);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(80);
    }];
    
    [self.contentView addSubview:self.remarksLabel];
    [self.remarksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(19);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-19);
        make.height.mas_offset(17);
    }];
    
    [self.contentView addSubview:self.textField];
    
    if(self.remarkString.length == 0){
        self.remarksLabel.hidden = YES;
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userView.mas_bottom).mas_offset(13);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(18);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-18);
            make.height.mas_offset(55);
        }];
    }else{
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.remarksLabel.mas_bottom).mas_offset(6);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(18);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-18);
            make.height.mas_offset(55);
        }];
    }
}

#pragma mark - lazy
- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 7;
    }
    return _contentView;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = YSColorWithHex(0x333333);
        _titleLabel.font = [UIFont ys_medium:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = YSColorWithHex(0x333333);
        _contentLabel.font = [UIFont ys_regular:16];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (YSAlterUserView *)userView
{
    if(!_userView){
        _userView = [[YSAlterUserView alloc]init];
    }
    return _userView;
}
- (UILabel *)remarksLabel
{
    if(!_remarksLabel){
        _remarksLabel = [[UILabel alloc]init];
        _remarksLabel.textColor = YSColorWithHex(0x999999);
        _remarksLabel.font = [UIFont ys_regular:12];
    }
    return _remarksLabel;
}
- (UITextField *)textField
{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = YSColorWithHex(0xF9F9F9);
        _textField.placeholder = @"  留言";
        _textField.font = [UIFont ys_regular:16];
    }
    return _textField;
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



@implementation YSAlterUserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.avatarImgView];
    [self addSubview:self.userNameLabel];
    [self addSubview:self.indicateImgView];
    [self addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(90, 23));
    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(16);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgView.mas_right).mas_offset(11);
        make.height.mas_equalTo(23);
        make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
    }];
    
    [self.indicateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.size.mas_equalTo(CGSizeMake(10, 20));
        make.centerY.mas_equalTo(self.avatarImgView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImgView.mas_bottom).mas_offset(7);
        make.left.right.mas_equalTo(self);
        make.height.mas_offset(0.5);
    }];
    
}
#pragma mark - lazy
- (UIView *)lineView
{
    if(!_lineView){
        _lineView  = [[UIView alloc]init];
        _lineView.backgroundColor = YSColorWithHex(0xE6E6E6);
    }
    return _lineView;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont ys_regular:16];
        _titleLabel.textColor = YSColorWithHex(0x333333);
        _titleLabel.text = @"发送给:";
    }
    return _titleLabel;
}
- (UIImageView *)avatarImgView
{
    if(!_avatarImgView){
        _avatarImgView = [[UIImageView alloc]init];
        _avatarImgView.layer.cornerRadius = 4;
        _avatarImgView.layer.masksToBounds = YES;
    }
    return _avatarImgView;
}

- (UILabel *)userNameLabel
{
    if(!_userNameLabel){
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.text = @"hello小土";
        _userNameLabel.font = [UIFont ys_regular:16];
        _userNameLabel.textColor = YSColorWithHex(0x333333);
    }
    return _userNameLabel;
}

- (UIImageView *)indicateImgView
{
    if(!_indicateImgView){
        _indicateImgView = [[UIImageView alloc]init];
        _indicateImgView.image = [UIImage imageNamed:@"arrow-black"];
    }
    return _indicateImgView;
}
@end




#pragma mark -
#pragma mark - ActionButton

@interface YSAlterAction()

@property (nonatomic, copy) ActionBlock actionBlock;

@end

@implementation YSAlterAction

- (instancetype)initWithAction:(YSAlterActionType)actionType
                andActionBlock:(ActionBlock)block
{
    self = [super init];
    if(self){
        [self setUpUI];
        self.actionBlock = block;
        
        self.titleLabel.font = [UIFont ys_regular:18];
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if(actionType == cancelActionType){
            [self setTitleColor:YSColorWithHex(0x000000) forState:UIControlStateNormal];
            
        }else if(actionType == sureActionType || actionType == nomalActionType){
            [self setTitleColor:YSColorWithHex(0x3D7EFF) forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)setUpUI
{
    [self addSubview:self.lineView];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
}
#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender
{
    if(self.actionBlock){
        self.actionBlock();
    }
}

#pragma mark - lazy
- (UIView *)lineView
{
    if(!_lineView){
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = YSColorWithHex(0xF2F2F2);
    }
    return _lineView;
}



@end
