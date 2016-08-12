//
//  WPStringManager.m
//  wxDemo
//
//  Created by 吴鹏 on 16/8/5.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPStringManager.h"
#import <CoreText/CoreText.h>
#import "WPContentLable.h"

@implementation WPStringManager

+ (NSDictionary *)getBiaoQingLocaltiong:(NSString *)message
{
    
    NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"expressionImage_custom" ofType:@"plist"];
    NSDictionary * dataDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath1];
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    
    for(NSInteger i =0 ; i < message.length ; i++)
    {
        if([[message substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"["])
        {
            [array addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        
        if([[message substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"]"])
        {
            [array1 addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    
    NSMutableAttributedString * newStr = [[NSMutableAttributedString alloc]initWithString:message];
    NSString * oldStr = [NSString stringWithFormat:@"%@",message];
    
//    for(NSInteger j = array.count-1 ; j >= 0 ; j--)
//    {
//        NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
//        UIImage *img;
//        img = [UIImage imageNamed:dataDic[[message substringWithRange:NSMakeRange([array[j] integerValue], [array1[j] integerValue] - [array[j] integerValue] +1)]]];
//        attachment.image=img;
//        attachment.bounds=CGRectMake(0, 0, 18, 18);
//        NSAttributedString *text=[NSAttributedString attributedStringWithAttachment:attachment];
//        
//       oldStr = [oldStr stringByReplacingOccurrencesOfString:[message substringWithRange:NSMakeRange([array[j] integerValue], [array1[j] integerValue] - [array[j] integerValue] +1)] withString:@"我"];
//        [newStr replaceCharactersInRange:NSMakeRange([array[j] integerValue], [array1[j] integerValue] - [array[j] integerValue] +1) withAttributedString:text];
//    }
//    
    NSDictionary * dic = @{@"contentStr":newStr,
                           @"blankContentStr":[[WPContentLable bulidAttributedStr:oldStr] string]};
    
    return dic;
}
+ (CGSize)getStringRect:(NSString*)aString

{
    UIFont * font = [UIFont systemFontOfSize:18];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: (__bridge id)fontRef,
                                NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize retSize = [aString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 120 - 35, 20000) options:
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    
    return retSize;
    
}

+ (NSString *)replaceStr:(NSString *)str
{
    NSArray * rangeArray = [[self class] EmotionAarray:str];
    NSInteger forIndex = 0;
    NSInteger startIndex = -1;
    NSMutableArray * attstrArray = [NSMutableArray array];
    
    for(NSInteger k = 0 ; k< rangeArray.count ; k++)
    {
        NSTextCheckingResult * match = rangeArray[k];
        [attstrArray addObject:[str substringWithRange:match.range]];
        
        
    }
    
    for(NSInteger i = 0; i < rangeArray.count; i++)
    {
        NSTextCheckingResult * match = rangeArray[i];
        NSRange matchRange = match.range;
        if(startIndex == -1){
            startIndex = matchRange.location;
        }else{
            startIndex = matchRange.location-forIndex;
        }
        
        str = [str stringByReplacingOccurrencesOfString:attstrArray[i] withString:@"我"];
        forIndex += [attstrArray[i] length]-1;
    }
    return str;
}

+ (NSArray *)htmlAarray:(NSString *)str
{
    NSError *error;
    NSString *regulaStr = [NSString stringWithFormat:@"(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))",@"%",@"%",@"%",@"%"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    return arrayOfAllMatches;

}

+ (NSArray *)EmotionAarray:(NSString *)str
{
    NSError *error;
    NSString *regulaStr = [NSString stringWithFormat:@"\\[\\w+\\]"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    return arrayOfAllMatches;
    
}

+ (NSArray *)emailArray:(NSString *)str
{
    NSError *error;
    NSString *regulaStr = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    return arrayOfAllMatches;
}

+ (NSArray *)iphoneArray:(NSString *)str
{
    NSError *error;
    NSString *regulaStr = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    return arrayOfAllMatches;
}



@end
