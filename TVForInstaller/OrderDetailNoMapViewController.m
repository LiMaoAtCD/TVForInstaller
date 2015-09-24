//
//  OrderDetailNoMapViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailNoMapViewController.h"
#import "ComminUtility.h"
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

/**
 *  第三个视图模块
 */

@property (weak, nonatomic) IBOutlet UITextField *costTextField;

/**
 *  第四个模块
 */




@end

@implementation OrderDetailNoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    
    [self configFirstModuleView];
    
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
        
        

        
    } else{
    //
    }
    
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
