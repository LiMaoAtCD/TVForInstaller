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
@interface InfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *items;

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
    [button setBackgroundImage:[UIImage imageNamed:@"IdentityBg"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 30);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

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
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

-(void)saveInfo:(UIButton *)button {
    
    
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
