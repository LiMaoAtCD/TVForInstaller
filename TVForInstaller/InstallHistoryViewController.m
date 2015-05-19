//
//  InstallHistoryViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InstallHistoryViewController.h"
#import "InstallHistoryCell.h"
@interface InstallHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *DataItems;

@end

@implementation InstallHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.estimatedRowHeight = 44.;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.DataItems.count;
    return 4;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InstallHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstallHistoryCell" forIndexPath:indexPath];
    
    cell.addressLabel.text = @"dkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkddkjahfahfjahfajkd";
    
    return cell;
    
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
