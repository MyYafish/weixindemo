//
//  WPOutOrComeinImageTableViewCell.m
//  wxDemo
//
//  Created by 吴鹏 on 16/8/3.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPOutOrComeinImageTableViewCell.h"
#import "WPImageViewBtn.h"

@interface WPOutOrComeinImageTableViewCell ()

@property (nonatomic , strong) WPImageViewBtn * imageBtn;
@property (nonatomic , strong) UIButton * headerImage;

@end

@implementation WPOutOrComeinImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.headerImage];
    }
    return self;
}

#pragma mark - property

- (UIButton *)headerImage
{
    if(!_headerImage)
    {
        _headerImage = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10 -40, 0, 40, 40)];
        [_headerImage setBackgroundImage:[UIImage imageNamed:@"header"] forState:UIControlStateNormal];
        [_headerImage addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerImage;
}

- (void)imageViewGetInfo:(WPDataModel *)model
{
    for(UIView * view in self.contentView.subviews)
    {
        if([view isKindOfClass:[WPImageViewBtn class]])
            [view removeFromSuperview];
    }
    
    self.imageBtn = [[WPImageViewBtn alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60 - model.contentWidth, -3 ,model.contentWidth , model.contentHeight)];
    [self.contentView addSubview:self.imageBtn];
    [_imageBtn setBackgroundImage:model.content forState:UIControlStateNormal];
}
//指定宽度按比例缩放

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)btnClick
{
    
}

@end
