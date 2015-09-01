//
//  DeviceViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/20.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "DeviceViewController.h"
#import "ComminUtility.h"
#import <CBStoreHouseRefreshControl.h>
#import "DeviceTableViewCell.h"
#import "DeviceContainer.h"
#import "DLNAManager.h"
#import "DeviceManageCell.h"
#import <MJRefresh.h>

@interface DeviceViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic,strong) NSMutableArray *devices;

@property (nonatomic,strong) DeviceContainer *container;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"设备" forViewController:self];
    
 
    
    
//    self.devices = [[[DLNAManager DefaultManager] getRendererResources] mutableCopy];
//    
//    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    //    footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",self.devices.count];
//    footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",(unsigned long)self.devices.count];
//    footerView.font = [UIFont boldSystemFontOfSize:12.0];
//    footerView.textColor = [UIColor blackColor];
//    footerView.textAlignment = NSTextAlignmentCenter;
//    self.tableView.tableFooterView = footerView;
    
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf updateDevices];
    }];

    [self.tableView.header beginRefreshing];
}

-(void)updateDevices{
    
    self.devices = [[[DLNAManager DefaultManager] getRendererResources] mutableCopy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        //    footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",self.devices.count];
        footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",(unsigned long)self.devices.count];
        footerView.font = [UIFont boldSystemFontOfSize:12.0];
        footerView.textColor = [UIColor blackColor];
        footerView.textAlignment = NSTextAlignmentCenter;
        self.tableView.tableFooterView = footerView;
        
        [self.tableView.header endRefreshing];
    });

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.container.currentDevice.text = [[DLNAManager DefaultManager] getCurrentSpecifiedRenderer];
    

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.devices.count;

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.deviceTitle.text = self.devices[indexPath.row];
        
        if ([[[DLNAManager DefaultManager] getCurrentSpecifiedRenderer] isEqualToString:self.devices[indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
        return cell;
      
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.container.currentDevice.text = self.devices[indexPath.row];
        [[DLNAManager DefaultManager] specifyRendererName:self.devices[indexPath.row]];
        
        [self.tableView reloadData];
    }
   
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (self.devices.count > 0) {
        return @"已找到的设备";
    } else{
        return nil;
    }
  
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *customLabel = [[UILabel alloc] init];
    customLabel.textColor = [UIColor blackColor];
    customLabel.font = [UIFont systemFontOfSize:12.0];
    customLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    return customLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.devices.count > 0) {
        return 20;
    } else{
        return 0.01;
    }}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"deviceSegue"]) {
        self.container = (DeviceContainer *) [segue destinationViewController];
        // do something with the AlerdtView's subviews here...
    }
}



@end
