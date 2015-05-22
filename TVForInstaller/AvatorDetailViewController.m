//
//  AvatorDetailViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AvatorDetailViewController.h"

@interface AvatorDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainVIew;

@property (weak, nonatomic) IBOutlet UIView *transparentView;





@end

@implementation AvatorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transparentView.backgroundColor = [UIColor blackColor];
    self.transparentView.alpha = 0.0;
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transparentView.alpha = 0.3;
    }];
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
- (IBAction)takePhoto:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){
        if ([self.delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
            [self.delegate didSelectButtonAtIndex:Camera];
        }
    }];
    
    
}
- (IBAction)getAlbum:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){
        
        if ([self.delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
            [self.delegate didSelectButtonAtIndex:Album];
        }

        
    }];

}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
