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
