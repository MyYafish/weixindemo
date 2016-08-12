//
//  WPContentLable.m
//  wxDemo
//
//  Created by 吴鹏 on 16/8/8.
//  Copyright © 2016年 wupeng. All rights reserved.
//

#import "WPContentLable.h"
#import "WPStringManager.h"
#import <CoreText/CoreText.h>

@interface WPContentLable ()
{
    CTFrameRef _frame;
}

@property (nonatomic , strong)NSDictionary * dataDic ;

@property (nonatomic , strong) NSMutableArray * array;
@property (nonatomic , strong) NSMutableArray * currentKeyRectArray;
@property (nonatomic , strong) NSDictionary  * attDic;

@end

@implementation WPContentLable

- (id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        NSString *plistPath1 = [[NSBundle mainBundle] pathForResource:@"expressionImage_custom" ofType:@"plist"];
        self.dataDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath1];
        
        self.currentKeyRectArray = [NSMutableArray array];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setMyText:(NSString *)myText
{
    _myText = myText;
    [self.currentKeyRectArray removeAllObjects];
    [self setNeedsDisplay];
}

CTRunDelegateRef newEmotionRunDelegate(){
    
    static NSString *emotionRunName = @"emotionRunName";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = WFRunDelegateDeallocCallback;
    imageCallbacks.getAscent = WFRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = WFRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = WFRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,
                                                       (__bridge void *)(emotionRunName));
    
    return runDelegate;
}

#pragma mark - Run delegate
void WFRunDelegateDeallocCallback( void* refCon ){
}

CGFloat WFRunDelegateGetAscentCallback( void *refCon ){
    return 18;
}

CGFloat WFRunDelegateGetDescentCallback(void *refCon){
    return 0.0;
}

CGFloat WFRunDelegateGetWidthCallback(void *refCon){
    return  18.0;
}

CTRunDelegateRef emotionRunDelegate(){
    
    static NSString *emotionRunName = @"emotionRunName";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = WFRunDelegateDeallocCallback;
    imageCallbacks.getAscent = WFRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = WFRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = WFRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,
                                                       (__bridge void *)(emotionRunName));
    
    return runDelegate;
}

+ (void)emotion:(NSArray *)rangeArray attrString:(NSMutableAttributedString *)attrString
{
    NSMutableString * text = attrString.mutableString;
    NSMutableArray * attstrArray = [NSMutableArray array];
    NSInteger forIndex = 0;
    NSInteger startIndex = -1;
    for(NSInteger k = 0 ; k< rangeArray.count ; k++)
    {
       NSTextCheckingResult * match = rangeArray[k];
        [attstrArray addObject:[text substringWithRange:match.range]];
        
        
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
        
        [attrString replaceCharactersInRange:NSMakeRange(startIndex, matchRange.length) withString:@" "];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)emotionRunDelegate() range:NSMakeRange(startIndex, 1)];
        
        [attrString addAttribute:@"keyAtt" value:@{@"imageName":attstrArray[i]} range:NSMakeRange(startIndex, 1)];
        forIndex += [attstrArray[i] length]-1;
    }
}
- (void)htmlAttString:(NSMutableAttributedString *)attstring htmlArray:(NSArray *)htmlArray
{
    for(NSInteger i = 0 ;i < htmlArray.count ; i++)
    {
        NSTextCheckingResult * match = htmlArray[i];
        [attstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor blueColor].CGColor range:match.range];
        [attstring addAttribute:@"keyAtt" value:@{@"html":[[attstring string] substringWithRange:match.range]} range:match.range];
    }
}

- (void)emailAttString:(NSMutableAttributedString *)attstring emailArray:(NSArray *)htmlArray
{
    for(NSInteger i = 0 ;i < htmlArray.count ; i++)
    {
        NSTextCheckingResult * match = htmlArray[i];
        [attstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor lightGrayColor].CGColor range:match.range];
        [attstring addAttribute:@"keyAtt" value:@{@"html":[[attstring string] substringWithRange:match.range]} range:match.range];
    }
}


- (void)iphoneAttString:(NSMutableAttributedString *)attstring iphoneArray:(NSArray *)htmlArray
{
    for(NSInteger i = 0 ;i < htmlArray.count ; i++)
    {
        NSTextCheckingResult * match = htmlArray[i];
        [attstring addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[UIColor greenColor].CGColor range:match.range];
        [attstring addAttribute:@"keyAtt" value:@{@"html":[[attstring string] substringWithRange:match.range]} range:match.range];
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    NSArray * ima = [WPStringManager EmotionAarray:self.myText];
    NSArray * html = [WPStringManager htmlAarray:self.myText];
    NSArray * emailArray = [WPStringManager emailArray:self.myText];
    NSArray * iphoneArray = [WPStringManager iphoneArray:self.myText];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithAttributedString:[[self class] bulidAttributedStr:self.myText]];
    
    [self htmlAttString:str htmlArray:html];
    [self emailAttString:str emailArray:emailArray];
    [self iphoneAttString:str iphoneArray:iphoneArray];
    [[self class] emotion:ima attrString:str];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, self.backgroundColor.CGColor);
    
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, CGRectGetHeight(self.bounds)); // 此处用计算出来的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGFLOAT_MAX);//CGRectGetHeight(self.bounds)
    
    //创建一个用来描画文字的路径，其区域为当前视图的bounds  CGPath
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, viewRect);
    
    //创建一个framesetter用来管理描画文字的frame  CTFramesetter
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)str);
    
    //创建由framesetter管理的frame，是描画文字的一个视图范围  CTFrame
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), pathRef, nil);
    
    CFArrayRef lines = CTFrameGetLines(frameRef);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), lineOrigins);
    CGFloat frameY = 0;
    CGFloat lineHeight = [UIFont systemFontOfSize:18].lineHeight ;
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint lineOrigin = lineOrigins[i];
        CTLineRef lineRef= CFArrayGetValueAtIndex(lines, i);
        frameY = CGRectGetHeight(self.bounds) - (i + 1)*lineHeight - [UIFont systemFontOfSize:18].descender;
        lineOrigin.y = frameY;
        
        CGContextSetTextPosition(contextRef, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, contextRef);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for (int j = 0; j < CFArrayGetCount(runs); j++)
        {
            CGFloat runAscent;
            CGFloat runDescent;
            //获取每个CTRun
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            //调整CTRun的rect
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y, runRect.size.width, runAscent + runDescent);
            
            NSDictionary * dic = [attributes objectForKey:@"keyAtt"];
            //图片渲染逻辑，把需要被图片替换的字符位置画上图片
            if ([[dic allKeys][0] isEqualToString:@"imageName"])
            {
                UIImage *image = [UIImage imageNamed:[self.dataDic objectForKey:[dic objectForKey:[dic allKeys][0]]]];
                if (image)
                {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(18, 18);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y - 2;
                    CGContextDrawImage(contextRef, imageDrawRect, image.CGImage);
                }
            }else if ([[dic allKeys][0] isEqualToString:@"html"])
            {
                [self.currentKeyRectArray addObject:@{@"rect":[NSValue valueWithCGRect:runRect],
                                                      @"htmlStr":[dic objectForKey:@"html"]}];
            }
        }
    }
    
    
    
    CFRelease(frameRef);
    CFRelease(framesetterRef);
    CFRelease(pathRef);
    
}
+ (NSAttributedString *)bulidAttributedStr:(NSString *)str
{
    UIFont * font = [UIFont systemFontOfSize:18];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attString.length)];
    
    //设置字体颜色
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor whiteColor].CGColor range:NSMakeRange(0,attString.length)];
    
    CFRelease(fontRef);

    
    
    //添加换行模式
    CTParagraphStyleSetting lineBreakStyle;
    CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
    lineBreakStyle.spec        = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakStyle.value       = &lineBreakMode;
    lineBreakStyle.valueSize   = sizeof(CTLineBreakMode);//sizeof(lineBreak);
    
    
    //    const CFIndex kNumberOfSettings = 2;
    CTParagraphStyleSetting settings[] = {lineBreakStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings)/sizeof(settings[0]));
    //    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, kNumberOfSettings);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    
    [attString addAttributes:attributes range:NSMakeRange(0, [attString length])];
    
    return attString;
}

#pragma mark - tap

- (void)tap:(UITapGestureRecognizer *)tap
{
        CGPoint point = [tap locationInView:self];
        CGPoint runLocation = CGPointMake(point.x, self.frame.size.height - point.y);
        
        for(NSInteger i = 0 ;i <self.currentKeyRectArray.count ; i++)
        {
            NSDictionary * dic = self.currentKeyRectArray[i];
            CGRect rect = [[dic objectForKey:@"rect"] CGRectValue];
            if(CGRectContainsPoint(rect, runLocation))
            {
                NSLog(@" 您点击的 %@ ",[dic objectForKey:@"htmlStr"]);
            }
        }
}


@end
