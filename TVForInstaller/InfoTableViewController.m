//
//  InfoTableViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/29.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InfoTableViewController.h"
#import "ComminUtility.h"
#import "AccountManager.h"
#import "NetworkingManager.h"
#import "GenderViewController.h"
#import <SVProgressHUD.h>
typedef void(^alertBlock)(void);
//#define kMaxLength 5


@interface InfoTableViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,genderDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *chinaIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) NSInteger gender;


@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;


@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [ComminUtility configureTitle:@"个人信息" forViewController:self];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [save setAttributedTitle:[[NSAttributedString alloc]initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}] forState:UIControlStateNormal];
    save.frame = CGRectMake(0, 0, 40, 30);
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    
    [self fetchInfo];
    
    [self configureTextFieldNotification];
    
    
}

-(void)save{
    
    [self.nameTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    
    if ([self.name isEqualToString:@""]|| self.name == nil) {
        
        //        self alertWithMessage:@"地址信息不能为空" withCompletionHandler
        [self alertWithMessage:@"姓名不能为空" withCompletionHandler:^{
            
        }];
        return;
    }
    
    if (![ComminUtility validateName:self.name]) {
        
        //        self alertWithMessage:@"地址信息不能为空" withCompletionHandler
        [self alertWithMessage:@"姓名为2～4个汉字" withCompletionHandler:^{
            
        }];
        return;
    }


    if ([self.address isEqualToString:@""]|| self.address == nil) {
        
//        self alertWithMessage:@"地址信息不能为空" withCompletionHandler
        [self alertWithMessage:@"地址信息不能为空" withCompletionHandler:^{
            
        }];
        return;
    }
 
    
    
    [SVProgressHUD showWithStatus:@"保存中"];
    
    [NetworkingManager modifyInfowithGender:self.gender name:self.name address:self.address withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"]integerValue] == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            });
            
        } else{
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                
                [AccountManager setName:self.name];
                [AccountManager setAddress:self.address];
                [AccountManager setgender:self.gender];
            });

        }
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    
}

-(void)fetchInfo{
    
    if (![[AccountManager getName] isEqualToString:@""] &&
        [AccountManager getName] != nil) {
        self.name = [AccountManager getName];
        self.nameTextField.text = self.name;
    }
    self.cellphoneLabel.text = [AccountManager getCellphoneNumber];
    self.chinaIDLabel.text  =[AccountManager getIDCard];
    
    
    self.gender = [AccountManager getGender];
    if (self.gender == 0) {
        self.genderLabel.text = @"男";
    } else{
        self.genderLabel.text = @"女";
    }
    
    self.address = [AccountManager getAddress];
    self.addressTextField.text = self.address;
    
    
    self.levelImageView.image = [UIImage imageNamed:@"zuanshi"];
    
    self.levelLabel.text = @"钻石级";
    
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld",[AccountManager getScore]];
    
    NSInteger level =  [AccountManager getRank];
    if (level == 0) {
        
        
        self.rankLabel.text = @"银卡";
        self.rankImageView.image = [UIImage imageNamed:@"yinka"];
        
    } else if (level ==1){
        self.rankLabel.text = @"金卡";
        self.rankImageView.image = [UIImage imageNamed:@"jinka"];
        
    } else{
        self.rankLabel.text = @"钻石";
        self.rankImageView.image = [UIImage imageNamed:@"zuanshi"];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0]];

    [self.view layoutIfNeeded];
}


-(void)pop{
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&& indexPath.row == 0) {
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
        GenderViewController *gender = [sb instantiateViewControllerWithIdentifier:@"GenderViewController"];
        gender.delegate = self;
        gender.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self showDetailViewController:gender sender:self];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textfield: %@",textField.text);
    if (textField == self.nameTextField) {
        //姓名
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.name = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.name = [textField.text stringByAppendingString:string];
        }
        
        if ([string isEqualToString:@"\n"]) {
            self.name = textField.text;
        }
        
        if (range.length + range.location > textField.text.length) {
            return NO;
        }
        
        
    } else if(textField == self.addressTextField){
        //地址
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.address = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.address = [textField.text stringByAppendingString:string];
        }
        
        if ([string isEqualToString:@"\n"]) {
            self.address = textField.text;
        }

    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTextField) {
    
        self.name = textField.text;
    } else if(textField == self.addressTextField){
        self.address = textField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

-(void)didSelectedType:(GenderSelectType)type{
    if (type == Male) {
        self.genderLabel.text = @"男";
        self.gender = 0;
    }else if (type ==Female){
        self.genderLabel.text = @"女";
        self.gender = 1;


    }
}

-(void)alertWithMessage:(NSString*)message withCompletionHandler:(alertBlock)handler{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (handler) {
            handler();
        }
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)configureTextFieldNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.addressTextField];

}

-(void)textFieldEditChanged:(NSNotification*)notofication{
    

    NSInteger kMaxLength = 5;
    UITextField *textField = notofication.object;
    
    if (textField != self.nameTextField) {
        kMaxLength = 50;
    }
    
    NSString *toBeString = textField.text;

    NSArray *current = [UITextInputMode activeInputModes];
    UITextInputMode *inputMode = [current firstObject];
    
    NSString *lang = [inputMode primaryLanguage];

    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                
                
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
