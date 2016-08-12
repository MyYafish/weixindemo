//
//  WPOutTableViewCell.m
//  wxDemo
//
//  Created by 吴鹏 on 16/8/3.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPOutTableViewCell.h"
#import "WPContentLable.h"

@interface WPOutTableViewCell ()

@property (nonatomic , strong) UIButton * headerImage;
@property (nonatomic , strong) WPContentLable * contentLabel;
@property (nonatomic , strong) UIImageView * backgroudImage;

@end

@implementation WPOutTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.headerImage];
        [self.contentView addSubview:self.backgroudImage];
        [self.backgroudImage addSubview:self.contentLabel];
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

- (WPContentLable *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[WPContentLable alloc]init];
    }
    return _contentLabel;
}

- (UIImageView *)backgroudImage
{
    if(!_backgroudImage)
    {
        _backgroudImage = [[UIImageView alloc]init];
        _backgroudImage.image = [UIImage imageNamed:@"out"];
        _backgroudImage.clipsToBounds  = YES;
        _backgroudImage.userInteractionEnabled = YES;
    }
    return _backgroudImage;
}

#pragma mark - private

- (void)getContenInfo:(WPDataModel *)model
{
    self.backgroudImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60 - model.contentWidth - 35 , -3.5, model.contentWidth + 30, model.contentHeight + 5);
    self.contentLabel.frame = CGRectMake(15, 15, model.contentWidth, model.contentHeight - 25);
    self.contentLabel.myText = model.content;
}

- (void)btnClick
{
    
}

@end
