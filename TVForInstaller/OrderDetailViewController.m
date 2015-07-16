//
//  OrderDetailViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ComminUtility.h"
@interface OrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    [self configOrderContent];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)call:(id)sender {
    
     UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:self.telphone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: 拨打电话
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13568927473"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.telphone]]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (IBAction)confirmOrder:(id)sender {
    
}
- (IBAction)cancelOrder:(id)sender {
}

-(void)configOrderContent{
    if (self.type == TV) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }
    self.nameLabel.text = self.name;
    self.telphoneLabel.text = self.telphone;
    self.addressLabel.text = self.address;
    self.runningNumberLabel.text =self.runningNumber;
    self.dateLabel.text= self.date;
}

@end
