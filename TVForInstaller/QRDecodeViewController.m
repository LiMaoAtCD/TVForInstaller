//
//  QRDecodeViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/8/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "QRDecodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRView.h"

@interface QRDecodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation QRDecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResize;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    
    [_session startRunning];
    
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.view addSubview:qrRectView];
    
    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    pop.frame = CGRectMake(20, 20, 50, 50);
    [pop setTitle:@"取消" forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(closeQRScanWindow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pop];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);
    
    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
}
-(void)closeQRScanWindow:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    
    self.session = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
    }
    
    [self closeQRScanWindow:nil];
    
    
    
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
