//
//  OrderPayTypeSelectionController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/22.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderPayTypeSelectionController.h"

@interface OrderPayTypeSelectionController ()

@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UIView *WeChatView;
@property (weak, nonatomic) IBOutlet UIView *AlipayView;




@end

@implementation OrderPayTypeSelectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _blackView.alpha = 0.0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissSelf)];
    
    [_blackView addGestureRecognizer:tap];
    
    
     UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WeChatViewClicked)];
    
    [_WeChatView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AlipayViewClicked)];
    
    [_AlipayView addGestureRecognizer:tap2];
    
}

-(void)WeChatViewClicked{
    
    self.blackView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedPayType:)]) {
        [self.delegate didSelectedPayType:WECHAT];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)AlipayViewClicked{
    
    self.blackView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedPayType:)]) {
        [self.delegate didSelectedPayType:ALIPay];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dimissSelf{
    self.blackView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(didSelectedPayType:)]) {
        [self.delegate didSelectedPayType:NONE_TYPE];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
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
