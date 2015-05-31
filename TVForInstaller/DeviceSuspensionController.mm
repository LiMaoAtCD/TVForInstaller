//
//  DeviceSuspensionController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/28.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "DeviceSuspensionController.h"
#import "SuspensionCell.h"
#import "DeviceSuspensioner.h"
#import "DLNAManager.h"
#import "ComminUtility.h"
#import <MJRefresh.h>

@interface DeviceSuspensionController ()<UITableViewDataSource,UITableViewDelegate,DeviceSuspensionerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *devices;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation DeviceSuspensionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.containerView.layer.cornerRadius = 5.0;
    _containerView.layer.masksToBounds = YES;
    _containerView.alpha = 0.0;
    
    
    __weak DeviceSuspensionController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf updateDevices];
    }];
    
    
}

-(void)updateDevices{
    
    dispatch_queue_t queue = dispatch_queue_create("com.tv.updateDevice", NULL);
    
    dispatch_async(queue, ^{
        
        self.devices = [[DLNAManager DefaultManager] getRendererResources];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];

        });
        

    });
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.devices = [[DLNAManager DefaultManager] getRendererResources];
  
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _containerView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"deviceSuspensioner"]) {
        
        DeviceSuspensioner *des = segue.destinationViewController;
        des.delegate = self;
        
        
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devices.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuspensionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuspensionCell" forIndexPath:indexPath];
    
    if ([[[DLNAManager DefaultManager] getCurrentSpecifiedRenderer] isEqualToString:self.devices[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.deviceNameLabel.text = self.devices[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [[DLNAManager DefaultManager] specifyRendererName:self.devices[indexPath.row]];
    [[NSNotificationCenter defaultCenter]  postNotificationName:[ComminUtility kSuspensionWindowShowNotification] object:nil];
    
    [self.tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"已搜到的设备";
}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)closeSuspension{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//        //取得一个触摸对象（对于多点触摸可能有多个对象）
//        UITouch *touch = obj;
//        //NSLog(@"%@",touch);
//        
//        //取得当前位置
//        CGPoint current=[touch locationInView:self.view];
//        //取得前一个位置
//        CGPoint previous=[touch previousLocationInView:self.view];
//        
//        //移动前的中点位置
//        CGPoint center=self.containerView.center;
//        //移动偏移量
//        CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
//        
//        //重新设置新位置
//        self.containerView.center=CGPointMake(center.x+offset.x, center.y+offset.y);
//        
//    }];
//}


@end
