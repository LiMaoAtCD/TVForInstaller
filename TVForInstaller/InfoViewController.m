//
//  InfoViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InfoViewController.h"
#import "ComminUtility.h"
#import "InfoTableViewCell.h"
#import <JGProgressHUD.h>

typedef void(^alertBlock)(void);

@interface InfoViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *items;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *cellphone;
@property (nonatomic,copy) NSString *chinaID;


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [ComminUtility configureTitle:@"个人信息" forViewController:self];
    
    self.items = @[@{@"title":@"姓名",@"placeholder":@"您的真实姓名"},
                   @{@"title":@"手机号码",@"placeholder":@"您的手机号码"},
                   @{@"title":@"身份证号",@"placeholder":@"您的身份证号"}];
    
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]}] forState:UIControlStateNormal];
//    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
    cell.InfoTitle.text  = self.items[indexPath.row][@"title"];
    
    cell.InfoTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.items[indexPath.row][@"placeholder"] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    cell.InfoTextField.delegate = self;
    cell.InfoTextField.tag = indexPath.row;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 0) {
        //姓名
        
        if ([string isEqualToString:@""]) {
            self.name = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.name = [textField.text stringByAppendingString:string];
        }

        
    } else if(textField.tag == 1){
        //手机号
        
        if ([string isEqualToString:@""]) {
            self.cellphone = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.cellphone = [textField.text stringByAppendingString:string];
        }

        
    } else if(textField.tag == 2){
        //身份证号
        if ([string isEqualToString:@""]) {
            self.chinaID = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.chinaID = [textField.text stringByAppendingString:string];
        }
    }
    
    return YES;
}



-(void)saveInfo:(UIButton *)button {
    
    if ([self.name isEqualToString:@""]||
        self.name == nil) {
        //姓名为空
        NSLog(@"姓名为空");
        [self alertWithMessage:@"姓名不能为空" withCompletionHandler:^{
        }];
        return;
    }
    
    if ([self.cellphone isEqualToString:@""]||
        self.cellphone == nil) {
        //姓名为空
        NSLog(@"shouji为空");
        [self alertWithMessage:@"手机号码不能为空" withCompletionHandler:^{
        }];
        return;

    }
    
    if ([self.chinaID isEqualToString:@""]||
        self.chinaID == nil) {
        //身份正好为空
        NSLog(@"shenfen为空");
        [self alertWithMessage:@"身份证号不能为空" withCompletionHandler:^{
        }];
        return;

    }
    
    
    //TODO: 修改数据
    
    
    
    
    
}

-(void)alertWithMessage:(NSString*)message withCompletionHandler:(alertBlock)handler{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        handler();
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
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
