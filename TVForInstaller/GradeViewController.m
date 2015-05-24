//
//  GradeViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/22.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "GradeViewController.h"
#import "ComminUtility.h"

#import "GradeTotalTableViewCell.h"
#import "gradeDetailTableViewCell.h"


@interface GradeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *items;

@end

@implementation GradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"积分详情" forViewController:self];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    self.items = [@[@"xxx"] mutableCopy];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        return 1;
    }else{
        return self.items.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        GradeTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeTotalTableViewCell" forIndexPath:indexPath];
        cell.totalImage.image =[UIImage imageNamed:@"temp"];
        cell.totalGradeLabel.text = @"9999";
        return cell;
    } else{
        gradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gradeDetailTableViewCell" forIndexPath:indexPath];
        cell.detailDate.text = @"2015-01-01";
        cell.detailActionLabel.text = @"下载视频";
        cell.detailgradeLabel.text = @"10";


        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 3.0;
    }else{
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else{
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        
        view.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, 20)];
        timeLabel.text =@"时间";
        timeLabel.font = [UIFont boldSystemFontOfSize:14.0];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 0, self.view.frame.size.width / 3, 20)];
        actionLabel.text = @"操作";
        actionLabel.font = [UIFont boldSystemFontOfSize:14.0];

        actionLabel.textAlignment = NSTextAlignmentCenter;

        UILabel *gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2 / 3, 0, self.view.frame.size.width / 3, 20)];
        gradeLabel.text = @"积分";
        gradeLabel.font = [UIFont boldSystemFontOfSize:14.0];

        gradeLabel.textAlignment = NSTextAlignmentCenter;

        [view addSubview:timeLabel];
        [view addSubview:actionLabel];
        [view addSubview:gradeLabel];
        
        return view;
        
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
