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
@interface PersonalOrderTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray *placeholders;


@property (nonatomic,strong) NSMutableDictionary *orderInfo;

@end

@implementation PersonalOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [ComminUtility configureTitle:@"订单添加" forViewController:self];
    self.items = @[@"姓名",@"电话",@"品牌",@"尺寸",@"支架",@"地址"];
    self.placeholders = @[@"请输入姓名",@"请输入电话",@"请输入品牌",@"请输入尺寸",@"支架",@"请输入地址"];
    self.orderInfo = [NSMutableDictionary new];
    

    
    
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
    imageView.image = [UIImage imageNamed:@"temp"];
    
    [view addSubview:imageView];
    imageView.center = view.center;
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"提交" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"denglu"] forState:UIControlStateNormal];

    button.frame = CGRectInset(view.frame, 10, 5);
    
    [view addSubview:button];
    
    return view;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==4) {
        ZhijiaTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZhijiaTableViewCell" forIndexPath:indexPath];
        [cell.segment addTarget:self action:@selector(chooseZhijia:) forControlEvents:UIControlEventValueChanged];
        cell.segment.selectedSegmentIndex = 0;
        
        return cell;

    }else{
        AddOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddOrderTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.items[indexPath.row];
        cell.textField.placeholder =self.placeholders[indexPath.row];
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
        return cell;

    }

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 0) {
        //姓名
        
        if ([string isEqualToString:@""]) {
            self.orderInfo[@"name"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.orderInfo[@"name"] = [textField.text stringByAppendingString:string];
        }
        
        
    } else if(textField.tag == 1){
        //手机号
        
        if ([string isEqualToString:@""]) {
            self.orderInfo[@"cellphone"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.orderInfo[@"cellphone"] = [textField.text stringByAppendingString:string];
        }
        
        
    } else if(textField.tag == 2){
        //品牌
        if ([string isEqualToString:@""]) {
            self.orderInfo[@"brand"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.orderInfo[@"brand"] = [textField.text stringByAppendingString:string];
        }
    }else if(textField.tag == 3){
        //尺寸
        if ([string isEqualToString:@""]) {
            self.orderInfo[@"size"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.orderInfo[@"size"] = [textField.text stringByAppendingString:string];
        }
    }else if(textField.tag == 4){
        //支架
      
    }else if(textField.tag == 5){
        //品牌
        if ([string isEqualToString:@""]) {
            self.orderInfo[@"address"] = [textField.text substringToIndex:[textField.text length] - 1];
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

@end
