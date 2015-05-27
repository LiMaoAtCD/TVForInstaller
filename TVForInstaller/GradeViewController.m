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

#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import <MJRefresh.h>
#import "AccountManager.h"



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
    
    
    self.items = [@[] mutableCopy];
    
    __weak GradeViewController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf fetchGrade];

    }];
    

}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView.header beginRefreshing];
}



-(void)fetchGrade{
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = @"获取积分中";
    [hud showInView:self.view animated:YES];
//
    [NetworkingManager fetchGradeByTokenID:[AccountManager getTokenID] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            //error
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.indicatorView = nil;
                hud.textLabel.text = @"获取积分失败";
                
                [hud dismissAfterDelay:2.0];
            });
            
            
        } else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = @"获取成功";
                hud.indicatorView = nil;
                [hud dismissAfterDelay:2.0];
                [self dealResponse:(NSDictionary*)responseObject];

                
                
            });
            
            [self.tableView.header endRefreshing];
        }
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud dismiss];

        [self.tableView.header endRefreshing];

    }];
    
}

-(void)dealResponse:(NSDictionary*)response{
    self.items = response[@"obj"];
    if (self.items.count > 0) {
        [self.tableView reloadData];
    } else{
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20) ];
        label.text =@"没有数据";
        
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        self.tableView.tableFooterView = label;
    }
    
    
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

    if (indexPath.section == 0) {
        GradeTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeTotalTableViewCell" forIndexPath:indexPath];
        cell.totalImage.image =[UIImage imageNamed:@"jifenchaxun1"];
        cell.totalGradeLabel.text = [NSString stringWithFormat:@"%ld", [AccountManager getScore]];
        cell.totalGradeLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else{
        gradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gradeDetailTableViewCell" forIndexPath:indexPath];
        
        NSString *date = self.items[indexPath.row][@"createdate"];
        NSArray *day =[date componentsSeparatedByString:@" "];
        cell.detailDate.text = day[0];
        cell.detailActionLabel.text = self.items[indexPath.row][@"actionname"];
        
        
        cell.detailgradeLabel.text = self.items[indexPath.row][@"addorcutscore"];
        
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor colorWithRed:219.0/255 green:252./255 blue:255./255 alpha:1.0];
        }

        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 61;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
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
