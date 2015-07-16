//
//  CustomAnnotationView.m
//  IphoneMapSdkDemo
//
//  Created by AlienLi on 15/7/15.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
    }
    return self;
}

//- (void)setAnnotationImages:(NSMutableArray *)images {
//    _annotationImages = images;
//    [self updateImageView];
//}
//
//- (void)updateImageView {
//    if ([_annotationImageView isAnimating]) {
//        [_annotationImageView stopAnimating];
//    }
//    
//    _annotationImageView.animationImages = _annotationImages;
//    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
//    _annotationImageView.animationRepeatCount = 0;
//    [_annotationImageView startAnimating];
//}


@end
