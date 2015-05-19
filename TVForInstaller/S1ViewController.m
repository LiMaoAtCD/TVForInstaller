//
//  S1ViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "S1ViewController.h"
#import "S1TableViewCell.h"
@interface S1ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation S1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createHeaderView];
    self.tableView.tableFooterView =[[UIView alloc] init];

    
    
}

-(void)createHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 4, 44)];
    label1.text = @"姓名";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font =[UIFont boldSystemFontOfSize:14.0];
    [self.headerView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, 0, self.view.frame.size.width / 4, 44)];
    label2.text = @"当天装机数";
    label2.font =[UIFont boldSystemFontOfSize:14.0];

    label2.textAlignment = NSTextAlignmentCenter;
    
    [self.headerView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2 / 4, 0,self.view.frame.size.width / 4, 44)];
    label3.text = @"当天积分";
    label3.font =[UIFont boldSystemFontOfSize:14.0];

    label3.textAlignment = NSTextAlignmentCenter;
    
    [self.headerView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 3 / 4, 0, self.view.frame.size.width / 4, 44)];
    label4.text = @"当天投诉数";
    label4.font =[UIFont boldSystemFontOfSize:14.0];

    label4.textAlignment = NSTextAlignmentCenter;
    
    [self.headerView addSubview:label4];
    
    
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView  =self.headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    S1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"S1TableViewCell" forIndexPath:indexPath];
    
    cell.nameLabel.text= @"王潇潇";
    cell.installNumber.text = @"3";
    cell.gradeLabel.text =@"32";
    cell.lodgeLabel.text= @"3";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(didSelectionDelegate:)]) {
        [self.delegate didSelectionDelegate:indexPath];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
