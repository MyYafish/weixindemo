//
//  WPContentLable.h
//  wxDemo
//
//  Created by 吴鹏 on 16/8/8.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WPContentLable : UIView

+ (NSAttributedString *)bulidAttributedStr:(NSString *)str;
+ (void)emotion:(NSArray *)rangeArray attrString:(NSMutableAttributedString *)attrString;

@property (nonatomic , strong) NSString * myText;

@end
