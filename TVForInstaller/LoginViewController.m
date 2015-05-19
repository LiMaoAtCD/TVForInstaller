//
//  LoginViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *CellularTextField;
@property (weak, nonatomic) IBOutlet UIView *CellularView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
    
    self.CellularView.backgroundColor = [UIColor grayColor];
    self.passwordView.backgroundColor = [UIColor grayColor];

}

-(void)dismissKeyboard:(id)sender{
    
    [self.CellularTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}




-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.CellularTextField) {
        
        self.CellularView.backgroundColor = [UIColor greenColor];
        self.passwordView.backgroundColor = [UIColor grayColor];

    } else if (textField == self.passwordTextField){
        
        self.CellularView.backgroundColor = [UIColor grayColor];
        self.passwordView.backgroundColor = [UIColor greenColor];
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

- (IBAction)Login:(id)sender {
    //TODO:
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
