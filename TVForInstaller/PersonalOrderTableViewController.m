//
//  PersonalOrderTableViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/27.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "PersonalOrderTableViewController.h"
#import "ComminUtility.h"
#import "AddOrderTableViewCell.h"
#import "ZhijiaTableViewCell.h"
#import "OrderDataManager.h"
#import "Order.h"
#import "Bill.h"
#import "Applist.h"
#import "AccountManager.h"
#import <JGProgressHUD.h>
typedef void(^alertBlock)(void);

@interface PersonalOrderTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray *placeholders;


@property (nonatomic,strong) NSMutableDictionary *orderInfo;

@property(nonatomic ,strong) UITextField *nameTF;
@property(nonatomic ,strong) UITextField *cellphoneTF;

@property(nonatomic ,strong) UITextField *brandTF;

@property(nonatomic ,strong) UITextField *sizeTF;

@property(nonatomic ,strong) UITextField *addressTF;

@property(nonatomic ,strong) UITextField *versionTF;

@property(nonatomic ,strong) UITextField *activeField;



@end

@implementation PersonalOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [ComminUtility configureTitle:@"订单添加" forViewController:self];
    self.items = @[@"姓名",@"电话",@"品牌",@"尺寸",@"型号",@"支架",@"地址"];
    self.placeholders = @[@"请输入姓名",@"请输入电话",@"请输入品牌",@"请输入尺寸",@"请输入电视型号",@"支架",@"请输入地址"];
    self.orderInfo = [NSMutableDictionary new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];

    [self configureTextFieldNotification];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imageView.image = [UIImage imageNamed:@"sidan"];
    
    [view addSubview:imageView];
    imageView.center = view.center;
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];
    button.backgroundColor =[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0];
    [button addTarget:self action:@selector(saveOrder) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(5, 5, self.view.frame.size.width - 10, 40);
    
    [view addSubview:button];
    
    return view;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==5) {
        ZhijiaTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZhijiaTableViewCell" forIndexPath:indexPath];
        [cell.segment addTarget:self action:@selector(chooseZhijia:) forControlEvents:UIControlEventValueChanged];
        cell.segment.selectedSegmentIndex = 0;
        self.orderInfo[@"zhijia"] = @0;

        
        return cell;

    }else{
        AddOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddOrderTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.items[indexPath.row];
        cell.textField.placeholder =self.placeholders[indexPath.row];
        cell.textField.tag = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
                self.nameTF = cell.textField;
                break;
            case 1:
                self.cellphoneTF = cell.textField;
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
                break;
            case 2:
                self.brandTF = cell.textField;
                break;
            case 3:
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                self.sizeTF = cell.textField;
                break;
            case 4:
                self.versionTF = cell.textField;
                break;
            case 6:
                self.addressTF = cell.textField;
                break;
            default:
                break;
        }
        
        cell.textField.delegate = self;
        return cell;

    }

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.activeField = textField;
    
    if (textField.tag == 0) {
        //姓名
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"name"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"name"]= textField.text;
            
        }else{
            self.orderInfo[@"name"] = [textField.text stringByAppendingString:string];
        }
        
        
    } else if(textField.tag == 1){
        //手机号
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"cellphone"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"cellphone"]= textField.text;
            
        }else{
            self.orderInfo[@"cellphone"] = [textField.text stringByAppendingString:string];
        }
        
        
    } else if(textField.tag == 2){
        //品牌
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"brand"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"brand"]= textField.text;
            
        }else{
            self.orderInfo[@"brand"] = [textField.text stringByAppendingString:string];
        }
    }else if(textField.tag == 3){
        //尺寸
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"size"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"size"]= textField.text;
            
        }else{
            self.orderInfo[@"size"] = [textField.text stringByAppendingString:string];
        }
    }else if(textField.tag == 4){
        //型号
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"version"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"version"]= textField.text;
            
        }else{
            self.orderInfo[@"version"] = [textField.text stringByAppendingString:string];
        }

    }else if(textField.tag == 6){
        //dizhi
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"address"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"address"]= textField.text;
            
        }else{
            self.orderInfo[@"address"] = [textField.text stringByAppendingString:string];
        }
    }
    
    return YES;
}

-(void)chooseZhijia:(UISegmentedControl*)segment{
    if (segment.selectedSegmentIndex ==0) {
        self.orderInfo[@"zhijia"] = @0;
    } else
        self.orderInfo[@"zhijia"] = @1;

}

-(void)saveOrder{
    [self resignKeyboard];
    [self textFieldDidEndEditing:self.activeField];
    if ([self checkCompleted]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [NSDate date];
        
        NSString *createID = [formatter stringFromDate:date];
        
        
        self.orderInfo[@"orderID"] = createID;
        self.orderInfo[@"createdate"] = createID;
        
        
        
        NSError *error;
        
       NSManagedObjectContext *context =  [[OrderDataManager sharedManager] managedObjectContext];
        
        Order *order =[NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
        
        Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
        Applist *applist =[NSEntityDescription insertNewObjectForEntityForName:@"Applist" inManagedObjectContext:context];
        
        applist.appname = @[];
        bill.zhijia =@0;
        bill.zjservice =@0;
        bill.hostphone = self.orderInfo[@"cellphone"];
        bill.sczkfei = @0;
        bill.yiji = @0;
        bill.hdmi = @0;
        
        order.orderid = self.orderInfo[@"orderID"];
        order.createdate = self.orderInfo[@"createdate"];
        order.hoster = self.orderInfo[@"name"];
        order.phone = self.orderInfo[@"cellphone"];
        order.engineer = [AccountManager getTokenID];
        order.brand = self.orderInfo[@"brand"];
        order.size = self.orderInfo[@"size"];
        order.type = self.orderInfo[@"zhijia"];
        order.address = self.orderInfo[@"address"];
        order.version = self.orderInfo[@"version"];
        order.source = @1;
        
        order.bill = bill;
        order.applist = applist;
        
        
        
        NSLog(@"%@",self.orderInfo);
        
        if ([context save:&error]) {
            JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            hud.textLabel.text = @"订单保存成功";
            hud.indicatorView = nil;
            [hud showInView:self.view];
            
            [hud dismissAfterDelay:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSavedOrderToLocal" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}
-(BOOL)checkCompleted{
    
    if ([self.orderInfo[@"name"] isEqualToString:@""]||
        self.orderInfo[@"name"] == nil
        ) {
        [self alertWithMessage:@"姓名不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    if ([self.orderInfo[@"cellphone"] isEqualToString:@""]||
        self.orderInfo[@"cellphone"] == nil
        ) {
        
        [self alertWithMessage:@"手机号码不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    if (![ComminUtility checkTel: self.orderInfo[@"cellphone"]]
        ) {
        
        [self alertWithMessage:@"手机号码不合法" withCompletionHandler:^{
            
        }];
        return NO;
    }

    if ([self.orderInfo[@"brand"] isEqualToString:@""]||
        self.orderInfo[@"brand"] == nil
        ) {
        [self alertWithMessage:@"品牌不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }

    if ([self.orderInfo[@"size"] isEqualToString:@""]||
        self.orderInfo[@"size"] == nil
        ) {
        [self alertWithMessage:@"尺寸不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    NSString *size = self.orderInfo[@"size"];
    
    if (![size hasSuffix:@"寸"]) {
        self.orderInfo[@"size"] = [size stringByAppendingString:@"寸"];
        
    }
    if ([self.orderInfo[@"version"] isEqualToString:@""]||
        self.orderInfo[@"version"] == nil
        ) {
        [self alertWithMessage:@"型号不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    

    if ([self.orderInfo[@"address"] isEqualToString:@""]||
        self.orderInfo[@"address"] == nil
        ) {
        [self alertWithMessage:@"地址不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    return YES;
}
-(BOOL)isNumber:(NSString*)string{
    NSString *regx = @"[0-9]*[1-9][0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    
    if (![pred evaluateWithObject:string]) {
        return NO;
    }else{
        return YES;
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTF) {
        
        self.orderInfo[@"name"] = textField.text;
    } else if(textField == self.cellphoneTF){
        self.orderInfo[@"cellphone"] = textField.text;
    }else if(textField == self.brandTF){
        self.orderInfo[@"brand"] = textField.text;
    }else if(textField == self.sizeTF){
        self.orderInfo[@"size"] = textField.text;
    }else if(textField == self.addressTF){
        self.orderInfo[@"address"] = textField.text;
    }else if(textField == self.versionTF){
        self.orderInfo[@"version"] = textField.text;
    }

}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)resignKeyboard{
    [self.nameTF resignFirstResponder];
    [self.cellphoneTF resignFirstResponder];
    
    [self.brandTF resignFirstResponder];
    
    [self.sizeTF resignFirstResponder];
    
    [self.addressTF resignFirstResponder];
    [self.versionTF resignFirstResponder];


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
    
    
    NSInteger kMaxLength = 0;
    UITextField *textField = notofication.object;
    
    if (textField == self.nameTF) {
        kMaxLength = 5;
    }else if (textField ==self.cellphoneTF){
        kMaxLength = 11;
        
    }else if (textField ==self.brandTF){
        kMaxLength = 5;

    }else if (textField ==self.sizeTF){
        kMaxLength = 2;

    }else if (textField ==self.versionTF){
        kMaxLength = 20;

    }else if (textField ==self.addressTF){
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
