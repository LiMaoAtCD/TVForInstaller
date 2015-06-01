//
//  GenderViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/29.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha = 0.3;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseMale:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        [self.delegate didSelectedType:Male];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)chooseFemale:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        [self.delegate didSelectedType:Female];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
- (IBAction)cancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
        [self.delegate didSelectedType:Cancel];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
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
