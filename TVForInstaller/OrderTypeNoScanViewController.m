//
//  OrderTypeNoScanViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/28.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderTypeNoScanViewController.h"
#import "ComminUtility.h"
#import "NetworkingManager.h"
#import "OrderPayTypeSelectionController.h"
#import "PayType.h"

#import "NetworkingManager.h"
#import <SVProgressHUD.h>


@interface OrderTypeNoScanViewController ()<DetailPayTypeDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectionButtons;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (nonatomic, assign) PAY_TYPE type;


@end

@implementation OrderTypeNoScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [ComminUtility configureTitle:@"订单支付" forViewController:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.type = NONE;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choose:(id)sender {
    
    UIButton *btn = sender;
    
    if (btn.tag == 0) {
        self.type = APP;
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button  = obj;
            if (button.tag == 0) {
                [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
            } else{
                [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
            }
            self.typeImageView.image = nil;
        }];
        

    } else {
        
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button  = obj;
            if (button.tag == 1) {
                [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
            } else{
                [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
            }
        }];
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        OrderPayTypeSelectionController * detail = [sb instantiateViewControllerWithIdentifier:@"OrderPayTypeSelectionController"];
        detail.delegate = self;
        detail.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        
        [self showDetailViewController:detail sender:self];

    }
}

-(void)didSelectedPayType:(DetailPayType)type{
    if (type == WECHAT) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_wechat"];
        self.type = CASH_WECHAT;

    } else if(type == ALIPay){
        self.typeImageView.image = [UIImage imageNamed:@"ui03_alipay"];
        self.type = CASH_ALIPAY;

    } else{
        self.typeImageView.image = nil;
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button  = obj;
            [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
        }];
        self.type = NONE;

    }
}


- (IBAction)confirmPay:(id)sender {
    
    //TODO：根据选择不同，进行不同操作
    
    
    if (_type == APP) {
        [NetworkingManager uploadOrderInfoToAPPWithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject: %@",responseObject);
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } else{
        
    }
  
}

@end
