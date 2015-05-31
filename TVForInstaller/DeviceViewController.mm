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
    
 
    
    
    self.devices = [[[DLNAManager DefaultManager] getRendererResources] mutableCopy];
    
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //    footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",self.devices.count];
    footerView.text = [NSString stringWithFormat:@"共搜索到%ld台设备",self.devices.count];
    footerView.font = [UIFont boldSystemFontOfSize:12.0];
    footerView.textColor = [UIColor blackColor];
    footerView.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = footerView;

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
    self.container.currentDevice.text = [[DLNAManager DefaultManager] getCurrentSpecifiedRenderer];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return self.devices.count;

    } else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell" forIndexPath:indexPath];
        cell.deviceTitle.text = self.devices[indexPath.row];
        
        if ([[[DLNAManager DefaultManager] getCurrentSpecifiedRenderer] isEqualToString:self.devices[indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
        return cell;
    } else{
        
        DeviceManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceManageCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"是否开启浮窗模式";
        
        if ([ComminUtility isSwitchKitOn]) {
            
            cell.switchKit.on = YES;
        }else{
            cell.switchKit.on = NO;
        }
        
        [cell.switchKit addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
        
        
        return cell;
    }
   
}

-(void)changeSwitchState:(UISwitch*)kit{
    
    if (kit.isOn) {
        [ComminUtility setSwitchKit:NO];

    }else{
        [ComminUtility setSwitchKit:YES];
        }
    [[NSNotificationCenter defaultCenter] postNotificationName:[ComminUtility kSuspensionWindowNotification] object:nil];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.container.currentDevice.text = self.devices[indexPath.row];
    
    
    [[DLNAManager DefaultManager] specifyRendererName:self.devices[indexPath.row]];
    
    [self.tableView reloadData];
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"已找到的设备";
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
    return 30;
}

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
