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
    
    self.devices = [[DLNAManager DefaultManager] getRendererResources];
    
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
    
    
    cell.deviceNameLabel.text = self.devices[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeSuspension];
    
}


-(void)closeSuspension{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
