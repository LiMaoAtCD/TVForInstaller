//
//  OrderDetailNoMapViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailNoMapViewController.h"
#import "ComminUtility.h"
#import "QRDecodeViewController.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
@interface OrderDetailNoMapViewController ()


/**
 *  第一个视图模块
 */
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *NoLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;

@property (weak, nonatomic) IBOutlet UIButton *navigateButton;

/**
 *  第二个视图模块
 */

@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (nonatomic,copy) NSString * qrcode;


/**
 *  第三个视图模块
 */

@property (weak, nonatomic) IBOutlet UITextField *costTextField;

/**
 *  第四个模块
 */

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkButtons;



@end

@implementation OrderDetailNoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    
    [self configFirstModuleView];
    [self configSecondModuleView];

    
}

-(void)configFirstModuleView{
    
    if (self.order) {
        
        NSInteger type = [self.order[@"orderType"] integerValue];
        
        self.typeImageView.image = [UIImage imageNamed:@""];
        switch (type) {
            case 0:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
            case 1:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
            case 2:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
                
            default:
                break;
        }
        
        //订单时间
        
        self.dateLabel.text = self.order[@"orderTime"];
        
        self.nameLabel.text = self.order[@"name"];
        
        self.cellphoneLabel.text = self.order[@"phone"];
        
        self.addressLabel.text = self.order[@"homeAddress"];
        
        [self.phoneCallButton addTarget:self action:@selector(callAlert:) forControlEvents:UIControlEventTouchUpInside];
        
        //TODO：导航
        
        

        
    } else{
    //
    }
    
}

-(void)configSecondModuleView{
    
    _scanLabel.hidden = YES;
    [_scanButton addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark - target action

-(void)callAlert:(id)sender{
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:self.order[@"phone"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.order[@"phone"]]]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scan qrcode

-(void)scanQRCode:(UIButton *)button{
    QRDecodeViewController *qrcode = [[QRDecodeViewController alloc] init];
    
    [self showDetailViewController:qrcode sender:self];
    //    [self presentViewController:qrcode animated:YES completion:^{
    //        self.navigationController.tabBarController.view.frame = CGRectMake(0, 0, self.navigationController.tabBarController.view.frame.size.width, self.navigationController.tabBarController.view.frame.size.height);
    //    }];
    
    __weak OrderDetailNoMapViewController *weakSelf = self;
    
    qrcode.qrUrlBlock = ^(NSString * code) {
        
        
        [weakSelf uploadDeviceID:code];
//        self.qrcode = code;
        weakSelf.scanLabel.text = code;
        weakSelf.scanLabel.hidden = NO;
        weakSelf.scanButton.hidden = YES;
        
        
    };
}

-(void)uploadDeviceID:(NSString *)deviceID{
    if (deviceID) {
        
        [SVProgressHUD showWithStatus:@"正在上传设备编码"];
        [NetworkingManager uploadDeviceNumber:deviceID orderID:self.order[@"id"] WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 1) {
                self.scanLabel.text = deviceID;
                self.scanLabel.hidden = NO;
                self.scanButton.hidden = YES;
                [SVProgressHUD showSuccessWithStatus:@"二维码上传成功"];

            } else{
            }
            
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
        }];
    }else{
        //没有获取到
        
    }
}



#pragma mark -关闭二维码

-(void)didClickCloseQRCode{
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

@end
