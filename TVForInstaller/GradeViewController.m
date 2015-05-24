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
#import <CBStoreHouseRefreshControl.h>
#import "AccountManager.h"



@interface GradeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@end

@implementation GradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"积分详情" forViewController:self];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    self.items = [@[] mutableCopy];
    

    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor whiteColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
}


-(void)refreshTriggered:(id)sender{
    
    [self fetchGrade];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [self.tableView setContentOffset:CGPointMake(0, -150) animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.storeHouseRefreshControl scrollViewDidEndDragging];

    });
    
    


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
                [self.storeHouseRefreshControl finishingLoading];
            });
            
            
        } else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = @"获取成功";
                hud.indicatorView = nil;
                [hud dismissAfterDelay:2.0];
                [self.storeHouseRefreshControl finishingLoading];
                [self dealResponse:(NSDictionary*)responseObject];

                
                
            });
        }
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud dismiss];
        [self.storeHouseRefreshControl finishingLoading];
        
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
        cell.totalImage.image =[UIImage imageNamed:@"temp"];
        cell.totalGradeLabel.text = @"9999";
        return cell;
    } else{
        gradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gradeDetailTableViewCell" forIndexPath:indexPath];
        cell.detailDate.text = self.items[indexPath.row][@"createdate"];
        cell.detailActionLabel.text = self.items[indexPath.row][@"actioncode"];
        cell.detailgradeLabel.text = self.items[indexPath.row][@"addorcutscore"];


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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

@end
