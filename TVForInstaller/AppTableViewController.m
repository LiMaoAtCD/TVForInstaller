//
//  AppTableViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/20.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AppTableViewController.h"

#import "ComminUtility.h"

#import "AppOneInstallCell.h"
#import "AppCollectionTableCell.h"
#import "APPCollectionViewCell.h"

#import "NetworkingManager.h"
#import <JGProgressHUD.h>

#import <UIImageView+WebCache.h>

#import <MJRefresh.h>

@interface AppTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,strong) NSMutableArray *appLists;


@end

@implementation AppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [ComminUtility configureTitle:@"应用" forViewController:self];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    __weak AppTableViewController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf fetchApplicationList];

    }];
    
    [self.tableView.header beginRefreshing];
}



-(void)fetchApplicationList{
    
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = @"正在获取应用列表";
    [hud showInView:self.tableView animated:YES];
    
    
    
    [NetworkingManager fetchApplicationwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud dismiss];
            });
            
            
        } else{
            //获取成功
            
            
            [hud dismiss];
            
            NSArray *temp = responseObject[@"obj"];
            [self dealResponseData:temp];

            
        }
        [self.tableView.header endRefreshing];

        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud dismiss];
        [self.tableView.header endRefreshing];

    }];
}

-(void)dealResponseData:(NSArray *)obj{

    if (obj.count >0) {
        
        _appLists = [obj mutableCopy];
        
        [self.tableView reloadData];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source &delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _appLists.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        AppOneInstallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppOneInstallCell" forIndexPath:indexPath];
        
        return cell;
    } else{
        AppCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCollectionTableCell" forIndexPath:indexPath];
        
        cell.collectionView.tag = indexPath.section -1;
        
        return cell;

    }
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (section ==0 ) {
        return nil;
    } else{
        return _appLists[section -1][@"classify"];
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
    label.text = [self tableView:self.tableView titleForHeaderInSection:section];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    
    UIView *view = [[UIView alloc] init];
    
    [view addSubview:label];
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 83;
    }else {
        return 150;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}





#pragma mark - colleciton dataSource & delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *softList = _appLists[collectionView.tag][@"softlist"];
    return softList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    APPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APPCollectionViewCell" forIndexPath:indexPath];
    
    
    NSString *url = _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softicon"];
    
    NSURL *imageURL = [NSURL URLWithString:url];
    [cell.appImageView sd_setImageWithURL:imageURL placeholderImage:nil];
    
    cell.appNameLabel.text =  _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softname"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString *softwareAddress = _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softaddr"];

    NSLog(@"软件地址：%@",softwareAddress);
    
}

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
