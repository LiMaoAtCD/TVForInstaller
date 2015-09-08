//
//  QRCodeViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = self.image;
    
    
    if (self.type == WECHAT) {
        self.payTypeLabel.text =@"请使用微信扫码完成支付";
        self.payTypeImageView.image = [UIImage imageNamed:@"ui08_ wechat"];
    } else{
        self.payTypeLabel.text =@"请使用支付宝扫码完成支付";
        self.payTypeImageView.image = [UIImage imageNamed:@"ui08_alipay"];

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
- (IBAction)dismiss:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCloseQRCode)]) {
        [self.delegate didClickCloseQRCode];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
