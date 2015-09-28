//
//  OrderTypesViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/24.
//  Copyright © 2015年 AlienLi. All rights reserved.
//



//typedef enum : NSUInteger {
//    APP,
//    SCAN_WECHAT,
//    SCAN_ALIPAY,
//    CASH_WECHAT,
//    CASH_ALIPAY
//
//} PAY_TYPE;
typedef enum {
    NONE,
    APP,
    SCAN_WECHAT,
    SCAN_ALIPAY,
    CASH_WECHAT,
    CASH_ALIPAY
} PAY_TYPE;

#import "OrderTypesViewController.h"
#import "ComminUtility.h"
#import "OrderPayTypeSelectionController.h"

#import <Masonry.h>
#import "NetworkingManager.h"
#import <SVProgressHUD.h>


@interface OrderTypesViewController ()<DetailPayTypeDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *PayButtons;


@property (assign, nonatomic) PAY_TYPE type;

@property (assign, nonatomic) NSInteger selectedTag;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView2;

@end

@implementation OrderTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单支付" forViewController:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    
    
}

- (IBAction)clickType:(id)sender {
    
    UIButton *btn = sender;
    _selectedTag = btn.tag;

    switch (btn.tag) {
        case 0:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button  = obj;
                if (button.tag == 0) {
                    [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
                } else{
                [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }
                
            }];
            
            self.type = APP;
        }
            break;
        case 1:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            break;
        case 2:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button  = obj;
                if (button.tag == 2) {
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
            break;
            
        default:
            break;
    }
    
}

-(void)didSelectedPayType:(DetailPayType)type{
    
    switch (_selectedTag) {
        case 1:
        {
            if (type == WECHAT) {
                
                self.typeImageView.image = [UIImage imageNamed:@"ui03_wechat"];
                self.typeImageView2.image = nil;
                self.type = SCAN_WECHAT;
                
            } else{
                self.typeImageView.image = [UIImage imageNamed:@"ui03_alipay"];
                self.typeImageView2.image = nil;
                self.type = SCAN_ALIPAY;

            }
        }
            break;
        case 2:
        {
            if (type == WECHAT) {
                self.typeImageView2.image = [UIImage imageNamed:@"ui03_wechat"];
                self.typeImageView.image = nil;
                self.type = CASH_WECHAT;


            } else{
                self.typeImageView2.image = [UIImage imageNamed:@"ui03_alipay"];
                self.typeImageView.image = nil;
                self.type = CASH_ALIPAY;

            }
        }
            break;
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

@end
