//
//  WPStringManager.h
//  wxDemo
//
//  Created by 吴鹏 on 16/8/5.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WPStringManager : NSObject

+ (NSDictionary *)getBiaoQingLocaltiong:(NSString *)message;
+ (CGSize)getStringRect:(NSString*)aString;
+ (NSArray *)htmlAarray:(NSString *)str;
+ (NSArray *)EmotionAarray:(NSString *)str;
+ (NSString *)replaceStr:(NSString *)str;
+ (NSArray *)emailArray:(NSString *)str;
+ (NSArray *)iphoneArray:(NSString *)str;
@end
